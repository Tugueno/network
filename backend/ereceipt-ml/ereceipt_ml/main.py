import io
import os
import re
import sqlite3
from fastapi import FastAPI, File, UploadFile, BackgroundTasks
from pydantic import BaseModel
import pdfplumber
from PIL import Image, ImageOps, ImageFilter
import pytesseract

from infer import load_model, parse_with_crf
from features_crf import clean_digits

app = FastAPI()
DB_FILE = "receipt_data.db"
MODEL_FILE = "crf_model.pkl"

# Моделийг серверийн эхлэлд нэг л удаа ачаална (хүсэлт бүрт дахин ачаалахгүй)
_crf_model = None
if os.path.exists(MODEL_FILE):
    _crf_model = load_model(MODEL_FILE)


def ensure_db():
    conn = sqlite3.connect(DB_FILE)
    conn.execute("""
        CREATE TABLE IF NOT EXISTS history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            raw_text TEXT,
            corrected_ddtd TEXT,
            corrected_amount TEXT
        )
    """)
    conn.commit()
    conn.close()


ensure_db()


class FeedbackModel(BaseModel):
    raw_text: str
    corrected_ddtd: str
    corrected_amount: str


def auto_retrain():
    """Хэрэглэгчийн засварласан бодит датаг synthetic дататай хамт ашиглаж CRF-ийг дахин сургана."""
    global _crf_model
    try:
        from generate_data import generate_dataset
        from features_crf import build_dataset_for_crf
        import sklearn_crfsuite
        import pickle

        conn = sqlite3.connect(DB_FILE)
        cursor = conn.cursor()
        cursor.execute("SELECT raw_text, corrected_ddtd, corrected_amount FROM history")
        rows = cursor.fetchall()
        conn.close()

        real_samples = []
        for raw_text, ddtd, amount in rows:
            clean_ddtd = clean_digits(ddtd)
            clean_amount = re.sub(r"[^\d]", "", amount)
            if clean_ddtd and clean_amount:
                real_samples.append({
                    "raw_text": raw_text,
                    "ddtd": clean_ddtd,
                    "amount": clean_amount,
                })

        # Synthetic датаг үндэс болгож, бодит фидбэкийг нэмж сургана
        # (бодит дата цөөхөн үед synthetic нь тогтвортой байдлыг хангана)
        synthetic = generate_dataset(300)
        all_samples = synthetic + real_samples * 5  # бодит жишээг илүү жинтэй болгоно

        X, y = build_dataset_for_crf(all_samples)
        crf = sklearn_crfsuite.CRF(
            algorithm="lbfgs", c1=0.1, c2=0.1,
            max_iterations=100, all_possible_transitions=True,
        )
        crf.fit(X, y)

        with open(MODEL_FILE, "wb") as f:
            pickle.dump(crf, f)

        _crf_model = crf
        print(f"[AUTO RETRAIN] Амжилттай. Бодит жишээ: {len(real_samples)}")
    except Exception as e:
        print(f"[AUTO RETRAIN ERROR] {e}")


@app.post("/feedback")
async def save_feedback(data: FeedbackModel, background_tasks: BackgroundTasks):
    try:
        clean_ddtd = data.corrected_ddtd.replace("[", "").replace("]", "").replace("'", "").strip()
        conn = sqlite3.connect(DB_FILE)
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO history (raw_text, corrected_ddtd, corrected_amount) VALUES (?, ?, ?)",
            (data.raw_text, clean_ddtd, data.corrected_amount)
        )
        conn.commit()
        conn.close()
        print(f"\n[FEEDBACK] Шинэ жишээ орлоо. Дүн: {data.corrected_amount}")
        background_tasks.add_task(auto_retrain)
        return {"status": "success", "message": "Хадгалагдлаа. Модель дэвсгэрт дахин сурч байна."}
    except Exception as e:
        return {"status": "error", "message": str(e)}


# --- НАЙДВАРТАЙ REGEX FALLBACK (CRF ямар нэг шалтгаанаар ажиллахгүй бол) ---
def parse_with_regex(text: str) -> dict:
    ddtd_number = "Not found"
    ebarimt_amount = "Not found"

    clean_text = text.lower().replace(" ", "").replace("\t", "")
    ddtd_matches = re.findall(r'\d{20,35}', clean_text)
    if ddtd_matches:
        ddtd_number = str(ddtd_matches[0])
    lines = [line.strip() for line in text.split("\n") if line.strip()]
    found_amounts = []
    for i, line in enumerate(lines):
        line_lower = line.lower().replace(" ", "")
        if any(kw in line_lower for kw in ["ebarimt", "hutt", "хаах", "дүн", "нийт", "dun", "niit"]):
            for offset in range(0, 4):
                if i + offset < len(lines):
                    check_line = lines[i + offset]
                    amount_match = re.search(r'\b\d{1,3}(?:[,\'\s.]\d{3})+\b|\b\d{3,7}\b', check_line)
                    if amount_match:
                        val = amount_match.group(0)
                        clean_val = val.replace(",", "").replace("'", "").replace(" ", "").replace(".", "")
                        if clean_val.isdigit() and 3 <= len(clean_val) <= 7:
                            found_amounts.append(val)
    if found_amounts:
        ebarimt_amount = found_amounts[-1]

    return {"ddtd": str(ddtd_number), "ebarimt_amount": str(ebarimt_amount)}


def auto_rotate(img: Image.Image) -> Image.Image:
    """Хэвтээ/эргэсэн зурган баримтыг таньж, зөв босоо чиглэлд эргүүлнэ.
    Tesseract-ийн OSD (Orientation and Script Detection) ашиглана."""
    try:
        osd = pytesseract.image_to_osd(img, config="--psm 0")
        rotate = 0
        for line in osd.split("\n"):
            if line.startswith("Rotate:"):
                rotate = int(line.split(":")[1].strip())
        if rotate != 0:
            img = img.rotate(-rotate, expand=True)
    except Exception as e:
        print(f"[AUTO ROTATE] Илрүүлж чадсангүй, эх байдлаар үргэлжлүүлнэ: {e}")
    return img


def enhance_for_ocr(img: Image.Image) -> Image.Image:
    """Хуучирсан/бүдгэрсэн баримтын зурган дээр OCR-ийн чанарыг сайжруулна:
    grayscale -> contrast stretch -> sharpen -> томруулах."""
    img = img.convert("L")
    img = ImageOps.autocontrast(img, cutoff=2)
    img = img.filter(ImageFilter.SHARPEN)
    if max(img.size) < 2500:
        img = img.resize((int(img.width * 1.3), int(img.height * 1.3)), Image.LANCZOS)
    return img


@app.post("/extract-receipt")
async def extract_receipt(file: UploadFile = File(...)):
    filename = file.filename.lower()
    contents = await file.read()
    text = ""
    text_raw = text_enhanced = ""
    if filename.endswith(".pdf"):
        with pdfplumber.open(io.BytesIO(contents)) as pdf:
            for page in pdf.pages:
                text += (page.extract_text() or "") + "\n"
        text_raw = text_enhanced = text
    else:
        img = Image.open(io.BytesIO(contents))
        img = auto_rotate(img)  # хэвтээ/эргэсэн зургийг эхлээд засна
        # Эхлээд эх зурган дээр, дараа нь сайжруулсан хувилбар дээр уншиж,
        # алийг нь илүү бүрэн гүйцэд уншсаныг сонгоно (хуучирсан/бүдгэрсэн
        # баримтын хувьд сайжруулалт ихэвчлэн туслана, гэхдээ зарим үед эх
        # зураг өөрөө илүү тод байдаг тул хоёуланг нь туршиж үзэх нь найдвартай).
        text_raw = pytesseract.image_to_string(img, config="-l mon+eng --psm 4")
        text_enhanced = pytesseract.image_to_string(
            enhance_for_ocr(img), config="-l mon+eng --psm 4"
        )
        text = text_enhanced if len(text_enhanced) > len(text_raw) * 0.8 else text_raw

    print("\n================ RAW RECEIPT TEXT ================")
    print(text)
    print("==================================================\n")

    if _crf_model is not None:
        result = parse_with_crf(text, crf=_crf_model)
        if result["ddtd"] == "Not found" or result["ebarimt_amount"] == "Not found":
            # Нэг хувилбараар олдоогүй бол нөгөө хувилбарыг (raw/enhanced) дахин туршина
            alt_text = text_raw if text == text_enhanced else text_enhanced
            alt_result = parse_with_crf(alt_text, crf=_crf_model)
            if result["ddtd"] == "Not found" and alt_result["ddtd"] != "Not found":
                result["ddtd"] = alt_result["ddtd"]
            if result["ebarimt_amount"] == "Not found" and alt_result["ebarimt_amount"] != "Not found":
                result["ebarimt_amount"] = alt_result["ebarimt_amount"]
        if result["ddtd"] == "Not found" or result["ebarimt_amount"] == "Not found":
            fallback = parse_with_regex(text)
            if result["ddtd"] == "Not found":
                result["ddtd"] = fallback["ddtd"]
            if result["ebarimt_amount"] == "Not found":
                result["ebarimt_amount"] = fallback["ebarimt_amount"]
    else:
        result = parse_with_regex(text)

    return {"status": "success", "raw_text": text, "data": result}

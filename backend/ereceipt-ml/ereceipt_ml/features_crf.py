# -*- coding: utf-8 -*-
import re

DDTD_KEYWORDS = ["ддтд", "дата", "hata", "ттд"]
AMOUNT_KEYWORDS = ["төлөх", "нийт", "дүн", "amount", "ebarimt", "барим"]

# OCR ихэвчлэн Кирилл үсгийг адилхан харагдах Latin үсэгтэй андуурдаг
# (жишээ нь "ДАТА" -> "DATA"). Keyword шалгахын өмнө эдгээрийг Кирилл рүү нормализна.
_LATIN_TO_CYRILLIC = str.maketrans({
    "A": "А", "a": "а", "B": "В", "E": "Е", "e": "е", "K": "К", "k": "к",
    "M": "М", "H": "Н", "O": "О", "o": "о", "P": "Р", "p": "р", "C": "С",
    "c": "с", "T": "Т", "t": "т", "X": "Х", "x": "х", "Y": "У", "y": "у",
    "D": "Д", "d": "д",
})


def normalize_ocr_confusables(text):
    return text.translate(_LATIN_TO_CYRILLIC)


def clean_digits(s):
    return re.sub(r"[^0-9]", "", s)


def normalize_amount(raw):
    """Мөнгөн дүнг '.' тэмдэгтийг **аравтын бутархай** гэдгийг зөв ойлгож задална.
    - Бутархай хэсэг бүхэлдээ 0 бол (жишээ нь '.00') хасна: '39,939.00' -> '39939'
    - Бутархай хэсэг 0-ээс их бол хадгална: '39,939.50' -> '39939.50'
    - Бутархайгүй бол өөрчлөгдөхгүй: '39,939' -> '39939'
    """
    s = raw.strip().replace(",", "").replace(" ", "").replace("'", "")
    s = re.sub(r"[^0-9.]", "", s)
    if not s:
        return ""
    if "." in s:
        int_part, _, frac_part = s.partition(".")
        int_part = int_part.lstrip("0") or "0"
        if frac_part and set(frac_part) != {"0"}:
            return f"{int_part}.{frac_part}"
        return int_part
    return s.lstrip("0") or "0"


# Хуучин нэрээр дуудагдаж болзошгүй тул alias үлдээв
def clean_amount_digits(tok):
    return normalize_amount(tok)


def line_has_keyword(line, keywords):
    low = line.lower()
    norm = normalize_ocr_confusables(low)
    return any(kw in low or kw in norm for kw in keywords)


def tokenize_lines(text):
    """Мөр бүрийг токенжуулж, (line_idx, token_idx, token) хэлбэрээр буцаана."""
    lines = text.split("\n")
    return lines


def token_features(lines, li, ti, tokens):
    tok = tokens[ti]
    digits = clean_digits(tok)
    prev_tok = tokens[ti - 1] if ti > 0 else "<START>"
    next_tok = tokens[ti + 1] if ti < len(tokens) - 1 else "<END>"

    prev_line = lines[li - 1] if li > 0 else ""
    cur_line = lines[li]
    next_line = lines[li + 1] if li < len(lines) - 1 else ""

    feats = {
        "word": tok,
        "word.lower": tok.lower(),
        "prev_word": prev_tok.lower(),
        "next_word": next_tok.lower(),
        "is_digit_run": digits.isdigit() and len(digits) >= 3,
        "digit_len": len(digits) if digits.isdigit() else 0,
        "digit_len_bucket": min(len(digits) // 5, 8) if digits.isdigit() else 0,
        "has_comma": "," in tok,
        "has_colon_prefix": tok.lower().startswith(("ддтд", "дата", "hata")),
        "cur_line_has_ddtd_kw": line_has_keyword(cur_line, DDTD_KEYWORDS),
        "cur_line_has_amount_kw": line_has_keyword(cur_line, AMOUNT_KEYWORDS),
        "prev_line_has_ddtd_kw": line_has_keyword(prev_line, DDTD_KEYWORDS),
        "prev_line_has_amount_kw": line_has_keyword(prev_line, AMOUNT_KEYWORDS),
        "next_line_has_ddtd_kw": line_has_keyword(next_line, DDTD_KEYWORDS),
        "next_line_has_amount_kw": line_has_keyword(next_line, AMOUNT_KEYWORDS),
        "line_pos_ratio_bucket": round(li / max(1, len(lines)), 1),
        "token_pos_in_line": ti,
        "is_last_token_in_line": ti == len(tokens) - 1,
    }
    return feats


def line_to_features(lines, li):
    tokens = lines[li].split()
    if not tokens:
        return [], []
    feats = [token_features(lines, li, ti, tokens) for ti in range(len(tokens))]
    return tokens, feats


def label_tokens(tokens, ddtd_value, amount_value):
    """Ground truth утгатай яг таарч байгаа digit-token бүрийг тэмдэглэнэ.
    ДДТД урт тоо 2 token болж нугалагдсан ч (жишээ нь чекийн цаас нарийн тул)
    хэсэгчлэн таарч байвал бас DDTD гэж тэмдэглэнэ (min 6 оронтой давхцал).
    Дүнг normalize_amount-аар харьцуулж, '.00' бутархайг үл тоомсорлоно,
    харин 0-ээс их бутархайг зөв ялгана."""
    labels = []
    amount_norm = normalize_amount(str(amount_value))
    for tok in tokens:
        d = clean_digits(tok)
        tok_amount_norm = normalize_amount(tok)
        is_ddtd_fragment = (
            len(d) >= 6 and (d == ddtd_value or d in ddtd_value)
        )
        if is_ddtd_fragment:
            labels.append("DDTD")
        elif tok_amount_norm and tok_amount_norm == amount_norm:
            labels.append("AMOUNT")
        else:
            labels.append("O")
    return labels


def build_dataset_for_crf(samples):
    """samples: list of {raw_text, ddtd, amount} -> (X, y) sentence-level lists for CRF."""
    X, y = [], []
    for s in samples:
        lines = tokenize_lines(s["raw_text"])
        for li in range(len(lines)):
            tokens, feats = line_to_features(lines, li)
            if not tokens:
                continue
            labels = label_tokens(tokens, s["ddtd"], s["amount"])
            X.append(feats)
            y.append(labels)
    return X, y

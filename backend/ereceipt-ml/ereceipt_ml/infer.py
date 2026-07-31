# -*- coding: utf-8 -*-
import pickle
from collections import Counter
from features_crf import tokenize_lines, line_to_features, clean_digits, clean_amount_digits


def load_model(path="crf_model.pkl"):
    with open(path, "rb") as f:
        return pickle.load(f)


def parse_with_crf(text: str, crf=None, model_path="crf_model.pkl") -> dict:
    if crf is None:
        crf = load_model(model_path)

    lines = tokenize_lines(text)
    amount_candidates = []
    ddtd_groups = []
    current_group = []

    for li in range(len(lines)):
        tokens, feats = line_to_features(lines, li)
        if not tokens:
            if current_group:
                ddtd_groups.append("".join(current_group))
                current_group = []
            continue
        preds = crf.predict_single(feats)
        for tok, label in zip(tokens, preds):
            digits = clean_digits(tok)
            if label == "DDTD" and digits:
                current_group.append(digits)
            else:
                if current_group:
                    ddtd_groups.append("".join(current_group))
                    current_group = []
                if label == "AMOUNT" and digits:
                    amt = clean_amount_digits(tok)
                    amount_candidates.append(amt if amt else digits.lstrip("0") or "0")

    if current_group:
        ddtd_groups.append("".join(current_group))

    result = {"ddtd": "Not found", "ebarimt_amount": "Not found"}

    if ddtd_groups:
        result["ddtd"] = max(ddtd_groups, key=len)

    if amount_candidates:
        result["ebarimt_amount"] = Counter(amount_candidates).most_common(1)[0][0]

    return result


if __name__ == "__main__":
    crf = load_model()

    # Танай 4 бодит зурган дээрх текстийг OCR унших үеийн шиг (алдаа/шуугиантай) бэлдэв
    real_receipts = {
        "ТЭС (зураг 1)": """ТЭС
Баян-Өлгий аймгийн Өлгий сум 13-р
баг Улаанбаатар явах зам дагуу

Касс: ШТС-89
Пос: 8902
Карт#: 212260
Компани#: Тэс Петролиум ХХК

Огноo: 2026-07-15 19:19:33
Байгууллага: 5255961 / Нэт капитал
финанс корпораци ББСБ

Бараа       Үнэ    Тоо    Дүн
Регуляр-92  3,400  39.72  135,048

Нийт дүн:                  135,048
НӨАТ:                      12,277.09
НХАТ:                      0.00
Төлөх дүн:                 135,048
Бэлэн:                     135,048

Сугалааны дугаар

ebarimt.mn
бүртгүүлэх дүн:
135,048
03110124224591109686138651000867 1""",

        "Глобал молл (зураг 2)": """Глобал молл
Борлуулагч          ТТД:51101265861
ДДТД
05110126586100 10969800158100 45937
Огноо:              2026/07/27 13:15:22
№: 58080           Касс: 8002

№ Бараа              Тоо   Үнэ    Дүн
1 Ундаа - Pepsi 500мл
                      1    2040   2040

Нийт:                 1    2040

Төлөх дүн :                2,040
Банкаар(Худалдаа хөгжлийн б):2,040
НӨАТ 10% :                  185

Card:535385979***9063
Card Exp:2901
RRN:002332667874
Terminal:89001925    APPR:854069
Amount:2040

Гарын үсэг: ______________

Сугалаа NF 82277466
ebarimt-д бүртгүүлэх дүн
2,040""",

        "ХМ Наадам (зураг 3)": """ХМ Наадам центр                2026.06.30 09:06
ТТД: 7173713                   ПОС: 3111
Худалдан авагч ТТД: 5255961     NC2
# 0906 1654 3111                1-р хувь

Код  Бараа            Тоо   Нэгж үнэ   Дүн
ДДТД: 02520034904009509671000121 0028512
ND36 Тор том           1     449        449
ND10 Эрдэнэшиш Асс     3     2,968      8,904
ND10 Туна Royalty 400гр 1    14,980     14,980
ND06 Майонез           1     3,828      3,828
ND07 Талх Амтат 600гр  2     3,268      6,536
ND07 Талх Мишээл 600гр 1     3,828      3,828
ND15 Хиам 400гр        1     14,780     14,780
ДДТД: 11074502010909509671 0000010028512
NC40 Улаан лооль кг    0.505 10,480     5,292
ДДТД: 11221363039109509671 0000010028512
сп29 Алим примо        1.44  12,980     18,691
сп29 Амтат гуа         1.555 7,188      11,177

                       НӨАТ-гүй Дүн
ДДТД: 08000104163509509671 0000010028512
CN33 Өргөст хэмх Монгол 0.405 10,280    4,163

НИЙТ ДҮН:              11 төрөл  92,628
Төлөх:                           92,628
Карт:                            92,628

ХААН ТЕРМИНАЛ: 70202507   483807xxxxxx4163
ГҮЙЛГЭЭ.Д: 007862445946   ЗӨВШ.КОД: 195730
ДҮН: 92,628.00           Contact Less Pin Verified
ДАТА: 02310149560950967100014 10028512

СУГАЛААНЫ ДУГААР
ebarimt бүртгүүлэх дүн
92,628
Таны санал бидний зорилго 1800 2888""",

        "GS25 (зураг 4)": """GS25 Lifestyle Platform      www.GS25.mn
НМТАУЭР                       76092525
Дижитал Концепт ХХК            6531342
ХУД 15-р хороо НМ тауэр 31-2 тоот
ДДТД:06020085910010109700005181 0022537
2026/07/29     НМТАУЭР                NO:23518

Ундаа Pepsi лаймтай 500мл пет  1     2,500
Нийт тоо/дүн                    1     2,500

Нийт НӨАТ-гүй дүн                    2,272.73
НӨАТ                                 227.27
Нийт                                 2,500
Төлбөрийн карт                        2,500

[ Credit Card Detail ]
CardNumer          535385XXXXXX9063
Amount                              2,500
RRN                007933036144

Сугалааны дугаар
BP 73829309
EBarimt-ын дүн
2,500""",
    }

    for name, text in real_receipts.items():
        result = parse_with_crf(text, crf=crf)
        print(f"--- {name} ---")
        print("  ДДТД  :", result["ddtd"])
        print("  Дүн   :", result["ebarimt_amount"])
        print()

# -*- coding: utf-8 -*-
import random
import re
from templates import TEMPLATES

random.seed(42)

COMPANIES = ["ТЭС Петролиум", "Petro China", "Шунхлай ГТС", "MogulAir ШТС"]


def rand_digits(n):
    return "".join(str(random.randint(0, 9)) for _ in range(n))


def rand_date():
    y = random.choice([2025, 2026])
    m = random.randint(1, 12)
    d = random.randint(1, 28)
    h = random.randint(0, 23)
    mi = random.randint(0, 59)
    fmt = random.choice(["{y}-{m:02d}-{d:02d} {h:02d}:{mi:02d}:00",
                          "{y}/{m:02d}/{d:02d} {h:02d}:{mi:02d}"])
    return fmt.format(y=y, m=m, d=d, h=h, mi=mi)


def rand_amount():
    base = random.randint(1, 900) * random.choice([1, 10, 100])
    return base


def fmt_amount(v, decimal_frac=None):
    """decimal_frac: None -> бутархайгүй, '00' -> тэг бутархай (харагдахад
    гарна ч ground truth-д алга болно), '01'-'99' -> бодит бутархай."""
    s = f"{v:,}"
    if decimal_frac is not None:
        s += f".{decimal_frac}"
    return s


def maybe_typo(text):
    """OCR-д түгээмэл гардаг зарим бодит алдааг санамсаргүй нэмнэ (зурган дээрх шиг)."""
    subs = [
        ("ДДТД", "ДАТА"),
        ("Огноо", "Огноo"),
        ("Асе", "Асс"),
        ("НӨАТ", "HOAT"),
    ]
    if random.random() < 0.25:
        a, b = random.choice(subs)
        text = text.replace(a, b, 1)
    return text


def generate_one():
    tmpl_idx = random.randint(0, len(TEMPLATES) - 1)
    tmpl = TEMPLATES[tmpl_idx]

    ddtd = rand_digits(random.choice([27, 30, 32, 33]))
    amount_val = rand_amount()

    # Бутархайн 3 тохиолдол: байхгүй / тэг (.00) / бодит (.XX эсвэл .X)
    r = random.random()
    if r < 0.4:
        decimal_frac = None
    elif r < 0.7:
        decimal_frac = "00"
    else:
        decimal_frac = f"{random.randint(1, 99):02d}"

    amount = fmt_amount(amount_val, decimal_frac=decimal_frac)
    amount_nodot = str(int(amount_val * random.uniform(0.85, 0.95)))
    vat = fmt_amount(int(amount_val * 0.1))
    date = rand_date()
    company = random.choice(COMPANIES)

    # Нарийн чекийн цаас дээр урт ДДТД тоо ихэвчлэн 2 мөр/токен болж нугалагддаг тул
    # энэ бодит нөхцлийг санамсаргүйгээр дуурайлгана (жишээ нь зураг 2, 3, 4 шиг)
    ddtd_display = ddtd
    if random.random() < 0.6:
        split_at = random.randint(8, len(ddtd) - 8)
        ddtd_display = ddtd[:split_at] + " " + ddtd[split_at:]

    fields = dict(
        ddtd=ddtd_display, amount=amount, amount_nodot=amount_nodot,
        vat=vat, date=date, company=company,
    )

    if tmpl_idx == 2:  # Наадам: item-level ДДТД-ууд өөр, БОДИТ бус (label хийхгүй)
        fields["sub_ddtd1"] = rand_digits(33)
        fields["sub_ddtd2"] = rand_digits(33)
        fields["sub_ddtd3"] = rand_digits(33)
        fields["sub_ddtd4"] = rand_digits(33)

    text = tmpl.format(**fields)
    text = maybe_typo(text)

    ground_truth_amount = (
        f"{amount_val}.{decimal_frac}"
        if decimal_frac and decimal_frac != "00"
        else str(amount_val)
    )

    return {
        "raw_text": text,
        "ddtd": ddtd,
        "amount": ground_truth_amount,
    }


def generate_dataset(n=300):
    return [generate_one() for _ in range(n)]


if __name__ == "__main__":
    data = generate_dataset(5)
    for d in data[:2]:
        print(d["raw_text"])
        print("DDTD:", d["ddtd"], "AMOUNT:", d["amount"])
        print("=" * 50)

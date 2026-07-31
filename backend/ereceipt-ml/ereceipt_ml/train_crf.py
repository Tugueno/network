# -*- coding: utf-8 -*-
import pickle
import sklearn_crfsuite
from sklearn_crfsuite import metrics
from sklearn.model_selection import train_test_split

from generate_data import generate_dataset
from features_crf import build_dataset_for_crf


def main(n_samples=400, model_path="crf_model.pkl"):
    print(f"[DATA] {n_samples} synthetic баримт үүсгэж байна...")
    samples = generate_dataset(n_samples)

    print("[FEATURES] Токен түвшний шинж чанар бэлдэж байна...")
    X, y = build_dataset_for_crf(samples)
    print(f"  -> {len(X)} мөр (sentence), нийт токен: {sum(len(x) for x in X)}")

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.15, random_state=42
    )

    print("[TRAIN] CRF модель сургаж байна...")
    crf = sklearn_crfsuite.CRF(
        algorithm="lbfgs",
        c1=0.1,
        c2=0.1,
        max_iterations=100,
        all_possible_transitions=True,
    )
    crf.fit(X_train, y_train)

    y_pred = crf.predict(X_test)
    labels = ["DDTD", "AMOUNT"]
    print("[EVAL] Тест дата дээрх үр дүн:")
    print(metrics.flat_classification_report(y_test, y_pred, labels=labels, digits=3))

    with open(model_path, "wb") as f:
        pickle.dump(crf, f)
    print(f"[SUCCESS] Модель хадгалагдлаа: {model_path}")

    return crf


if __name__ == "__main__":
    main()

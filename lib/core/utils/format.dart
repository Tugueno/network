// Олон газар хуваалцагддаг форматын туслах функцууд.
// Аль нэг feature-т хамаарахгүй тул `core/utils`-д байрлана.

/// Бүхэл тоог мянгатын тусгаарлагчтай төгрөгийн дүн болгоно.
/// Жишээ: `1500000` → `1'500'000₮`
String formatTugrik(int amount) {
  final s = amount.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write("'");
    buf.write(s[i]);
  }
  return "${buf.toString()}₮";
}

import 'package:flutter/material.dart';

/// Bottom sheet-ийн дээд талд харагдах саарал "чирэх бариул" (drag handle).
///
/// Бүх sheet-д давтагддаг 36×4 саарал зураас. Дотроо `Center`-тэй тул
/// sheet-ийн Column-д шууд нэмж болно.
class SheetHandle extends StatelessWidget {
  const SheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: const Color(0xFFE5E5EA),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

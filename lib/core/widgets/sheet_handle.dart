import 'package:flutter/material.dart';
import 'package:ncapp/theme/app_theme.dart';

/// Bottom sheet-ийн дээд талд харагдах саарал "чирэх бариул" (drag handle).
///
/// Бүх sheet-д давтагддаг 36×4 саарал зураас. Дотроо `Center`-тэй тул
/// sheet-ийн Column-д шууд нэмж болно.
class SheetHandle extends StatelessWidget {
  const SheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    return Center(
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: appColors.border,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

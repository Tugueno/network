import 'package:flutter/material.dart';
import 'package:ncapp/core/widgets/sheet_handle.dart';

/// Бүх bottom sheet-д давтагддаг гадна бүрхүүл:
/// цагаан дэвсгэр, дээд талдаа дугуй булан, ба [SheetHandle] (чирэх бариул).
///
/// [children]-ийг бариулын доор Column-д байрлуулна. Бариулын доорх зайг
/// дуудагч өөрөө тохируулна (зарим sheet 16, зарим 20 зайтай).
///
/// [maxHeightFactor] өгвөл sheet-ийн өндрийг дэлгэцийн өндрийн тэр хувиар
/// хязгаарлана (ж: `0.85` → дэлгэцийн 85%). Гүйлгэдэг sheet-д ашиглана.
class BottomSheetContainer extends StatelessWidget {
  final List<Widget> children;
  final double? maxHeightFactor;

  const BottomSheetContainer({
    super.key,
    required this.children,
    this.maxHeightFactor,
  });

  @override
  Widget build(BuildContext context) {
    Widget box = Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          const SheetHandle(),
          ...children,
        ],
      ),
    );

    if (maxHeightFactor != null) {
      box = ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * maxHeightFactor!,
        ),
        child: box,
      );
    }

    return box;
  }
}

import 'package:flutter/material.dart';
import 'package:ncapp/theme/app_theme.dart';

/// Дарж сонгодог дугуй "чип" товч. Сонгогдоход цэнхэр хүрээтэй болно.
///
/// [count] өгвөл шошгоны ард тоо нэмж харуулна (ж: "Хүлээгдэж буй 5");
/// өгөхгүй бол зөвхөн [label] (ж: "1-р сар").
class AppChip extends StatelessWidget {
  final String label;
  final int? count;
  final bool selected;
  final VoidCallback onTap;

  const AppChip({
    super.key,
    required this.label,
    this.count,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: selected ? AppTheme.primary : const Color(0xFFE5E5EA),
            width: selected ? 1.3 : 1,
          ),
        ),
        child: Text(
          count == null ? label : '$label $count',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? AppTheme.primary : AppTheme.textGrey,
          ),
        ),
      ),
    );
  }
}

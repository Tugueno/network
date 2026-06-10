import 'package:flutter/material.dart';

const _tagColors = {
  'PUR': Color(0xFF9B59B6),
  'NPL': Color(0xFF3498DB),
  'HR':  Color(0xFF2ECC71),
  'FAD': Color(0xFFE67E22),
};

class DepartmentTag extends StatelessWidget {
  final String label;
  const DepartmentTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final color = _tagColors[label] ?? const Color(0xFF8A8A8E);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

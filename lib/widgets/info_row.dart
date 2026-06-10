import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;
  final FontWeight valueWeight;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.showDivider = true,
    this.valueWeight = FontWeight.w400,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
          trailing: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textGrey,
              fontWeight: valueWeight,
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
      ],
    );
  }
}
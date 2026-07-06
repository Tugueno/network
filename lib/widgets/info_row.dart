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
    final appColors = AppTheme.colors(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: appColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 6,
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: appColors.textSecondary,
                    fontWeight: valueWeight,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, thickness: 1, color: appColors.border),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ncapp/core/widgets/app_card.dart';
import 'package:ncapp/theme/app_theme.dart';

class PaymentReqAttachmentDescriptionCard extends StatelessWidget {
  final int count;
  final String description;
  final VoidCallback? onAttachmentTap;

  const PaymentReqAttachmentDescriptionCard({
    super.key,
    required this.count,
    required this.description,
    this.onAttachmentTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    return AppCard(
      width: double.infinity,
      radius: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onAttachmentTap,
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              height: 52,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.attach_file,
                      size: 20,
                      color: appColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Хавсаргасан',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: appColors.textPrimary,
                        ),
                      ),
                    ),
                    if (count > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: appColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(
            height: 4,
            thickness: 4,
            color: appColors.screenBackground,
            endIndent: 0,
            indent: 0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 20,
                      color: appColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Тайлбар',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: appColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: appColors.subtleFill,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: appColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

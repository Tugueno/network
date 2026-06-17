import 'package:flutter/material.dart';
import 'package:ncapp/core/widgets/bottom_sheet_container.dart';
import 'package:ncapp/features/payment_req/payment_req_model.dart';
import 'package:ncapp/theme/app_theme.dart';

class PaymentReqFullDetailSheet extends StatelessWidget {
  final PaymentReqModel item;
  const PaymentReqFullDetailSheet({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      maxHeightFactor: 0.85,
      children: [
          const SizedBox(height: 16),
          const Text(
            'Дэлгэрэнгүй мэдээлэл',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
          Flexible(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
              shrinkWrap: true,
              children: [
                if (item.requestDetails.isNotEmpty) ...[
                  const Text(
                    'Хүсэлтийн мэдээлэл',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...item.requestDetails.map((d) => _DetailRow(item: d)),
                  const SizedBox(height: 16),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFDADADA)),
                  const SizedBox(height: 16),
                ],
                if (item.budgetDetails.isNotEmpty) ...[
                  const Text(
                    'Төсвийн мэдээлэл',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...item.budgetDetails.map((d) => _DetailRow(item: d)),
                ],
              ],
            ),
          ),
        ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final DetailItem item;
  const _DetailRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.subtitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.info,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../models/payment_req_model.dart';
import '../../theme/app_theme.dart';

class PaymentReqFullDetailSheet extends StatelessWidget {
  final PaymentReqModel item;
  const PaymentReqFullDetailSheet({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5EA),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Дэлгэрэнгүй мэдээлэл',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
          const Divider(height: 20),
          Flexible(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
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
                  const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
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
      ),
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

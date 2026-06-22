import 'package:flutter/material.dart';
import 'package:ncapp/core/widgets/adaptive_modal.dart';
import 'package:ncapp/core/widgets/app_card.dart';
import 'package:ncapp/features/payment_req/models/payment_req_model.dart';
import 'package:ncapp/features/payment_req/views/payment_req_full_detail_sheet.dart';
import 'package:ncapp/features/payment_req/widgets/payment_req_status_badge.dart';
import 'package:ncapp/theme/app_theme.dart';
import 'package:ncapp/widgets/department_tag.dart';
import 'package:ncapp/widgets/info_row.dart';
import 'package:ncapp/widgets/user_avatar.dart';

void _showFullDetailSheet(BuildContext context, PaymentReqModel item) {
  showAdaptiveModal(
    context: context,
    maxWidth: 560,
    builder: (_) => PaymentReqFullDetailSheet(item: item),
  );
}

class PaymentReqDetailHeader extends StatelessWidget {
  final PaymentReqModel item;

  const PaymentReqDetailHeader({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DepartmentTag(label: item.department),
          const SizedBox(height: 8),
          Text(
            item.formattedAmount,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Нийт төсөвлөсөн',
            style: TextStyle(fontSize: 14, color: AppTheme.textGrey),
          ),
          const SizedBox(height: 8),
          PaymentReqStatusBadge(status: item.status),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(name: item.assignee, avatarUrl: item.avatarUrl),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.assignee,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                    if (item.assigneeLore.isNotEmpty) ...[
                      const SizedBox(height: 1),
                      Text(
                        item.assigneeLore,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (item.assigneeRole.isNotEmpty) ...[
                      const SizedBox(height: 1),
                      Text(
                        item.assigneeRole,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textGrey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          InfoRow(
            label: 'Үүсгэсэн огноо:',
            value: item.date,
            showDivider: false,
            valueWeight: FontWeight.w600,
          ),
          InfoRow(
            label: 'Төлбөр хийгдэх огноо:',
            value: item.paymentDate,
            showDivider: false,
            valueWeight: FontWeight.w600,
          ),
          InfoRow(
            label: 'Компани:',
            value: item.company,
            showDivider: false,
            valueWeight: FontWeight.w600,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () => _showFullDetailSheet(context, item),
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFF0F0F0),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                foregroundColor: AppTheme.textDark,
              ),
              child: const Text('Дэлгэрэнгүй харах'),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/core/widgets/sheet_handle.dart';
import 'package:ncapp/features/payment_req/controllers/payment_req_controller.dart';
import 'package:ncapp/features/payment_req/models/payment_req_model.dart';
import 'package:ncapp/theme/app_theme.dart';
import 'package:ncapp/widgets/department_tag.dart';
import 'package:ncapp/widgets/info_row.dart';
import 'package:ncapp/widgets/user_avatar.dart';

class PaymentReqConfirmSheet extends GetView<PaymentReqController> {
  final PaymentReqModel item;
  final bool isApprove;
  const PaymentReqConfirmSheet({
    super.key,
    required this.item,
    required this.isApprove,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    return Container(
      decoration: BoxDecoration(
        color: appColors.sheetBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SheetHandle(),
          const SizedBox(height: 20),
          Text(
            isApprove ? 'Хүсэлт батлах' : 'Хүсэлт буцаах',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: appColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.id,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: appColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.date,
                          style: TextStyle(
                            fontSize: 14,
                            color: appColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        DepartmentTag(label: item.department),
                        const SizedBox(width: 8),
                        Text(
                          item.assignee,
                          style: TextStyle(
                            fontSize: 14,
                            color: appColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                item.formattedAmount,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: appColors.textPrimary,
                ),
              ),
            ],
          ),
          if (item.assigneeLore.isNotEmpty || item.assigneeRole.isNotEmpty) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                UserAvatar(name: item.assignee, avatarUrl: item.avatarUrl),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.assigneeLore.isNotEmpty)
                        Text(
                          item.assigneeLore,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: appColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (item.assigneeRole.isNotEmpty)
                        Text(
                          item.assigneeRole,
                          style: TextStyle(
                            fontSize: 13,
                            color: appColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 6),
          InfoRow(
            label: 'Төлбөр хийгдэх огноо:',
            value: item.paymentDate,
            showDivider: false,
            valueWeight: FontWeight.w600,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: isApprove
                ? ElevatedButton(
                    onPressed: () async {
                      await controller.approve(item);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Батлах',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  )
                : OutlinedButton(
                    onPressed: () async {
                      await controller.reject(item);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      foregroundColor: AppTheme.error,
                    ),
                    child: const Text(
                      'Буцаах',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

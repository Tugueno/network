import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/features/requests/request_model.dart';
import 'package:ncapp/features/requests/requests_controller.dart';
import 'package:ncapp/theme/app_theme.dart';

class RequestsConfirmSheet extends StatelessWidget {
  final RequestsController controller;
  final bool isApprove;

  const RequestsConfirmSheet({required this.controller, required this.isApprove});

  @override
  Widget build(BuildContext context) {
    final items = controller.selectedItems;
    final count = items.length;
    final isApproved = controller.selectedTab.value == 1;

    final title = isApprove
        ? '$count ирцийн хүсэлт батлах'
        : isApproved
        ? '$count зөвшөөрсөн ирцийн хүсэлт цуцлах'
        : '$count ирцийн хүсэлт цуцлах';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppTheme.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                itemBuilder: (_, i) => _ConfirmItem(item: items[i]),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: isApprove
                  ? ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.approve();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 18,
                            color: Colors.white,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Батлах',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  : OutlinedButton(
                      onPressed: () {
                        Get.back();
                        controller.reject();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.error),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        foregroundColor: AppTheme.error,
                      ),
                      child: const Text(
                        'Цуцлах',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ConfirmItem extends StatelessWidget {
  final RequestModel item;

  const _ConfirmItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.type.label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.timeRange,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${item.totalHours} цаг',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            item.dateRange,
            style: const TextStyle(fontSize: 12, color: AppTheme.textGrey),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '"${item.reason}"',
              style: const TextStyle(fontSize: 12, color: AppTheme.textDark),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: AppTheme.primaryLight.withValues(alpha: 0.2),
                child: Text(
                  item.senderName[0],
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                item.senderName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textDark,
                ),
              ),
              const Spacer(),
              Text(
                '${item.sentAt.year}/${item.sentAt.month.toString().padLeft(2, '0')}/'
                '${item.sentAt.day.toString().padLeft(2, '0')} '
                '${item.sentAt.hour.toString().padLeft(2, '0')}:'
                '${item.sentAt.minute.toString().padLeft(2, '0')}мин',
                style: const TextStyle(fontSize: 11, color: AppTheme.textGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

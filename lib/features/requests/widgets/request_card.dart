import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/features/requests/request_model.dart';
import 'package:ncapp/theme/app_theme.dart';

class RequestCard extends StatelessWidget {
  final RequestModel item;
  final VoidCallback onTap;

  const RequestCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    return Obx(
      () => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: appColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: item.isSelected.value
                  ? AppTheme.primary
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    item.isSelected.value
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: item.isSelected.value
                        ? AppTheme.primary
                        : appColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.type.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: appColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '${item.totalHours} цаг',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: appColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 28),
                child: Text(
                  item.timeRange,
                  style: TextStyle(
                    fontSize: 13,
                    color: appColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.only(left: 28),
                child: Text(
                  item.dateRange,
                  style: TextStyle(
                    fontSize: 12,
                    color: appColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: appColors.subtleFill,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '"${item.reason}"',
                  style: TextStyle(fontSize: 13, color: appColors.textPrimary),
                ),
              ),
              if (item.fileUrl != null) ...[
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.attach_file, size: 16, color: AppTheme.primary),
                    SizedBox(width: 4),
                    Text(
                      'Файл татах',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 10),
              Divider(height: 1, color: appColors.border),
              const SizedBox(height: 8),
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: AppTheme.primaryLight.withValues(
                      alpha: 0.2,
                    ),
                    backgroundImage: item.senderAvatar.isNotEmpty
                        ? NetworkImage(item.senderAvatar)
                        : null,
                    child: item.senderAvatar.isEmpty
                        ? Text(
                            item.senderName[0],
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.senderName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: appColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${item.sentAt.year}/'
                    '${item.sentAt.month.toString().padLeft(2, '0')}/'
                    '${item.sentAt.day.toString().padLeft(2, '0')} '
                    '${item.sentAt.hour.toString().padLeft(2, '0')}:'
                    '${item.sentAt.minute.toString().padLeft(2, '0')}мин',
                    style: TextStyle(
                      fontSize: 11,
                      color: appColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

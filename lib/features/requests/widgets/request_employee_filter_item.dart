import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/features/requests/request_model.dart';
import 'package:ncapp/theme/app_theme.dart';

class RequestEmployeeFilterItem extends StatelessWidget {
  final EmployeeModel employee;
  final VoidCallback onTap;

  const RequestEmployeeFilterItem({
    super.key,
    required this.employee,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppTheme.primaryLight.withValues(alpha: 0.15),
              backgroundImage:
                  employee.avatarUrl != null ? NetworkImage(employee.avatarUrl!) : null,
              child: employee.avatarUrl == null
                  ? Text(
                      employee.name[0],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    employee.role,
                    style: const TextStyle(fontSize: 12, color: AppTheme.textGrey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Obx(
              () => Icon(
                employee.isSelected.value
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: employee.isSelected.value
                    ? AppTheme.primary
                    : AppTheme.textGrey,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

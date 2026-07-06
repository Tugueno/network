import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/features/requests/request_model.dart';
import 'package:ncapp/features/requests/requests_controller.dart';
import 'package:ncapp/theme/app_theme.dart';

class RequestsEmployeeFilterRow extends StatelessWidget {
  final RequestsController controller;
  final VoidCallback onTap;

  const RequestsEmployeeFilterRow({
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: appColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: appColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Obx(() {
                final selected = controller.employees
                    .where((e) => e.isSelected.value)
                    .toList();
                if (selected.isEmpty) {
                  return Text(
                    'Бүх ажилчин',
                    style: TextStyle(
                      fontSize: 14,
                      color: appColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                }
                final names = selected.take(3).map((e) => e.name).join(', ');
                final extra = selected.length > 3
                    ? ' +${selected.length - 3}'
                    : '';
                return Text(
                  '$names$extra',
                  style: TextStyle(
                    fontSize: 14,
                    color: appColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                );
              }),
            ),
            Icon(Icons.chevron_right, size: 20, color: appColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

// ── Reusable filter chips ──────────────────────────────────
class RequestsFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const RequestsFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : appColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.primary : appColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : appColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class RequestsTypeChip extends StatelessWidget {
  final RequestType type;
  final bool selected;
  final VoidCallback onTap;
  const RequestsTypeChip({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : appColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.primary : appColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              type.icon,
              size: 16,
              color: selected ? Colors.white : appColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              type.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : appColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

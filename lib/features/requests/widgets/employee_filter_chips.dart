import 'package:flutter/material.dart';
import 'package:ncapp/features/requests/request_model.dart';
import 'package:ncapp/theme/app_theme.dart';

class EmployeeFilterChips extends StatelessWidget {
  final List<EmployeeModel> employees;
  final void Function(String id) onRemove;

  const EmployeeFilterChips({
    super.key,
    required this.employees,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    return Container(
      color: appColors.cardBackground,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: employees
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: appColors.cardBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: appColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          e.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: appColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => onRemove(e.id),
                          child: Icon(
                            Icons.close,
                            size: 14,
                            color: appColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

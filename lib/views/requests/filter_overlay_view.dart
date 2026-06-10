import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/requests_controller.dart';
import '../../models/request_model.dart';
import '../../theme/app_theme.dart';
import 'filter_employee_overlay_view.dart';

class FilterOverlayView extends StatelessWidget {
  const FilterOverlayView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RequestsController>();
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Grabber
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Сараар шүүх ──────────────────────
                  const Text(
                    'Сараар шүүх',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(
                          controller.months.length,
                          (i) => _FilterChip(
                            label: controller.months[i],
                            selected: controller.filterMonthIndex.value == i,
                            onTap: () => controller.toggleFilterMonth(i),
                          ),
                        ),
                      )),
                  const SizedBox(height: 20),

                  // ── Ажилчнаар шүүх ──────────────────
                  const Text(
                    'Ажилчнаар шүүх',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _EmployeeRow(controller: controller),
                  const SizedBox(height: 20),

                  // ── Төрлөөр шүүх ────────────────────
                  const Text(
                    'Төрлөөр шүүх',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: RequestType.values
                            .map((type) => _TypeChip(
                                  type: type,
                                  selected: controller.filterTypes
                                      .contains(type),
                                  onTap: () =>
                                      controller.toggleFilterType(type),
                                ))
                            .toList(),
                      )),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── Шүүж харах button ─────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  controller.applyFilter();
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text(
                  'Шүүж харах',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Employee row ───────────────────────────────────────────
class _EmployeeRow extends StatelessWidget {
  final RequestsController controller;
  const _EmployeeRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          const FilterEmployeeOverlayView(),
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Obx(() {
                final selected =
                    controller.employees.where((e) => e.isSelected.value).toList();
                if (selected.isEmpty) {
                  return const Text(
                    'Бүх ажилчин',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textGrey,
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
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textDark,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                );
              }),
            ),
            const Icon(Icons.chevron_right,
                size: 20, color: AppTheme.textGrey),
          ],
        ),
      ),
    );
  }
}

// ── Reusable filter chips ──────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? AppTheme.primary : AppTheme.borderColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : AppTheme.textGrey,
          ),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final RequestType type;
  final bool selected;
  final VoidCallback onTap;
  const _TypeChip(
      {required this.type, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? AppTheme.primary : AppTheme.borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              type.icon,
              size: 16,
              color: selected ? Colors.white : AppTheme.textGrey,
            ),
            const SizedBox(width: 6),
            Text(
              type.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : AppTheme.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

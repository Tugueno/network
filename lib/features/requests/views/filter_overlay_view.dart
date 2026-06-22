import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/features/requests/requests_controller.dart';
import 'package:ncapp/features/requests/request_model.dart';
import 'package:ncapp/features/requests/widgets/request_filter_controls.dart';
import 'package:ncapp/theme/app_theme.dart';
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
                          (i) => RequestsFilterChip(
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
                  RequestsEmployeeFilterRow(
                    controller: controller,
                    onTap: () {
                      Get.bottomSheet(
                        const FilterEmployeeOverlayView(),
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                      );
                    },
                  ),
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
                            .map((type) => RequestsTypeChip(
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

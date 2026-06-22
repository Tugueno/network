import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/features/requests/requests_controller.dart';
import 'package:ncapp/features/requests/widgets/request_employee_filter_item.dart';
import 'package:ncapp/theme/app_theme.dart';

class FilterEmployeeOverlayView extends StatelessWidget {
  const FilterEmployeeOverlayView({super.key});

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

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.arrow_back_ios,
                      size: 18, color: AppTheme.textDark),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Ажилчнаар шүүх',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF0F0F0)),

          // Employee list
          Flexible(
            child: Obx(
              () => ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.employees.length,
                itemBuilder: (_, i) {
                  final emp = controller.employees[i];
                  return RequestEmployeeFilterItem(
                    employee: emp,
                    onTap: () => controller.toggleEmployee(emp.id),
                  );
                },
              ),
            ),
          ),

          // Шүүж харах button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Get.back(),
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

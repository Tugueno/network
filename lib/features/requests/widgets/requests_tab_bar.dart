import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/features/requests/request_model.dart';
import 'package:ncapp/features/requests/requests_controller.dart';
import 'package:ncapp/theme/app_theme.dart';

class RequestsTabBar extends StatelessWidget {
  final RequestsController controller;

  const RequestsTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Obx(
        () => Row(
          children: [
            _TabChip(
              label: 'Ирсэн',
              count: controller.countOf(RequestStatus.irsen),
              selected: controller.selectedTab.value == 0,
              onTap: () => controller.selectedTab.value = 0,
            ),
            const SizedBox(width: 8),
            _TabChip(
              label: 'Зөвшөөрсөн',
              count: controller.countOf(RequestStatus.zuvshuursun),
              selected: controller.selectedTab.value == 1,
              onTap: () => controller.selectedTab.value = 1,
            ),
            const SizedBox(width: 8),
            _TabChip(
              label: 'Цуцалсан',
              count: controller.countOf(RequestStatus.tsutsalsan),
              selected: controller.selectedTab.value == 2,
              onTap: () => controller.selectedTab.value = 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.primary : AppTheme.borderColor,
          ),
        ),
        child: Text(
          '$label $count',
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

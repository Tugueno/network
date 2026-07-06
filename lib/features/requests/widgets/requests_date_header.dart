import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/features/requests/requests_controller.dart';
import 'package:ncapp/features/requests/views/filter_overlay_view.dart';
import 'package:ncapp/theme/app_theme.dart';

class RequestsDateHeader extends StatelessWidget {
  final RequestsController controller;

  const RequestsDateHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    return Container(
      color: appColors.cardBackground,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => Text(
              controller.months[controller.appliedMonthIndex.value],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: appColors.textPrimary,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.initFilterFromApplied();
              Get.bottomSheet(
                const FilterOverlayView(),
                isScrollControlled: true,
                backgroundColor: appColors.sheetBackground,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
              );
            },
            child: Icon(Icons.tune, size: 20, color: appColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

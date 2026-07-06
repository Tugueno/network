import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/controllers/shell_controller.dart';
import 'package:ncapp/core/responsive/app_breakpoints.dart';
import 'package:ncapp/features/advance_req/advance_req_controller.dart';
import 'package:ncapp/features/advance_req/views/advance_req_detail_view.dart';
import 'package:ncapp/features/advance_req/views/advance_req_view.dart';
import 'package:ncapp/features/payment_req/controllers/payment_req_controller.dart';
import 'package:ncapp/features/payment_req/views/payment_req_detail_view.dart';
import 'package:ncapp/features/payment_req/views/payment_req_view.dart';
import 'package:ncapp/features/requests/views/requests_view.dart';
import 'package:ncapp/theme/app_system_ui.dart';
import 'package:ncapp/theme/app_theme.dart';
import 'package:ncapp/widgets/network_logo.dart';

class AppShell extends GetView<ShellController> {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = AppBreakpoints.isDesktop(constraints.maxWidth);
        final appColors = AppTheme.colors(context);
        final backgroundColor = isWeb
            ? appColors.subtleFill
            : appColors.cardBackground;

        return StatusAwarePage(
          backgroundColor: backgroundColor,
          safeAreaBottom: true,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppBreakpoints.maxShellWidth,
              ),
              child: Column(
                children: [
                  const _TopBar(),
                  Divider(height: 1, thickness: 1, color: appColors.border),
                  Expanded(
                    child: Obx(
                      () => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isWeb)
                            SizedBox(
                              width: AppBreakpoints.shellListPaneWidth,
                              child: _listPanel(controller.selectedTab.value),
                            )
                          else
                            Expanded(
                              child: _listPanel(controller.selectedTab.value),
                            ),
                          if (isWeb)
                            VerticalDivider(
                              width: 1,
                              thickness: 1,
                              color: appColors.border,
                            ),
                          if (isWeb)
                            Expanded(
                              child: _detailPanel(controller.selectedTab.value),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _listPanel(int tab) => [
    const RequestsView(),
    const PaymentReqView(),
    const AdvanceReqView(),
  ][tab];

  Widget _detailPanel(int tab) {
    switch (tab) {
      case 1:
        return Obx(() {
          final item = Get.find<PaymentReqController>().selectedItem.value;
          return item == null
              ? const _EmptyDetail()
              : const PaymentReqDetailView();
        });
      case 2:
        return Obx(() {
          final item = Get.find<AdvanceReqController>().selectedItem.value;
          return item == null
              ? const _EmptyDetail()
              : const AdvanceReqDetailView();
        });
      default:
        return const _EmptyDetail();
    }
  }
}

class _TopBar extends GetView<ShellController> {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    return Container(
      height: 56,
      color: appColors.cardBackground,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          const NetworkLogo(),
          const SizedBox(width: 32),
          const _TabItem(label: 'Ирцийн хүсэлт', index: 0),
          const _TabItem(label: 'Төлбөрийн хүсэлт', index: 1),
          const _TabItem(label: 'Урдчилгаа хаах', index: 2),
          const Spacer(),
          TextButton.icon(
            onPressed: controller.logout,
            icon: Icon(
              Icons.logout_outlined,
              size: 16,
              color: appColors.textSecondary,
            ),
            label: Text(
              'Гарах',
              style: TextStyle(color: appColors.textSecondary, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final int index;

  const _TabItem({required this.label, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShellController>();
    final appColors = AppTheme.colors(context);
    return Obx(() {
      final isSelected = controller.selectedTab.value == index;
      return GestureDetector(
        onTap: () => controller.selectedTab.value = index,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppTheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? AppTheme.primary : appColors.textSecondary,
            ),
          ),
        ),
      );
    });
  }
}

class _EmptyDetail extends StatelessWidget {
  const _EmptyDetail();

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    return Center(
      child: Text(
        'Хүсэлт сонгоно уу',
        style: TextStyle(fontSize: 14, color: appColors.textSecondary),
      ),
    );
  }
}

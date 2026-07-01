import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/app/app_routes.dart';
import 'package:ncapp/controllers/auth_controller.dart';
import 'package:ncapp/controllers/main_tab_controller.dart';
import 'package:ncapp/features/advance_req/views/advance_req_view.dart';
import 'package:ncapp/features/payment_req/views/payment_req_view.dart';
import 'package:ncapp/features/requests/requests_controller.dart';
import 'package:ncapp/features/requests/views/requests_view.dart';
import 'package:ncapp/views/home/home_view.dart';
import 'package:ncapp/widgets/main_tab_navigation_bar.dart';

class MainTabShell extends StatefulWidget {
  final MainTab initialTab;

  const MainTabShell({super.key, this.initialTab = MainTab.home});

  @override
  State<MainTabShell> createState() => _MainTabShellState();
}

class _MainTabShellState extends State<MainTabShell> {
  late final MainTabController controller = Get.find<MainTabController>();

  @override
  void initState() {
    super.initState();
    controller.selectTab(widget.initialTab);
  }

  void _logout() {
    try {
      Get.find<AuthController>().logout();
    } catch (_) {}
    Get.offAllNamed(AppRoutes.auth);
  }

  bool get _shouldShowNavigation {
    if (controller.currentTab != MainTab.requests) {
      return true;
    }

    try {
      return Get.find<RequestsController>().selectedCount == 0;
    } catch (_) {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            HomeView(),
            AdvanceReqView(),
            RequestsView(),
            PaymentReqView(),
          ],
        ),
        bottomNavigationBar: _shouldShowNavigation
            ? MainTabNavigationBar(
                currentIndex: controller.currentIndex.value,
                onTabSelected: (index) =>
                    controller.selectTab(MainTab.values[index]),
                onLogout: _logout,
              )
            : null,
      ),
    );
  }
}

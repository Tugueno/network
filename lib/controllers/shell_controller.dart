import 'package:get/get.dart';
import 'package:ncapp/app/app_routes.dart';
import 'package:ncapp/controllers/auth_controller.dart';

class ShellController extends GetxController {
  final selectedTab = 0.obs;

  void logout() {
    try {
      Get.find<AuthController>().logout();
    } catch (_) {}
    Get.offAllNamed(AppRoutes.auth);
  }
}

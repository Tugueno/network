import 'package:get/get.dart';
import '../app/app_routes.dart';
import '../controllers/auth_controller.dart';

class HomeController extends GetxController {
  final userName = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    userName.value = Get.arguments?['userName'] ?? '';
    loadUserData();
  }

  Future<void> loadUserData() async {
    isLoading.value = true;
    isLoading.value = false;
  }

  void logout() {
    // AuthController-г олж logout() дуудна
    // Get.delete хийхгүй — fenix:true тул onInit дахин ажиллаж
    // SharedPreferences-аас rememberedEmail уншигдана
    try {
      final authCtrl = Get.find<AuthController>();
      authCtrl.logout();
    } catch (_) {}
    Get.offAllNamed(AppRoutes.auth);
  }
}
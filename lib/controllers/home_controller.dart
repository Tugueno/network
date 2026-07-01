import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/app_routes.dart';
import '../controllers/auth_controller.dart';

class HomeController extends GetxController {
  final userName = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _resolveUserName();
    loadUserData();
  }

  void _resolveUserName() {
    final args = Get.arguments;
    final routedName = args is Map ? args['userName']?.toString() ?? '' : '';
    if (routedName.isNotEmpty) {
      userName.value = routedName;
      return;
    }

    _loadRememberedUserName();
  }

  Future<void> _loadRememberedUserName() async {
    try {
      final authCtrl = Get.find<AuthController>();
      final email = authCtrl.rememberedEmail.value;
      if (email != null && email.isNotEmpty) {
        userName.value = email.split('@').first;
        return;
      }
    } catch (_) {}

    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(AuthController.rememberedEmailKey);
    if (email != null && email.isNotEmpty) {
      userName.value = email.split('@').first;
    }
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

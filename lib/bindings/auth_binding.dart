// ═══════════════════════════════════════════════════════
//  auth_binding.dart — Dependency Injection
//  GetPage-д binding: AuthBinding() өгөхөд
//  тухайн route нээгдэхэд controller автоматаар
//  үүсч, гарахад устдаг
// ═══════════════════════════════════════════════════════
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/app_routes.dart';

class AuthController extends GetxController {
  static const rememberedEmailKey = 'remembered_email';
  static const _keyEmail = rememberedEmailKey;

  // ── TextEditingController — _field + get хэлбэр ──
  // onInit/onClose-д dispose/recreate хийхгүй
  // fenix:true үед шинэ instance үүсэх тул constructor-д л үүснэ
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // ── Observable state ──────────────────────────────
  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final showPasswordField = false.obs;
  final emailError = RxnString();
  final passwordError = RxnString();
  final rememberedEmail = RxnString();
  final rememberedImageUrl = RxnString();
  final isLoggedOut = false.obs;

  bool get hasRemembered => rememberedEmail.value != null;

  @override
  void onInit() {
    super.onInit();
    _loadRemembered();
  }

  // onClose-д dispose хийхгүй — GetX өөрөө удирдана
  // dispose хийвэл fenix дахин ашиглах үед алдаа гарна

  // ── SharedPreferences-аас уншина ──────────────────
  Future<void> _loadRemembered() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_keyEmail);
    if (email != null) {
      rememberedEmail.value = email;
      isLoggedOut.value = true;
    }
  }

  // ── Helper ────────────────────────────────────────
  void toggleObscure() => obscurePassword.value = !obscurePassword.value;
  void clearEmailError() => emailError.value = null;
  void clearPwError() => passwordError.value = null;

  void togglePasswordField() {
    showPasswordField.value = !showPasswordField.value;
    passwordController.clear();
    passwordError.value = null;
  }

  // ── Энгийн login ──────────────────────────────────
  Future<void> login() async {
    final email = emailController.text.trim();
    final pw = passwordController.text;

    String? eErr, pErr;
    if (email.isEmpty) {
      eErr = 'Имайл оруулна уу';
    } else if (!email.contains('@')) {
      eErr = 'Имайл формат буруу байна';
    }
    if (pw.isEmpty) {
      pErr = 'Нууц үг оруулна уу';
    } else if (pw.length < 6) {
      pErr = 'Нууц үг хэтэрхий богино байна';
    }

    if (eErr != null || pErr != null) {
      emailError.value = eErr;
      passwordError.value = pErr;
      return;
    }

    emailError.value = null;
    passwordError.value = null;
    isLoading.value = true;
    // TODO: await apiService.login(email, pw);
    isLoading.value = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
    rememberedEmail.value = email;
    isLoggedOut.value = false;

    final userName = email.split('@').first;
    Get.toNamed(AppRoutes.biometric, arguments: {'userName': userName});
  }

  // ── Face ID ───────────────────────────────────────
  Future<void> biometricLogin() async {
    isLoading.value = true;
    // TODO: final result = await localAuth.authenticate(...);
    isLoading.value = false;
    Get.snackbar(
      'Амжилттай',
      'Face ID-ээр нэвтэрлээ!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // ── Нууц үгээр нэвтрэх ───────────────────────────
  Future<void> savedPasswordLogin() async {
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Нууц үг оруулна уу';
      return;
    }
    isLoading.value = true;
    // TODO: await apiService.loginWithPassword(pw);
    isLoading.value = false;

    final userName = rememberedEmail.value?.split('@').first ?? '';
    isLoggedOut.value = false;
    Get.offAllNamed(AppRoutes.home, arguments: {'userName': userName});
  }

  // ── Biometric зөвшөөрөх / алгасах ────────────────
  void acceptBiometric() {
    final args = Get.arguments;
    Get.offAllNamed(AppRoutes.home, arguments: args);
  }

  void skipBiometric() {
    final args = Get.arguments;
    Get.offAllNamed(AppRoutes.home, arguments: args);
  }

  // ── Logout — email хадгалагдана, зөвхөн isLoggedOut = true ──
  void logout() {
    isLoggedOut.value = true;
    showPasswordField.value = false;
    passwordController.clear();
    passwordError.value = null;
  }

  // ── Өөр акаунт — бүгдийг цэвэрлэнэ ──────────────
  Future<void> switchAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEmail);
    isLoggedOut.value = false;
    rememberedEmail.value = null;
    emailController.clear();
    passwordController.clear();
    emailError.value = null;
    passwordError.value = null;
  }
}

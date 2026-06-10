import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/network_logo.dart';

// ═══════════════════════════════════════════════════════
//  GetView<AuthController> — StatefulWidget биш!
//  "controller" гэдэг нэртэй getter автоматаар
//  Get.find<AuthController>() дуудна → setState хэрэггүй
// ═══════════════════════════════════════════════════════
class AuthScreen extends GetView<AuthController> {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Text(
          'Version 2.0.0',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.textGrey, fontSize: 12),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          // Obx: controller-ийн .obs утга өөрчлөгдөхөд
          //      зөвхөн энэ хэсэг л дахин build хийнэ
          child: Obx(() {
            if (controller.hasRemembered && !controller.isLoggedOut.value) {
              return _buildSavedLogin(context);
            } else if (controller.isLoggedOut.value) {
              return _buildLoggedOutLogin(context);
            }
            return _buildNormalLogin(context);
          }),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════
  //  1. Энгийн login — email + нууц үг
  // ══════════════════════════════════════════════════════
  Widget _buildNormalLogin(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 48),
        const Center(child: NetworkLogo()),
        const SizedBox(height: 48),

        const Text(
          'NetWork-д тавтай морил.',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 28),

        // ── Email ─────────────────────────────────────
        const _FieldLabel('Имэйл'),
        const SizedBox(height: 6),
        // Obx: зөвхөн emailError өөрчлөгдөхөд л энэ field шинэчлэгдэнэ
        Obx(
          () => TextField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => controller.clearEmailError(),
            decoration: _inputDecoration(
              hint: 'Бүртгэлтэй имэйлаа оруулаарай',
              hasError: controller.emailError.value != null,
            ),
          ),
        ),
        Obx(() => _ErrorText(controller.emailError.value)),

        const SizedBox(height: 16),

        // ── Нууц үг ───────────────────────────────────
        const _FieldLabel('Нууц үг'),
        const SizedBox(height: 6),
        Obx(
          () => TextField(
            controller: controller.passwordController,
            obscureText: controller.obscurePassword.value,
            onChanged: (_) => controller.clearPwError(),
            decoration: _inputDecoration(
              hint: 'Нууц үг оруулах',
              hasError: controller.passwordError.value != null,
              suffix: _EyeIcon(
                obscure: controller.obscurePassword.value,
                onTap: controller.toggleObscure,
              ),
            ),
          ),
        ),
        Obx(() => _ErrorText(controller.passwordError.value)),

        const SizedBox(height: 28),

        // ── Нэвтрэх товч ──────────────────────────────
        Obx(
          () => ElevatedButton(
            onPressed: controller.isLoading.value ? null : controller.login,
            child: controller.isLoading.value
                ? const _LoadingIndicator()
                : const Text('Нэвтрэх'),
          ),
        ),

        // Нэвтэрсний дараа BiometricPrompt харуулах
        Obx(() {
          if (controller.hasRemembered && !controller.isLoggedOut.value) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              BiometricPromptScreen.show(
                context,
                onAccept: controller.acceptBiometric,
                onSkip: controller.skipBiometric,
              );
            });
          }
          return const SizedBox.shrink();
        }),

        const SizedBox(height: 40),
      ],
    );
  }

  // ══════════════════════════════════════════════════════
  //  2. Saved login — Face ID / нууц үг toggle
  // ══════════════════════════════════════════════════════
  Widget _buildSavedLogin(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 48),
        const Center(child: NetworkLogo()),
        const SizedBox(height: 48),

        const Text(
          'NetWork-д тавтай морил.',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 24),

        Obx(
          () => _SavedUserCard(
            name: controller.rememberedEmail.value!.split('@').first,
            email: controller.rememberedEmail.value!,
            imageUrl: controller.rememberedImageUrl.value,
          ),
        ),
        const SizedBox(height: 16),

        // Нууц үг toggle
        Obx(
          () => controller.showPasswordField.value
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('Нууц үг'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: controller.passwordController,
                      obscureText: controller.obscurePassword.value,
                      autofocus: true,
                      onChanged: (_) => controller.clearPwError(),
                      decoration: _inputDecoration(
                        hint: '••••••••',
                        hasError: controller.passwordError.value != null,
                        suffix: _EyeIcon(
                          obscure: controller.obscurePassword.value,
                          onTap: controller.toggleObscure,
                        ),
                      ),
                    ),
                    _ErrorText(controller.passwordError.value),
                    const SizedBox(height: 20),
                  ],
                )
              : const SizedBox.shrink(),
        ),

        // Нэвтрэх товч
        Obx(
          () => ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : (controller.showPasswordField.value
                      ? controller.savedPasswordLogin
                      : controller.biometricLogin),
            child: controller.isLoading.value
                ? const _LoadingIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!controller.showPasswordField.value) ...[
                        const FaceIdIcon(size: 18, color: Colors.white),
                        const SizedBox(width: 8),
                      ],
                      const Text('Нэвтрэх'),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 16),

        // Face ID / нууц үг toggle текст
        Obx(
          () => Center(
            child: GestureDetector(
              onTap: controller.togglePasswordField,
              child: Text(
                controller.showPasswordField.value
                    ? 'Face ID ашиглан нэвтрэх'
                    : 'Нууц үг ашиглан нэвтрэх',
                style: const TextStyle(color: AppTheme.textGrey, fontSize: 14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // ══════════════════════════════════════════════════════
  //  3. Logout дараах login — email хаасан, нууц үг л
  // ══════════════════════════════════════════════════════
  Widget _buildLoggedOutLogin(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 48),
        const Center(child: NetworkLogo()),
        const SizedBox(height: 48),

        const Text(
          'NetWork-д тавтай морил.',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 24),

        Obx(
          () => _SavedUserCard(
            name: controller.rememberedEmail.value!.split('@').first,
            email: controller.rememberedEmail.value!,
            imageUrl: controller.rememberedImageUrl.value,
          ),
        ),
        const SizedBox(height: 16),

        const _FieldLabel('Нууц үг'),
        const SizedBox(height: 6),
        Obx(
          () => TextField(
            controller: controller.passwordController,
            obscureText: controller.obscurePassword.value,
            autofocus: true,
            onChanged: (_) => controller.clearPwError(),
            decoration: _inputDecoration(
              hint: 'Нууц үг оруулах',
              hasError: controller.passwordError.value != null,
              suffix: _EyeIcon(
                obscure: controller.obscurePassword.value,
                onTap: controller.toggleObscure,
              ),
            ),
          ),
        ),
        Obx(() => _ErrorText(controller.passwordError.value)),

        const SizedBox(height: 24),

        Obx(
          () => ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : controller.savedPasswordLogin,
            child: controller.isLoading.value
                ? const _LoadingIndicator()
                : const Text('Нэвтрэх'),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // ── Input decoration helper ────────────────────────
  InputDecoration _inputDecoration({
    required String hint,
    required bool hasError,
    Widget? suffix,
  }) {
    final borderColor = hasError ? AppTheme.error : AppTheme.borderColor;
    final focusColor = hasError ? AppTheme.error : AppTheme.primary;
    final width = hasError ? 1.5 : 1.0;

    return InputDecoration(
      hintText: hint,
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor, width: width),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: focusColor, width: 1.5),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  Saved user card
// ═══════════════════════════════════════════════════════
class _SavedUserCard extends StatelessWidget {
  final String name;
  final String email;
  final String? imageUrl;
  const _SavedUserCard({
    required this.name,
    required this.email,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderColor.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppTheme.primaryLight.withValues(alpha: 0.2),
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
            child: imageUrl == null
                ? Text(
                    name[0].toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: AppTheme.textDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                email,
                style: const TextStyle(color: AppTheme.textGrey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  BiometricPromptScreen
// ═══════════════════════════════════════════════════════
class BiometricPromptScreen extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onSkip;
  const BiometricPromptScreen({
    super.key,
    required this.onAccept,
    required this.onSkip,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onAccept,
    required VoidCallback onSkip,
  }) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) =>
            BiometricPromptScreen(onAccept: onAccept, onSkip: onSkip),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 48),
              const Center(child: NetworkLogo()),
              const Spacer(),
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: FaceIdIcon(size: 44, color: AppTheme.primary),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Та цаашид нэвтрэхдээ\nFace ID ашиглах уу?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Тохиргоог идэвхжүүлснээр илүү хурдан\nнэвтрэх боломжтой.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textGrey,
                  height: 1.6,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onAccept();
                },
                child: const Text('Зөвшөөрөх'),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onSkip();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: AppTheme.outlineBtn,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    foregroundColor: AppTheme.textDark,
                  ),
                  child: const Text(
                    'Алгасах',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  Apple Face ID icon
// ═══════════════════════════════════════════════════════
class FaceIdIcon extends StatelessWidget {
  final double size;
  final Color color;
  const FaceIdIcon({super.key, this.size = 24, this.color = AppTheme.primary});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(painter: _FaceIdPainter(color: color)),
  );
}

class _FaceIdPainter extends CustomPainter {
  final Color color;
  const _FaceIdPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07
      ..strokeCap = StrokeCap.round;
    final w = size.width, h = size.height, cr = w * 0.18;

    canvas.drawArc(
      Rect.fromLTWH(0, 0, cr * 2, cr * 2),
      3.14159 * 1.0,
      3.14159 * 0.5,
      false,
      p,
    );
    canvas.drawLine(Offset(cr, 0), Offset(w * 0.32, 0), p);
    canvas.drawLine(Offset(0, cr), Offset(0, h * 0.32), p);

    canvas.drawArc(
      Rect.fromLTWH(w - cr * 2, 0, cr * 2, cr * 2),
      3.14159 * 1.5,
      3.14159 * 0.5,
      false,
      p,
    );
    canvas.drawLine(Offset(w - cr, 0), Offset(w * 0.68, 0), p);
    canvas.drawLine(Offset(w, cr), Offset(w, h * 0.32), p);

    canvas.drawArc(
      Rect.fromLTWH(0, h - cr * 2, cr * 2, cr * 2),
      3.14159 * 0.5,
      3.14159 * 0.5,
      false,
      p,
    );
    canvas.drawLine(Offset(cr, h), Offset(w * 0.32, h), p);
    canvas.drawLine(Offset(0, h - cr), Offset(0, h * 0.68), p);

    canvas.drawArc(
      Rect.fromLTWH(w - cr * 2, h - cr * 2, cr * 2, cr * 2),
      0,
      3.14159 * 0.5,
      false,
      p,
    );
    canvas.drawLine(Offset(w - cr, h), Offset(w * 0.68, h), p);
    canvas.drawLine(Offset(w, h - cr), Offset(w, h * 0.68), p);

    final f = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.35, h * 0.38), w * 0.06, f);
    canvas.drawCircle(Offset(w * 0.65, h * 0.38), w * 0.06, f);

    canvas.drawPath(
      Path()
        ..moveTo(w * 0.5, h * 0.44)
        ..lineTo(w * 0.5, h * 0.58)
        ..lineTo(w * 0.44, h * 0.63),
      p,
    );
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.33, h * 0.70)
        ..quadraticBezierTo(w * 0.5, h * 0.82, w * 0.67, h * 0.70),
      p,
    );
  }

  @override
  bool shouldRepaint(_FaceIdPainter old) => old.color != color;
}

// ═══════════════════════════════════════════════════════
//  Helper widgets
// ═══════════════════════════════════════════════════════

// Error текст — null бол хоосон, утга байвал улаан текст
class _ErrorText extends StatelessWidget {
  final String? text;
  const _ErrorText(this.text);

  @override
  Widget build(BuildContext context) {
    if (text == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        text!,
        style: const TextStyle(color: AppTheme.error, fontSize: 13),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: AppTheme.textDark,
    ),
  );
}

class _EyeIcon extends StatelessWidget {
  final bool obscure;
  final VoidCallback onTap;
  const _EyeIcon({required this.obscure, required this.onTap});

  @override
  Widget build(BuildContext context) => IconButton(
    icon: Icon(
      obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
      color: AppTheme.textGrey,
      size: 20,
    ),
    onPressed: onTap,
  );
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 22,
    width: 22,
    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
  );
}
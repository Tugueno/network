import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/network_logo.dart';
import '../../widgets/face_id_icon.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

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
          child: Obx(() {
            // Logout хийсний дараа → rememberedEmail байгаа + isLoggedOut = true
            if (controller.isLoggedOut.value && controller.hasRemembered) {
              return _LoggedOutSection(controller: controller);
            }
            // Saved login — нэвтэрсэн, биометрик хуудас алгасаад auth руу ирсэн
            if (controller.hasRemembered && !controller.isLoggedOut.value) {
              return _SavedLoginSection(controller: controller);
            }
            // Энгийн login
            return _NormalLoginSection(controller: controller);
          }),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  1. Энгийн login — email + нууц үг
// ═══════════════════════════════════════════════════════
class _NormalLoginSection extends StatelessWidget {
  final AuthController controller;
  const _NormalLoginSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 48),
        const Center(child: NetworkLogo()),
        const SizedBox(height: 48),
        const _Title(),
        const SizedBox(height: 28),

        // Email
        const _FieldLabel('Имэйл'),
        const SizedBox(height: 6),
        Obx(
          () => _InputField(
            controller: controller.emailController,
            hint: 'Бүртгэлтэй имэйлаа оруулаарай',
            hasError: controller.emailError.value != null,
            onChanged: (_) => controller.clearEmailError(),
          ),
        ),
        Obx(() => _ErrorText(controller.emailError.value)),
        const SizedBox(height: 16),

        // Нууц үг
        const _FieldLabel('Нууц үг'),
        const SizedBox(height: 6),
        Obx(
          () => _InputField(
            controller: controller.passwordController,
            hint: 'Нууц үг оруулах',
            hasError: controller.passwordError.value != null,
            obscure: controller.obscurePassword.value,
            onChanged: (_) => controller.clearPwError(),
            suffix: _EyeIcon(
              obscure: controller.obscurePassword.value,
              onTap: controller.toggleObscure,
            ),
          ),
        ),
        Obx(() => _ErrorText(controller.passwordError.value)),
        const SizedBox(height: 28),

        // Нэвтрэх товч
        Obx(
          () => _PrimaryButton(
            label: 'Нэвтрэх',
            isLoading: controller.isLoading.value,
            onPressed: controller.login,
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════
//  2. Saved login — Face ID / нууц үг
// ═══════════════════════════════════════════════════════
class _SavedLoginSection extends StatelessWidget {
  final AuthController controller;
  const _SavedLoginSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 48),
        const Center(child: NetworkLogo()),
        const SizedBox(height: 48),
        const _Title(),
        const SizedBox(height: 24),

        Obx(
          () => _UserCard(
            name: controller.rememberedEmail.value!.split('@').first,
            email: controller.rememberedEmail.value!,
            imageUrl: controller.rememberedImageUrl.value,
          ),
        ),
        const SizedBox(height: 16),

        // Нууц үг талбар (toggle)
        Obx(
          () => controller.showPasswordField.value
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('Нууц үг'),
                    const SizedBox(height: 6),
                    _InputField(
                      controller: controller.passwordController,
                      hint: '••••••••',
                      hasError: controller.passwordError.value != null,
                      obscure: controller.obscurePassword.value,
                      autofocus: true,
                      onChanged: (_) => controller.clearPwError(),
                      suffix: _EyeIcon(
                        obscure: controller.obscurePassword.value,
                        onTap: controller.toggleObscure,
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
                ? const _Spinner()
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

        // Toggle текст
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
        const SizedBox(height: 16),

        // Өөр акаунтаар нэвтрэх
        Center(
          child: GestureDetector(
            onTap: controller.switchAccount,
            child: const Text(
              'Өөр акаунтаар нэвтрэх',
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════
//  3. Logout дараах — UserCard + нууц үг талбар
// ═══════════════════════════════════════════════════════
class _LoggedOutSection extends StatelessWidget {
  final AuthController controller;
  const _LoggedOutSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 48),
        const Center(child: NetworkLogo()),
        const SizedBox(height: 48),
        const _Title(),
        const SizedBox(height: 24),

        // Хэрэглэгчийн карт
        Obx(
          () => _UserCard(
            name: controller.rememberedEmail.value!.split('@').first,
            email: controller.rememberedEmail.value!,
            imageUrl: controller.rememberedImageUrl.value,
          ),
        ),
        const SizedBox(height: 16),

        // Нууц үг
        const _FieldLabel('Нууц үг'),
        const SizedBox(height: 6),
        Obx(
          () => _InputField(
            controller: controller.passwordController,
            hint: 'Нууц үг оруулах',
            hasError: controller.passwordError.value != null,
            obscure: controller.obscurePassword.value,
            autofocus: true,
            onChanged: (_) => controller.clearPwError(),
            suffix: _EyeIcon(
              obscure: controller.obscurePassword.value,
              onTap: controller.toggleObscure,
            ),
          ),
        ),
        Obx(() => _ErrorText(controller.passwordError.value)),
        const SizedBox(height: 24),

        // Нэвтрэх товч
        Obx(
          () => _PrimaryButton(
            label: 'Нэвтрэх',
            isLoading: controller.isLoading.value,
            onPressed: controller.savedPasswordLogin,
          ),
        ),
        const SizedBox(height: 16),

        // Өөр акаунтаар нэвтрэх
        Center(
          child: GestureDetector(
            onTap: controller.switchAccount,
            child: const Text(
              'Өөр акаунтаар нэвтрэх',
              style: TextStyle(color: AppTheme.textGrey, fontSize: 14),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════
//  Дахин ашиглагдах жижиг widget-үүд
// ═══════════════════════════════════════════════════════
class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) => const Text(
    'NetWork-д тавтай морил.',
    style: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: AppTheme.textDark,
    ),
  );
}

class _UserCard extends StatelessWidget {
  final String name, email;
  final String? imageUrl;
  const _UserCard({required this.name, required this.email, this.imageUrl});

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

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool hasError;
  final bool obscure;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.hasError,
    this.obscure = false,
    this.autofocus = false,
    this.onChanged,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = hasError ? AppTheme.error : AppTheme.borderColor;
    final focusColor = hasError ? AppTheme.error : AppTheme.primary;
    final width = hasError ? 1.5 : 1.0;

    return TextField(
      controller: controller,
      obscureText: obscure,
      autofocus: autofocus,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: width),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: focusColor, width: 1.5),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;
  const _PrimaryButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: isLoading ? null : onPressed,
    child: isLoading ? const _Spinner() : Text(label),
  );
}

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

class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 22,
    width: 22,
    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
  );
}
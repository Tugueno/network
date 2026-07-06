import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../theme/app_system_ui.dart';
import '../../theme/app_theme.dart';
import '../../widgets/network_logo.dart';

const Color _homeGradientStart = Color(0xFFF9FAFF);
const Color _homeGradientMiddle = Color(0xFFEFF3FF);
const Color _homeSafeAreaBottomColor = Color(0xFFF6F2FF);

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusBarColor = isDark
        ? appColors.screenBackground
        : _homeGradientStart;
    final navigationBarColor = isDark
        ? appColors.screenBackground
        : _homeSafeAreaBottomColor;

    return StatusAwarePage(
      backgroundColor: statusBarColor,
      navigationBarColor: navigationBarColor,
      extendBody: true,
      child: _HomeBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 124),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: NetworkLogo()),
                const SizedBox(height: 44),
                Obx(
                  () => Text(
                    'Сайн байна уу, ${controller.userName.value}!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: appColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Үндсэн үйлдлүүдээ доорх цэснээс сонгоно уу.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: appColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),
                const _WelcomeGlassCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeGlassCard extends StatelessWidget {
  const _WelcomeGlassCard();

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    final themeController = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: appColors.cardBackground.withValues(alpha: isDark ? 0.82 : 0.64),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? appColors.border
              : Colors.white.withValues(alpha: 0.86),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: isDark ? 0.16 : 0.08),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.dashboard_customize_outlined,
            color: AppTheme.primary,
            size: 30,
          ),
          const SizedBox(height: 18),
          Text(
            'NetWork хяналтын самбар',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: appColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ирц, төлбөр болон урьдчилгааны хүсэлтүүдээ нэг дороос удирдана.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: appColors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          DecoratedBox(
            decoration: BoxDecoration(
              color: appColors.subtleFill.withValues(alpha: isDark ? 0.76 : 1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: appColors.border),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.dark_mode_outlined,
                    size: 20,
                    color: appColors.textSecondary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Dark mode',
                      style: TextStyle(
                        color: appColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Obx(
                    () => Switch(
                      value: themeController.isDarkMode,
                      onChanged: themeController.setDarkMode,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeBackground extends StatelessWidget {
  final Widget child;

  const _HomeBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  appColors.screenBackground,
                  appColors.subtleFill,
                  appColors.screenBackground,
                ]
              : const [
                  _homeGradientStart,
                  _homeGradientMiddle,
                  _homeSafeAreaBottomColor,
                ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -80,
            right: -70,
            child: _GlowOrb(size: 240, color: AppTheme.primaryLight),
          ),
          const Positioned(
            bottom: 40,
            left: -90,
            child: _GlowOrb(size: 220, color: Color(0xFFB57BFF)),
          ),
          child,
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: isDark ? 0.10 : 0.16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isDark ? 0.10 : 0.12),
            blurRadius: 70,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}

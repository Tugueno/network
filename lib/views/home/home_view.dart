import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
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
    final topPadding = MediaQuery.paddingOf(context).top;
    final overlayStyle = AppSystemUi.forView(
      topColor: _homeGradientStart,
      bottomColor: _homeSafeAreaBottomColor,
    );
    AppSystemUi.apply(overlayStyle);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: _HomeBackground(
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, topPadding + 24, 24, 124),
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
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Үндсэн үйлдлүүдээ доорх цэснээс сонгоно уу.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: AppTheme.textGrey,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const _WelcomeGlassCard(),
                ],
              ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.64),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.86)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.dashboard_customize_outlined,
            color: AppTheme.primary,
            size: 30,
          ),
          SizedBox(height: 18),
          Text(
            'NetWork хяналтын самбар',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Ирц, төлбөр болон урьдчилгааны хүсэлтүүдээ нэг дороос удирдана.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppTheme.textGrey,
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
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
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
          Positioned(
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
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 70,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}

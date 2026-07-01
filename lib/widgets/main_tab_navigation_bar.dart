import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ncapp/theme/app_theme.dart';
import 'package:ncapp/widgets/liquid_glass_navigation_bar.dart';

enum MainTab { home, advanceReq, requests, paymentReq }

class MainTabNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onLogout;

  const MainTabNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onLogout,
  });

  static const _destinations = [
    _MainTabDestination(
      tab: MainTab.home,
      icon: Icons.home_outlined,
      label: 'Нүүр',
    ),
    _MainTabDestination(
      tab: MainTab.advanceReq,
      icon: Icons.receipt_long_outlined,
      label: 'Урьдчилгаа',
    ),
    _MainTabDestination(
      tab: MainTab.requests,
      icon: Icons.schedule_outlined,
      label: 'Ирц',
    ),
    _MainTabDestination(
      tab: MainTab.paymentReq,
      icon: Icons.payments_outlined,
      label: 'Төлбөр',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(14, 0, 14, 16),
      child: Row(
        children: [
          Expanded(
            child: LiquidGlassNavigationBar(
              useSafeArea: false,
              maxWidth: null,
              height: 72,
              borderRadius: 42,
              currentIndex: currentIndex,
              onItemSelected: onTabSelected,
              items: [
                for (final destination in _destinations)
                  LiquidGlassNavigationItem(
                    icon: destination.icon,
                    label: destination.label,
                    selected: destination.tab.index == currentIndex,
                    onTap: () {},
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _LogoutGlassButton(onTap: onLogout),
        ],
      ),
    );
  }
}

class _MainTabDestination {
  final MainTab tab;
  final IconData icon;
  final String label;

  const _MainTabDestination({
    required this.tab,
    required this.icon,
    required this.label,
  });
}

class _LogoutGlassButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutGlassButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 30,
            spreadRadius: -9,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.10),
            blurRadius: 22,
            spreadRadius: -12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Ink(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.88),
                    const Color(0xFFFFFFFF).withValues(alpha: 0.72),
                    const Color(0xFFD8DDE8).withValues(alpha: 0.50),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.78),
                  width: 1.4,
                ),
              ),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onTap,
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppTheme.error,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

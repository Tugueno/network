import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ncapp/widgets/liquid_glass_navigation_bar.dart';

enum MainTab { home, advanceReq, requests, paymentReq }

class MainTabNavigationBar extends StatelessWidget {
  final ValueListenable<LiquidGlassTabIndicatorState> indicatorState;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onLogout;

  const MainTabNavigationBar({
    super.key,
    required this.indicatorState,
    required this.onTabSelected,
    required this.onLogout,
  });

  static const _destinations = [
    _MainTabDestination(
      tab: MainTab.home,
      symbolName: 'homepod.and.appletv',
      selectedSymbolName: 'homepod.and.appletv.fill',
      fallbackIcon: CupertinoIcons.house,
      selectedFallbackIcon: CupertinoIcons.house_fill,
      label: 'Нүүр',
    ),
    _MainTabDestination(
      tab: MainTab.advanceReq,
      symbolName: 'doc.plaintext',
      selectedSymbolName: 'doc.plaintext.fill',
      fallbackIcon: CupertinoIcons.doc_text,
      selectedFallbackIcon: CupertinoIcons.doc_text_fill,
      label: 'Урьдчилгаа',
    ),
    _MainTabDestination(
      tab: MainTab.requests,
      symbolName: 'calendar.badge.clock',
      selectedSymbolName: 'calendar.badge.clock',
      fallbackIcon: CupertinoIcons.clock,
      selectedFallbackIcon: CupertinoIcons.clock_fill,
      label: 'Ирц',
    ),
    _MainTabDestination(
      tab: MainTab.paymentReq,
      symbolName: 'creditcard.and.123',
      selectedSymbolName: 'creditcard.and.123',
      fallbackIcon: CupertinoIcons.creditcard,
      selectedFallbackIcon: CupertinoIcons.creditcard_fill,
      label: 'Төлбөр',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LiquidGlassNavigationBar(
      useSafeArea: false,
      maxWidth: 402,
      height: 60,
      borderRadius: 999,
      tint: CupertinoColors.white,
      backgroundColor: CupertinoColors.white.withValues(alpha: 0.20),
      indicatorState: indicatorState,
      onItemSelected: (index) {
        if (index < _destinations.length) {
          onTabSelected(index);
        }
      },
      items: [
        for (final destination in _destinations)
          LiquidGlassNavigationItem(
            symbolName: destination.symbolName,
            selectedSymbolName: destination.selectedSymbolName,
            fallbackIcon: destination.fallbackIcon,
            selectedFallbackIcon: destination.selectedFallbackIcon,
            label: destination.label,
            onTap: () {},
          ),
        LiquidGlassNavigationItem(
          symbolName: 'rectangle.portrait.and.arrow.right',
          selectedSymbolName: 'rectangle.portrait.and.arrow.right.fill',
          fallbackIcon: Icons.logout_rounded,
          selectedFallbackIcon: Icons.logout_rounded,
          label: 'Гарах',
          destructive: true,
          onTap: onLogout,
        ),
      ],
    );
  }
}

class _MainTabDestination {
  final MainTab tab;
  final String symbolName;
  final String selectedSymbolName;
  final IconData fallbackIcon;
  final IconData selectedFallbackIcon;
  final String label;

  const _MainTabDestination({
    required this.tab,
    required this.symbolName,
    required this.selectedSymbolName,
    required this.fallbackIcon,
    required this.selectedFallbackIcon,
    required this.label,
  });
}

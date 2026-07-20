import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ncapp/features/advance_req/views/advance_req_view.dart';
import 'package:ncapp/features/payment_req/views/payment_req_view.dart';
import 'package:ncapp/features/requests/views/requests_view.dart';
import 'package:ncapp/theme/app_system_ui.dart';
import 'package:ncapp/theme/app_theme.dart';
import 'package:ncapp/views/home/home_view.dart';

enum MainTab { home, advanceReq, requests, paymentReq, profile }

class MainTabShell extends StatefulWidget {
  final MainTab initialTab;

  const MainTabShell({super.key, this.initialTab = MainTab.home});

  @override
  State<MainTabShell> createState() => _MainTabShellState();
}

class _MainTabShellState extends State<MainTabShell> {
  late int _currentIndex;

  static const List<Widget> _pages = [
    HomeView(),
    AdvanceReqView(),
    RequestsView(),
    PaymentReqView(),
    _ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab.index;
  }

  @override
  void didUpdateWidget(covariant MainTabShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      _currentIndex = widget.initialTab.index;
    }
  }

  void _selectTab(int index) {
    if (index == _currentIndex || index < 0 || index >= _pages.length) {
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  void _applySystemUiForCurrentTab(BuildContext context) {
    final appColors = AppTheme.colors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tab = MainTab.values[_currentIndex];

    final overlayStyle = tab == MainTab.home
        ? SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark
                ? Brightness.light
                : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarIconBrightness: isDark
                ? Brightness.light
                : Brightness.dark,
          )
        : AppSystemUi.forPageBackground(
            bgColor: tab == MainTab.requests
                ? appColors.subtleFill
                : appColors.screenBackground,
            isDark: isDark,
            navigationBarColor: tab == MainTab.requests
                ? appColors.subtleFill
                : appColors.screenBackground,
          );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        AppSystemUi.apply(overlayStyle);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _applySystemUiForCurrentTab(context);

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: CNTabBar(
        currentIndex: _currentIndex,
        onTap: _selectTab,
        tint: CupertinoColors.activeBlue,
        backgroundColor: Colors.transparent,
        items: const [
          CNTabBarItem(label: 'Нүүр', icon: CNSymbol('house.fill')),
          CNTabBarItem(label: 'Урьдчилгаа', icon: CNSymbol('creditcard.fill')),
          CNTabBarItem(
            label: 'Ирц',
            icon: CNSymbol('calendar.badge.checkmark'),
          ),
          CNTabBarItem(label: 'Төлбөр', icon: CNSymbol('banknote.fill')),
          CNTabBarItem(
            label: 'Профайл',
            icon: CNSymbol('person.crop.circle.fill'),
          ),
        ],
      ),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
          'Профайл',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

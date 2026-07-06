import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/app/app_routes.dart';
import 'package:ncapp/controllers/auth_controller.dart';
import 'package:ncapp/controllers/main_tab_controller.dart';
import 'package:ncapp/features/advance_req/views/advance_req_view.dart';
import 'package:ncapp/features/payment_req/views/payment_req_view.dart';
import 'package:ncapp/features/requests/requests_controller.dart';
import 'package:ncapp/features/requests/views/requests_view.dart';
import 'package:ncapp/theme/app_system_ui.dart';
import 'package:ncapp/theme/app_theme.dart';
import 'package:ncapp/views/home/home_view.dart';
import 'package:ncapp/widgets/liquid_glass_navigation_bar.dart'
    show LiquidGlassTabIndicatorState;
import 'package:ncapp/widgets/main_tab_navigation_bar.dart';

const Color _homeLightStatusBarColor = Color(0xFFF9FAFF);
const Color _homeLightNavigationBarColor = Color(0xFFF6F2FF);

class MainTabShell extends StatefulWidget {
  final MainTab initialTab;

  const MainTabShell({super.key, this.initialTab = MainTab.home});

  @override
  State<MainTabShell> createState() => _MainTabShellState();
}

class _MainTabShellState extends State<MainTabShell> {
  static const _tabCount = 4;

  late final PageController _pageController;
  late final ValueNotifier<LiquidGlassTabIndicatorState> _indicatorState;
  late int _selectedIndex;
  late int _activeTabIndex;

  int _tapReactionId = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab.index;
    _activeTabIndex = _selectedIndex;
    _pageController = PageController(initialPage: _selectedIndex)
      ..addListener(_handlePageScroll);
    _indicatorState = ValueNotifier(
      LiquidGlassTabIndicatorState.centered(_selectedIndex),
    );
    _syncController();
  }

  @override
  void didUpdateWidget(covariant MainTabShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      _jumpToTab(widget.initialTab.index, animateIndicator: false);
    }
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_handlePageScroll)
      ..dispose();
    _indicatorState.dispose();
    super.dispose();
  }

  void _logout() {
    try {
      Get.find<AuthController>().logout();
    } catch (_) {}
    Get.offAllNamed(AppRoutes.auth);
  }

  void _handlePageScroll() {
    if (!_pageController.hasClients) return;

    final page = _pageController.page ?? _selectedIndex.toDouble();
    final position = page.clamp(0.0, _tabCount - 1.0).toDouble();
    _setIndicatorState(
      position: position,
      activeIndex: _activeTabIndex,
      animate: false,
      preserveAnimationIfSamePosition: true,
    );
  }

  void _handlePageChanged(int index) {
    if (index < 0 || index >= _tabCount || index == _selectedIndex) {
      return;
    }

    setState(() => _selectedIndex = index);
    _syncController();
  }

  bool _handlePageScrollEnd(ScrollEndNotification notification) {
    if (!_pageController.hasClients) return false;

    final page = _pageController.page ?? _selectedIndex.toDouble();
    final targetIndex = page.round().clamp(0, _tabCount - 1).toInt();
    if (_selectedIndex != targetIndex || _activeTabIndex != targetIndex) {
      setState(() {
        _selectedIndex = targetIndex;
        _activeTabIndex = targetIndex;
      });
      _syncController();
    }
    _tapReactionId++;
    _setIndicatorState(
      position: targetIndex.toDouble(),
      activeIndex: targetIndex,
      animate: true,
      reactionId: _tapReactionId,
    );
    return false;
  }

  void _jumpToTab(int index, {required bool animateIndicator}) {
    if (index < 0 || index >= _tabCount) return;

    if (animateIndicator) {
      _tapReactionId++;
    }

    if (_selectedIndex != index || _activeTabIndex != index) {
      setState(() {
        _selectedIndex = index;
        _activeTabIndex = index;
      });
      _syncController();
    }

    _setIndicatorState(
      position: index.toDouble(),
      activeIndex: index,
      animate: animateIndicator,
      reactionId: _tapReactionId,
    );

    if (_pageController.hasClients) {
      _pageController.jumpToPage(index);
    }
  }

  void _handleTabTap(int index) {
    _jumpToTab(index, animateIndicator: true);
  }

  void _setIndicatorState({
    required double position,
    required int activeIndex,
    required bool animate,
    double stretch = 0,
    int? reactionId,
    bool preserveAnimationIfSamePosition = false,
  }) {
    final current = _indicatorState.value;
    final next = LiquidGlassTabIndicatorState(
      position: position.clamp(0.0, _tabCount - 1.0).toDouble(),
      activeIndex: activeIndex.clamp(0, _tabCount - 1).toInt(),
      animate: animate,
      stretch: stretch.clamp(-0.48, 0.48).toDouble(),
      reactionId: reactionId ?? current.reactionId,
    );

    final samePosition = (current.position - next.position).abs() < 0.001;
    final sameActiveIndex = current.activeIndex == next.activeIndex;
    final sameStretch = (current.stretch - next.stretch).abs() < 0.001;
    final sameReaction = current.reactionId == next.reactionId;
    if (samePosition && sameActiveIndex && sameStretch && sameReaction) {
      if (preserveAnimationIfSamePosition || current.animate == next.animate) {
        return;
      }
    }

    _indicatorState.value = next;
  }

  void _syncController() {
    if (!Get.isRegistered<MainTabController>()) return;
    Get.find<MainTabController>().selectTab(MainTab.values[_selectedIndex]);
  }

  int get _requestsSelectedCount {
    try {
      return Get.find<RequestsController>().selectedCount;
    } catch (_) {
      return 0;
    }
  }

  MainTab get _selectedTab {
    final index = _selectedIndex.clamp(0, _tabCount - 1).toInt();
    return MainTab.values[index];
  }

  Color _statusBarColorForSelectedTab(BuildContext context) {
    final appColors = AppTheme.colors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (_selectedTab) {
      case MainTab.home:
        return isDark ? appColors.screenBackground : _homeLightStatusBarColor;
      case MainTab.requests:
        return appColors.subtleFill;
      case MainTab.advanceReq:
      case MainTab.paymentReq:
        return appColors.screenBackground;
    }
  }

  Color _navigationBarColorForSelectedTab(BuildContext context) {
    final appColors = AppTheme.colors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (_selectedTab) {
      case MainTab.home:
        return isDark
            ? appColors.screenBackground
            : _homeLightNavigationBarColor;
      case MainTab.requests:
        return appColors.subtleFill;
      case MainTab.advanceReq:
      case MainTab.paymentReq:
        return appColors.screenBackground;
    }
  }

  Widget? _buildNavigationBar() {
    final navigationBar = MainTabNavigationBar(
      indicatorState: _indicatorState,
      onTabSelected: _handleTabTap,
      onLogout: _logout,
    );

    if (_selectedIndex != MainTab.requests.index) {
      return navigationBar;
    }

    return Obx(
      () =>
          _requestsSelectedCount == 0 ? navigationBar : const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final navigationBar = _buildNavigationBar();
    final statusBarColor = _statusBarColorForSelectedTab(context);
    final navigationBarColor = _navigationBarColorForSelectedTab(context);
    final bottomNavigationBar = navigationBar == null
        ? null
        : SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(14, 0, 14, 24),
            child: navigationBar,
          );

    return StatusAwarePage(
      backgroundColor: statusBarColor,
      navigationBarColor: navigationBarColor,
      safeAreaTop: false,
      safeAreaLeft: false,
      safeAreaRight: false,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: bottomNavigationBar,
      child: NotificationListener<ScrollEndNotification>(
        onNotification: _handlePageScrollEnd,
        child: PageView(
          controller: _pageController,
          onPageChanged: _handlePageChanged,
          physics: const BouncingScrollPhysics(),
          children: const [
            HomeView(),
            AdvanceReqView(),
            RequestsView(),
            PaymentReqView(),
          ],
        ),
      ),
    );
  }
}

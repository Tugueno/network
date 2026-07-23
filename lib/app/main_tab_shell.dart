import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ncapp/features/advance_req/views/advance_req_view.dart';
import 'package:ncapp/features/payment_req/views/payment_req_view.dart';
import 'package:ncapp/features/requests/views/requests_view.dart';
import 'package:ncapp/theme/app_system_ui.dart';
import 'package:ncapp/theme/app_theme.dart';
import 'package:ncapp/views/home/home_view.dart';

enum MainTab { home, advanceReq, requests, paymentReq, profile }

/// Which bottom-tab-bar implementation should be used on a compact
/// (< [MainTabShell._compactBreakpoint]) layout.
///
/// - [nativeIos]: real UIKit tab bar via `cupertino_native`. iOS app only,
///   never on web (there is no native host view to attach to on web).
/// - [material]: standard Flutter Material `NavigationBar`. Android app only.
/// - [flutterCupertino]: pure-Flutter `CupertinoTabBar` fallback. Used for
///   Flutter Web (any browser, including iOS/Android browsers) and for any
///   other non-iOS/non-Android target platform.
enum _CompactTabBarStyle { nativeIos, material, flutterCupertino }

class MainTabShell extends StatefulWidget {
  final MainTab initialTab;

  const MainTabShell({super.key, this.initialTab = MainTab.home});

  @override
  State<MainTabShell> createState() => _MainTabShellState();
}

class _MainTabShellState extends State<MainTabShell> {
  late int _currentIndex;
  bool _isSidebarCollapsed = false;

  static const double _compactBreakpoint = 600;
  static const double _sidebarExpandedWidth = 240;
  static const double _sidebarCollapsedWidth = 72;
  static const Duration _sidebarAnimationDuration = Duration(milliseconds: 200);

  static const List<Widget> _pages = [
    HomeView(),
    AdvanceReqView(),
    RequestsView(),
    PaymentReqView(),
    _ProfileView(),
  ];

  static const List<_MainTabDestination> _destinations = [
    _MainTabDestination(
      label: 'Нүүр',
      symbolName: 'house.fill',
      sidebarIcon: Icons.home_rounded,
    ),
    _MainTabDestination(
      label: 'Урьдчилгаа',
      symbolName: 'creditcard.fill',
      sidebarIcon: Icons.credit_card_rounded,
    ),
    _MainTabDestination(
      label: 'Ирц',
      symbolName: 'calendar.badge.checkmark',
      sidebarIcon: Icons.event_available_rounded,
    ),
    _MainTabDestination(
      label: 'Төлбөр',
      symbolName: 'banknote.fill',
      sidebarIcon: Icons.payments_rounded,
    ),
    _MainTabDestination(
      label: 'Профайл',
      symbolName: 'person.crop.circle.fill',
      sidebarIcon: Icons.account_circle_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab.index;
  }

  @override
  void didUpdateWidget(covariant MainTabShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only react to an externally-driven tab change (e.g. deep link);
    // a plain rebuild (resize, rotation, theme change, ...) must never
    // reset the tab the user is currently on.
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

  void _toggleSidebarCollapsed() {
    setState(() {
      _isSidebarCollapsed = !_isSidebarCollapsed;
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

  /// Resolves which compact tab bar implementation to use for the *current*
  /// runtime target. This is the single place that decides native-vs-Flutter
  /// rendering, so platform checks never leak into the widgets below.
  _CompactTabBarStyle get _compactTabBarStyle {
    // Web (desktop or mobile browser) never gets native platform views —
    // there's no host UIKit/Android view for cupertino_native to attach to.
    if (kIsWeb) {
      return _CompactTabBarStyle.flutterCupertino;
    }

    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS => _CompactTabBarStyle.nativeIos,
      TargetPlatform.android => _CompactTabBarStyle.material,
      _ => _CompactTabBarStyle.flutterCupertino,
    };
  }

  @override
  Widget build(BuildContext context) {
    _applySystemUiForCurrentTab(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final useSidebar = constraints.maxWidth >= _compactBreakpoint;

        // Switching between sidebar/compact on resize or rotation is purely
        // a layout decision here — _currentIndex lives on State and is
        // untouched by this rebuild, so the active tab survives seamlessly.
        if (useSidebar) {
          return _DesktopTabShell(
            currentIndex: _currentIndex,
            destinations: _destinations,
            pages: _pages,
            expandedWidth: _sidebarExpandedWidth,
            collapsedWidth: _sidebarCollapsedWidth,
            animationDuration: _sidebarAnimationDuration,
            isCollapsed: _isSidebarCollapsed,
            onToggleCollapsed: _toggleSidebarCollapsed,
            onSelectTab: _selectTab,
          );
        }

        return _CompactTabShell(
          style: _compactTabBarStyle,
          currentIndex: _currentIndex,
          destinations: _destinations,
          pages: _pages,
          onSelectTab: _selectTab,
        );
      },
    );
  }
}

class _MainTabDestination {
  final String label;
  final String symbolName;
  final IconData sidebarIcon;

  const _MainTabDestination({
    required this.label,
    required this.symbolName,
    required this.sidebarIcon,
  });
}

/// Mobile / narrow-web layout: full-bleed page content with a bottom tab
/// bar whose implementation is chosen by [style].
class _CompactTabShell extends StatelessWidget {
  final _CompactTabBarStyle style;
  final int currentIndex;
  final List<_MainTabDestination> destinations;
  final List<Widget> pages;
  final ValueChanged<int> onSelectTab;

  const _CompactTabShell({
    required this.style,
    required this.currentIndex,
    required this.destinations,
    required this.pages,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: switch (style) {
        _CompactTabBarStyle.nativeIos => _NativeIosBottomTabBar(
          currentIndex: currentIndex,
          destinations: destinations,
          onSelectTab: onSelectTab,
        ),
        _CompactTabBarStyle.material => _MaterialBottomTabBar(
          currentIndex: currentIndex,
          destinations: destinations,
          onSelectTab: onSelectTab,
        ),
        _CompactTabBarStyle.flutterCupertino => _FlutterCupertinoBottomTabBar(
          currentIndex: currentIndex,
          destinations: destinations,
          onSelectTab: onSelectTab,
        ),
      },
    );
  }
}

/// iOS app only. Wraps a real UIKit `UITabBar` via `cupertino_native`.
/// Never constructed on web or Android — see [_MainTabShellState._compactTabBarStyle].
class _NativeIosBottomTabBar extends StatelessWidget {
  final int currentIndex;
  final List<_MainTabDestination> destinations;
  final ValueChanged<int> onSelectTab;

  const _NativeIosBottomTabBar({
    required this.currentIndex,
    required this.destinations,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    return CNTabBar(
      currentIndex: currentIndex,
      onTap: onSelectTab,
      tint: CupertinoColors.activeBlue,
      backgroundColor: Colors.transparent,
      items: [
        for (final destination in destinations)
          CNTabBarItem(
            label: destination.label,
            icon: CNSymbol(destination.symbolName),
          ),
      ],
    );
  }
}

/// Android app only. Standard Material 3 `NavigationBar` with plain
/// `Icons` — no native platform views, no `CNSymbol`.
class _MaterialBottomTabBar extends StatelessWidget {
  final int currentIndex;
  final List<_MainTabDestination> destinations;
  final ValueChanged<int> onSelectTab;

  const _MaterialBottomTabBar({
    required this.currentIndex,
    required this.destinations,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    final activeColor = CupertinoDynamicColor.resolve(
      CupertinoColors.activeBlue,
      context,
    );

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onSelectTab,
      backgroundColor: appColors.cardBackground,
      indicatorColor: activeColor.withValues(alpha: 0.12),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: [
        for (final destination in destinations)
          NavigationDestination(
            label: destination.label,
            icon: Icon(destination.sidebarIcon),
            selectedIcon: Icon(destination.sidebarIcon, color: activeColor),
          ),
      ],
    );
  }
}

/// Web (any browser width < breakpoint) and any other non-iOS/non-Android
/// target platform. Pure-Flutter fallback — no native views involved.
class _FlutterCupertinoBottomTabBar extends StatelessWidget {
  final int currentIndex;
  final List<_MainTabDestination> destinations;
  final ValueChanged<int> onSelectTab;

  const _FlutterCupertinoBottomTabBar({
    required this.currentIndex,
    required this.destinations,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);

    return CupertinoTabBar(
      currentIndex: currentIndex,
      onTap: onSelectTab,
      activeColor: CupertinoColors.activeBlue,
      inactiveColor: appColors.textSecondary,
      backgroundColor: appColors.cardBackground.withValues(alpha: 0.92),
      border: Border(top: BorderSide(color: appColors.border)),
      items: [
        for (final destination in destinations)
          BottomNavigationBarItem(
            label: destination.label,
            icon: Icon(destination.sidebarIcon),
          ),
      ],
    );
  }
}

/// Wide-screen (desktop / wide web) layout: collapsible sidebar rail on
/// the left, page content in an `IndexedStack` on the right.
class _DesktopTabShell extends StatelessWidget {
  final int currentIndex;
  final List<_MainTabDestination> destinations;
  final List<Widget> pages;
  final double expandedWidth;
  final double collapsedWidth;
  final Duration animationDuration;
  final bool isCollapsed;
  final VoidCallback onToggleCollapsed;
  final ValueChanged<int> onSelectTab;

  const _DesktopTabShell({
    required this.currentIndex,
    required this.destinations,
    required this.pages,
    required this.expandedWidth,
    required this.collapsedWidth,
    required this.animationDuration,
    required this.isCollapsed,
    required this.onToggleCollapsed,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);

    return Scaffold(
      backgroundColor: appColors.screenBackground,
      body: Row(
        children: [
          _SidebarNavigation(
            expandedWidth: expandedWidth,
            collapsedWidth: collapsedWidth,
            animationDuration: animationDuration,
            isCollapsed: isCollapsed,
            onToggleCollapsed: onToggleCollapsed,
            currentIndex: currentIndex,
            destinations: destinations,
            onSelectTab: onSelectTab,
          ),
          Expanded(
            child: IndexedStack(index: currentIndex, children: pages),
          ),
        ],
      ),
    );
  }
}

/// Collapsible sidebar rail. Width animates between [expandedWidth] and
/// [collapsedWidth]; when collapsed, item labels are hidden, icons are
/// centered, and a `Tooltip` on each item stands in for the missing label.
class _SidebarNavigation extends StatelessWidget {
  final double expandedWidth;
  final double collapsedWidth;
  final Duration animationDuration;
  final bool isCollapsed;
  final VoidCallback onToggleCollapsed;
  final int currentIndex;
  final List<_MainTabDestination> destinations;
  final ValueChanged<int> onSelectTab;

  const _SidebarNavigation({
    required this.expandedWidth,
    required this.collapsedWidth,
    required this.animationDuration,
    required this.isCollapsed,
    required this.onToggleCollapsed,
    required this.currentIndex,
    required this.destinations,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);

    return AnimatedContainer(
      duration: animationDuration,
      curve: Curves.easeInOut,
      width: isCollapsed ? collapsedWidth : expandedWidth,
      decoration: BoxDecoration(
        color: appColors.elevatedSurface,
        border: Border(right: BorderSide(color: appColors.border)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 8 : 16,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isCollapsed)
                const SizedBox(height: 4)
              else
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    'Network',
                    style: TextStyle(
                      color: appColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              for (var index = 0; index < destinations.length; index++)
                _SidebarNavigationItem(
                  destination: destinations[index],
                  selected: currentIndex == index,
                  isCollapsed: isCollapsed,
                  onTap: () => onSelectTab(index),
                ),
              const Spacer(),
              _SidebarCollapseToggle(
                isCollapsed: isCollapsed,
                onTap: onToggleCollapsed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Button at the bottom of the sidebar that flips the collapsed state.
/// Shows a tooltip and the click cursor on hover, per the sidebar's own
/// hover conventions.
class _SidebarCollapseToggle extends StatefulWidget {
  final bool isCollapsed;
  final VoidCallback onTap;

  const _SidebarCollapseToggle({
    required this.isCollapsed,
    required this.onTap,
  });

  @override
  State<_SidebarCollapseToggle> createState() =>
      _SidebarCollapseToggleState();
}

class _SidebarCollapseToggleState extends State<_SidebarCollapseToggle> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    final isCollapsed = widget.isCollapsed;
    final tooltip = isCollapsed ? 'дэлгэх' : 'хумих';

    return Tooltip(
      message: tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            mouseCursor: SystemMouseCursors.click,
            borderRadius: BorderRadius.circular(8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              height: 44,
              alignment: isCollapsed ? Alignment.center : Alignment.centerLeft,
              padding: EdgeInsets.symmetric(
                horizontal: isCollapsed ? 0 : 14,
              ),
              decoration: BoxDecoration(
                color: _hovered ? appColors.subtleFill : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isCollapsed
                        ? CupertinoIcons.sidebar_left
                        : Icons.chevron_left_rounded,
                    size: 22,
                    color: appColors.textSecondary,
                  ),
                  if (!isCollapsed) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Хумих',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: appColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarNavigationItem extends StatefulWidget {
  final _MainTabDestination destination;
  final bool selected;
  final bool isCollapsed;
  final VoidCallback onTap;

  const _SidebarNavigationItem({
    required this.destination,
    required this.selected,
    required this.isCollapsed,
    required this.onTap,
  });

  @override
  State<_SidebarNavigationItem> createState() => _SidebarNavigationItemState();
}

class _SidebarNavigationItemState extends State<_SidebarNavigationItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    final activeColor = CupertinoDynamicColor.resolve(
      CupertinoColors.activeBlue,
      context,
    );
    final selected = widget.selected;
    final isCollapsed = widget.isCollapsed;
    final foregroundColor = selected ? activeColor : appColors.textSecondary;
    final backgroundColor = selected
        ? activeColor.withValues(alpha: 0.1)
        : _hovered
        ? appColors.subtleFill
        : Colors.transparent;

    final row = Row(
      mainAxisAlignment: isCollapsed
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        Icon(widget.destination.sidebarIcon, size: 22, color: foregroundColor),
        if (!isCollapsed) ...[
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.destination.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: foregroundColor,
                fontSize: 15,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );

    final item = Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            mouseCursor: SystemMouseCursors.click,
            borderRadius: BorderRadius.circular(8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 0 : 14),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: selected
                      ? activeColor.withValues(alpha: 0.18)
                      : Colors.transparent,
                ),
              ),
              child: row,
            ),
          ),
        ),
      ),
    );

    // Only the collapsed, icon-only state needs a tooltip to surface the
    // page name — the expanded state already shows the label inline.
    if (!isCollapsed) {
      return item;
    }

    return Tooltip(message: widget.destination.label, child: item);
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
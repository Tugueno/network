import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'web_status_bar_color.dart';

class AppSystemUi {
  const AppSystemUi._();

  static const light = SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static const lightTransparent = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static const darkTransparent = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  static SystemUiOverlayStyle forPageBackground({
    required Color bgColor,
    required bool isDark,
    Color? navigationBarColor,
  }) {
    final effectiveNavigationBarColor = navigationBarColor ?? bgColor;
    final navigationBarIsLight =
        ThemeData.estimateBrightnessForColor(effectiveNavigationBarColor) ==
        Brightness.light;

    return SystemUiOverlayStyle(
      statusBarColor: bgColor,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: effectiveNavigationBarColor,
      systemNavigationBarIconBrightness: navigationBarIsLight
          ? Brightness.dark
          : Brightness.light,
    );
  }

  static SystemUiOverlayStyle forBackground(Color color, {bool? isDark}) {
    final effectiveIsDark =
        isDark ??
        (ThemeData.estimateBrightnessForColor(color) == Brightness.dark);
    return forPageBackground(bgColor: color, isDark: effectiveIsDark);
  }

  static SystemUiOverlayStyle forScaffold({
    required Color statusBarColor,
    required Color navigationBarColor,
    bool? isDark,
  }) {
    final effectiveIsDark =
        isDark ??
        (ThemeData.estimateBrightnessForColor(statusBarColor) ==
            Brightness.dark);
    return forPageBackground(
      bgColor: statusBarColor,
      isDark: effectiveIsDark,
      navigationBarColor: navigationBarColor,
    );
  }

  static SystemUiOverlayStyle forView({
    required Color topColor,
    Color? bottomColor,
    bool? isDark,
  }) {
    return forScaffold(
      statusBarColor: topColor,
      navigationBarColor: bottomColor ?? topColor,
      isDark: isDark,
    );
  }

  static void apply(SystemUiOverlayStyle style) {
    SystemChrome.setSystemUIOverlayStyle(style);
    final statusBarColor = style.statusBarColor;
    if (statusBarColor != null) {
      WebStatusBarColor.setColor(statusBarColor);
    }
  }

  static void applyForView({required Color topColor, Color? bottomColor}) {
    apply(forView(topColor: topColor, bottomColor: bottomColor));
  }
}

class AppSystemUiRegion extends StatelessWidget {
  final Color bgColor;
  final Color? navigationBarColor;
  final bool? isDark;
  final Widget child;

  const AppSystemUiRegion({
    super.key,
    required this.bgColor,
    this.navigationBarColor,
    this.isDark,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIsDark =
        isDark ?? (Theme.of(context).brightness == Brightness.dark);
    final overlayStyle = AppSystemUi.forPageBackground(
      bgColor: bgColor,
      isDark: effectiveIsDark,
      navigationBarColor: navigationBarColor,
    );
    AppSystemUi.apply(overlayStyle);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: ColoredBox(color: bgColor, child: child),
    );
  }
}

class StatusAwarePage extends StatelessWidget {
  final Color backgroundColor;
  final Color? navigationBarColor;
  final bool? isDark;
  final Widget child;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final bool extendBody;
  final bool resizeToAvoidBottomInset;
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final bool safeAreaLeft;
  final bool safeAreaRight;

  const StatusAwarePage({
    super.key,
    required this.backgroundColor,
    this.navigationBarColor,
    this.isDark,
    required this.child,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.extendBody = false,
    this.resizeToAvoidBottomInset = true,
    this.safeAreaTop = true,
    this.safeAreaBottom = false,
    this.safeAreaLeft = true,
    this.safeAreaRight = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIsDark =
        isDark ?? (Theme.of(context).brightness == Brightness.dark);
    final overlayStyle = AppSystemUi.forPageBackground(
      bgColor: backgroundColor,
      isDark: effectiveIsDark,
      navigationBarColor: navigationBarColor ?? backgroundColor,
    );
    AppSystemUi.apply(overlayStyle);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: ColoredBox(
        color: backgroundColor,
        child: SafeArea(
          left: safeAreaLeft,
          top: safeAreaTop,
          right: safeAreaRight,
          bottom: safeAreaBottom,
          child: Scaffold(
            extendBody: extendBody,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            backgroundColor: Colors.transparent,
            body: child,
            bottomNavigationBar: bottomNavigationBar,
            bottomSheet: bottomSheet,
          ),
        ),
      ),
    );
  }
}

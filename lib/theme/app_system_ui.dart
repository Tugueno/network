import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  static SystemUiOverlayStyle forBackground(Color color) {
    final isLight =
        ThemeData.estimateBrightnessForColor(color) == Brightness.light;
    return SystemUiOverlayStyle(
      statusBarColor: color,
      statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
      statusBarBrightness: isLight ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: color,
      systemNavigationBarIconBrightness: isLight
          ? Brightness.dark
          : Brightness.light,
    );
  }

  static SystemUiOverlayStyle forScaffold({
    required Color statusBarColor,
    required Color navigationBarColor,
  }) {
    final statusBarIsLight =
        ThemeData.estimateBrightnessForColor(statusBarColor) ==
        Brightness.light;
    final navigationBarIsLight =
        ThemeData.estimateBrightnessForColor(navigationBarColor) ==
        Brightness.light;
    return SystemUiOverlayStyle(
      statusBarColor: statusBarColor,
      statusBarIconBrightness: statusBarIsLight
          ? Brightness.dark
          : Brightness.light,
      statusBarBrightness: statusBarIsLight
          ? Brightness.light
          : Brightness.dark,
      systemNavigationBarColor: navigationBarColor,
      systemNavigationBarIconBrightness: navigationBarIsLight
          ? Brightness.dark
          : Brightness.light,
    );
  }

  static SystemUiOverlayStyle forView({
    required Color topColor,
    Color? bottomColor,
  }) {
    return forScaffold(
      statusBarColor: topColor,
      navigationBarColor: bottomColor ?? topColor,
    );
  }

  static void apply(SystemUiOverlayStyle style) {
    SystemChrome.setSystemUIOverlayStyle(style);
  }

  static void applyForView({required Color topColor, Color? bottomColor}) {
    apply(forView(topColor: topColor, bottomColor: bottomColor));
  }
}

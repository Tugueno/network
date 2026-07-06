import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/theme/app_system_ui.dart';
import 'package:ncapp/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const _themeModeKey = 'theme_mode';

  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_themeModeKey);
    themeMode.value = savedMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(themeMode.value);
    _applySystemUiForTheme(themeMode.value);
  }

  Future<void> setDarkMode(bool enabled) async {
    final nextMode = enabled ? ThemeMode.dark : ThemeMode.light;
    if (themeMode.value == nextMode) return;

    themeMode.value = nextMode;
    Get.changeThemeMode(nextMode);
    _applySystemUiForTheme(nextMode);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, enabled ? 'dark' : 'light');
  }

  Future<void> toggleTheme() => setDarkMode(!isDarkMode);

  void _applySystemUiForTheme(ThemeMode mode) {
    final isDark = mode == ThemeMode.dark;
    final appColors = isDark ? AppTheme.darkColors : AppTheme.lightColors;
    AppSystemUi.apply(
      AppSystemUi.forPageBackground(
        bgColor: appColors.screenBackground,
        isDark: isDark,
      ),
    );
  }
}

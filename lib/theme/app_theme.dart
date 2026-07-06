import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_system_ui.dart';

@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color screenBackground;
  final Color cardBackground;
  final Color elevatedSurface;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color inputFill;
  final Color subtleFill;
  final Color sheetBackground;

  const AppThemeColors({
    required this.screenBackground,
    required this.cardBackground,
    required this.elevatedSurface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.inputFill,
    required this.subtleFill,
    required this.sheetBackground,
  });

  @override
  AppThemeColors copyWith({
    Color? screenBackground,
    Color? cardBackground,
    Color? elevatedSurface,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? inputFill,
    Color? subtleFill,
    Color? sheetBackground,
  }) {
    return AppThemeColors(
      screenBackground: screenBackground ?? this.screenBackground,
      cardBackground: cardBackground ?? this.cardBackground,
      elevatedSurface: elevatedSurface ?? this.elevatedSurface,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      inputFill: inputFill ?? this.inputFill,
      subtleFill: subtleFill ?? this.subtleFill,
      sheetBackground: sheetBackground ?? this.sheetBackground,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      screenBackground: Color.lerp(
        screenBackground,
        other.screenBackground,
        t,
      )!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      elevatedSurface: Color.lerp(elevatedSurface, other.elevatedSurface, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      subtleFill: Color.lerp(subtleFill, other.subtleFill, t)!,
      sheetBackground: Color.lerp(sheetBackground, other.sheetBackground, t)!,
    );
  }
}

class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF3D5AFE);
  static const Color primaryLight = Color(0xFF6B8AFF);
  static const Color error = Color(0xFFFF3B30);
  static const Color textDark = Color(0xFF000000);
  static const Color textGrey = Color(0xFF596981);
  static const Color borderColor = Color(0xFFE5E5EA);
  static const Color bgColor = Color(0xFFF6F6F6);
  static const Color screenBackground = Color(0xFFF5F6FC);
  static const Color outlineBtn = Color(0xFFE5E5EA);

  static const AppThemeColors lightColors = AppThemeColors(
    screenBackground: screenBackground,
    cardBackground: Colors.white,
    elevatedSurface: Colors.white,
    border: borderColor,
    textPrimary: textDark,
    textSecondary: textGrey,
    inputFill: Colors.white,
    subtleFill: bgColor,
    sheetBackground: Colors.white,
  );

  static const AppThemeColors darkColors = AppThemeColors(
    screenBackground: Color(0xFF0F1117),
    cardBackground: Color(0xFF171A22),
    elevatedSurface: Color(0xFF1E222C),
    border: Color(0xFF303644),
    textPrimary: Color(0xFFF4F6FB),
    textSecondary: Color(0xFFA8B0C2),
    inputFill: Color(0xFF171A22),
    subtleFill: Color(0xFF12151D),
    sheetBackground: Color(0xFF171A22),
  );

  static ThemeData get theme => lightTheme;
  static ThemeData get lightTheme =>
      _buildTheme(brightness: Brightness.light, appColors: lightColors);
  static ThemeData get darkTheme =>
      _buildTheme(brightness: Brightness.dark, appColors: darkColors);

  static AppThemeColors colors(BuildContext context) {
    return Theme.of(context).extension<AppThemeColors>()!;
  }

  static Color resolveColor(BuildContext context, Color color) {
    final appColors = colors(context);
    if (color == screenBackground) return appColors.screenBackground;
    if (color == bgColor) return appColors.subtleFill;
    if (color == Colors.white) return appColors.cardBackground;
    return color;
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required AppThemeColors appColors,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
      primary: primary,
      error: error,
      surface: appColors.cardBackground,
      onSurface: appColors.textPrimary,
      onSurfaceVariant: appColors.textSecondary,
      outline: appColors.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: GoogleFonts.inter().fontFamily,
      scaffoldBackgroundColor: appColors.screenBackground,
      colorScheme: scheme,
      extensions: [appColors],
      appBarTheme: AppBarTheme(
        backgroundColor: appColors.screenBackground,
        foregroundColor: appColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: AppSystemUi.forPageBackground(
          bgColor: appColors.screenBackground,
          isDark: brightness == Brightness.dark,
        ),
      ),
      cardTheme: CardThemeData(
        color: appColors.cardBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: DividerThemeData(color: appColors.border, thickness: 1),
      iconTheme: IconThemeData(color: appColors.textSecondary),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: appColors.inputFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: appColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: appColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
        hintStyle: TextStyle(color: appColors.textSecondary, fontSize: 14),
        labelStyle: TextStyle(
          color: appColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: appColors.textPrimary,
          side: BorderSide(color: appColors.border),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.white
              : appColors.textSecondary,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? primary
              : appColors.border,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Figma-тай яг таарсан өнгүүд
  static const Color primary = Color(0xFF3D5AFE); // Figma blue
  static const Color primaryLight = Color(0xFF6B8AFF);
  static const Color error = Color(0xFFFF3B30); // iOS red
  static const Color textDark = Color(0xFF000000); // Figma title
  static const Color textGrey = Color(0xFF596981);
  static const Color borderColor = Color(0xFFE5E5EA); // Figma border
  static const Color bgColor = Color(0xFFF2F2F7); // Figma card bg
  static const Color outlineBtn = Color(0xFFE5E5EA); // Алгасах border

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.inter().fontFamily,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      error: error,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor, width: 1),
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
      hintStyle: const TextStyle(color: textGrey, fontSize: 14),
      labelStyle: const TextStyle(
        color: textGrey,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 54),
        // Figma: button-д том radius — pill хэлбэр
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        elevation: 0,
      ),
    ),
  );
}
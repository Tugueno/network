import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Аппын текстийн загваруудын **нэг эх сурвалж** (typography).
///
/// `AppTheme.primary` гэж өнгийг нэрээр авдаг шигээ, текстийн загварыг
/// нэрээр авна: `style: AppTextStyles.title`.
///
/// Өнгө өөрчлөх бол: `AppTextStyles.body.copyWith(color: AppTheme.primary)`.
///
/// Хэмжээ/жинг энд **нэг газар** засвал апп даяар нэг зэрэг өөрчлөгдөнө.
class AppTextStyles {
  AppTextStyles._(); // instance үүсгэхээс сэргийлнэ

  // ── Гарчиг ──────────────────────────────────────────────
  /// Auth дэлгэцийн том толгой (26 / w700)
  static const headline = TextStyle(
      fontSize: 26, fontWeight: FontWeight.w700, color: AppTheme.textDark);

  /// Том дүн — нийт дүн зэрэг (22 / w700)
  static const largeTitle = TextStyle(
      fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.textDark);

  /// AppBar / sheet гарчиг (17 / w600)
  static const title = TextStyle(
      fontSize: 17, fontWeight: FontWeight.w600, color: AppTheme.textDark);

  /// Хэсгийн толгой (16 / w700)
  static const heading = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textDark);

  /// Дэд гарчиг (15 / w500)
  static const subtitle = TextStyle(
      fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.textDark);

  // ── Үндсэн текст (14) ──────────────────────────────────
  /// Энгийн үндсэн текст (14)
  static const body = TextStyle(fontSize: 14, color: AppTheme.textDark);

  /// Тод үндсэн текст (14 / w600)
  static const bodyBold = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textDark);

  /// Шошго (14 / w500)
  static const label = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textDark);

  /// Хүнд үндсэн текст — ID г.м (14 / w700)
  static const bodyHeavy = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textDark);

  /// Дүнгийн тод утга — нийт дүн (15 / w700)
  static const amount = TextStyle(
      fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textDark);

  /// Саарал үндсэн текст (14 / textGrey)
  static const bodyGrey = TextStyle(fontSize: 14, color: AppTheme.textGrey);

  // ── Туслах / жижиг ─────────────────────────────────────
  /// Тайлбар текст (13 / textGrey)
  static const caption = TextStyle(fontSize: 13, color: AppTheme.textGrey);
  static const bodyBoldGrey = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textGrey);

  /// Тод тайлбар — огноо г.м (13 / w600 / textGrey)
  static const captionBold = TextStyle(
      fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textGrey);

  /// Жижиг текст (12 / textGrey)
  static const small = TextStyle(fontSize: 12, color: AppTheme.textGrey);

  /// Хамгийн жижиг (11 / textGrey)
  static const tiny = TextStyle(fontSize: 11, color: AppTheme.textGrey);

  // ── Тусгай зориулалт ───────────────────────────────────
  /// Товчны текст (16 / w600). Өнгийг товч өөрөө тодорхойлно.
  static const button =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

  /// TextField-ийн hint (14 / textGrey)
  static const hint = TextStyle(fontSize: 14, color: AppTheme.textGrey);
}

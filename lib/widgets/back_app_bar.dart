import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import '../theme/app_system_ui.dart';

/// Дэлгэц бүрт давтагддаг "буцах сум + гарчиг" AppBar.
///
/// `PreferredSizeWidget`-ийг implement хийсэн тул `Scaffold.appBar`-т
/// шууд өгч болно:
///
/// ```dart
/// Scaffold(
///   appBar: const BackAppBar(title: 'Төлбөрийн хүсэлт'),
///   ...
/// )
/// ```
class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// AppBar-ийн гарчиг.
  final String title;

  /// Дэвсгэр өнгө. Ихэнх дэлгэц цайвар саарал (`0xFFF5F6FC`), зарим нь цагаан.
  final Color backgroundColor;

  final Color? statusBarColor;

  final SystemUiOverlayStyle? systemOverlayStyle;

  final double topPadding;

  final VoidCallback? onBack;

  const BackAppBar({
    super.key,
    required this.title,
    this.backgroundColor = AppTheme.screenBackground,
    this.statusBarColor,
    this.systemOverlayStyle,
    this.topPadding = 0,
    this.onBack,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + topPadding);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle ?? AppSystemUi.forBackground(backgroundColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (topPadding > 0)
            ColoredBox(
              color: statusBarColor ?? backgroundColor,
              child: SizedBox(height: topPadding, width: double.infinity),
            ),
          Material(
            color: backgroundColor,
            elevation: 0,
            child: SizedBox(
              height: kToolbarHeight,
              child: NavigationToolbar(
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                    color: AppTheme.textDark,
                  ),
                  onPressed: onBack ?? () => Get.back(),
                ),
                middle: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                centerMiddle: false,
                middleSpacing: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

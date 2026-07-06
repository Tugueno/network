import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';

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

  final VoidCallback? onBack;

  const BackAppBar({
    super.key,
    required this.title,
    this.backgroundColor = AppTheme.screenBackground,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    final effectiveBackground = AppTheme.resolveColor(context, backgroundColor);

    return Material(
      color: effectiveBackground,
      elevation: 0,
      child: SizedBox(
        height: kToolbarHeight,
        child: NavigationToolbar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: appColors.textPrimary,
            ),
            onPressed: onBack ?? () => Get.back(),
          ),
          middle: Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: appColors.textPrimary,
            ),
          ),
          centerMiddle: false,
          middleSpacing: 16,
        ),
      ),
    );
  }
}

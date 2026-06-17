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

  const BackAppBar({
    super.key,
    required this.title,
    this.backgroundColor = const Color(0xFFF5F6FC),
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios,
            size: 18, color: AppTheme.textDark),
        onPressed: () => Get.back(),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppTheme.textDark,
        ),
      ),
      centerTitle: false,
    );
  }
}

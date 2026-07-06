import 'package:flutter/material.dart';
import '../theme/app_system_ui.dart';
import '../theme/app_theme.dart';
import 'back_app_bar.dart';

/// Дэлгэц бүрт давтагддаг `Scaffold` + [BackAppBar] хослолыг нэг widget болгосон.
///
/// Зөвхөн өөрчлөгддөг зүйлээ (гарчиг + body) дамжуулна:
///
/// ```dart
/// AppScaffold(
///   title: 'Төлбөрийн хүсэлт',
///   body: Obx(() { ... }),
/// )
/// ```
class AppScaffold extends StatelessWidget {
  /// AppBar-ийн гарчиг.
  final String title;

  /// Үндсэн агуулга.
  final Widget body;

  /// Scaffold-ийн дэвсгэр өнгө.
  final Color backgroundColor;

  /// AppBar-ийн дэвсгэр өнгө (зарим дэлгэц цагаан AppBar-тай).
  final Color appBarColor;

  /// Доод тал дахь товч/панель (жишээ нь "Шалгах" товч). Сонголтоор.
  final Widget? bottomNavigationBar;

  /// body дээр хөвж харагдах доод панель (жишээ нь сонголт хийсэн үед гарч
  /// ирэх үйлдлийн мөр). [bottomNavigationBar]-аас ялгаатай. Сонголтоор.
  final Widget? bottomSheet;

  /// body-г доод панелийн доогуур үргэлжлүүлэх эсэх.
  final bool extendBody;

  /// BackAppBar-ийн буцах товчны override. null бол Get.back() дуудна.
  final VoidCallback? onBack;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.backgroundColor = AppTheme.screenBackground,
    this.appBarColor = AppTheme.screenBackground,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.extendBody = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackground = AppTheme.resolveColor(context, backgroundColor);
    final effectiveAppBarColor = AppTheme.resolveColor(context, appBarColor);

    return StatusAwarePage(
      backgroundColor: effectiveBackground,
      navigationBarColor: effectiveBackground,
      extendBody: extendBody,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      child: Column(
        children: [
          BackAppBar(
            title: title,
            backgroundColor: effectiveAppBarColor,
            onBack: onBack,
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}

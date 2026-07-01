import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  /// Status bar / top safe area-ийн өнгө. null бол [appBarColor]-ийг ашиглана.
  final Color? statusBarColor;

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
    this.statusBarColor,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.extendBody = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStatusBarColor = statusBarColor ?? appBarColor;
    final overlayStyle = AppSystemUi.forScaffold(
      statusBarColor: effectiveStatusBarColor,
      navigationBarColor: backgroundColor,
    );
    AppSystemUi.apply(overlayStyle);
    final topPadding = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: ColoredBox(
        color: backgroundColor,
        child: Scaffold(
          extendBody: extendBody,
          backgroundColor: backgroundColor,
          body: Column(
            children: [
              BackAppBar(
                title: title,
                backgroundColor: appBarColor,
                statusBarColor: effectiveStatusBarColor,
                systemOverlayStyle: overlayStyle,
                topPadding: topPadding,
                onBack: onBack,
              ),
              Expanded(child: body),
            ],
          ),
          bottomNavigationBar: bottomNavigationBar,
          bottomSheet: bottomSheet,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
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
    this.backgroundColor = const Color(0xFFF5F6FC),
    this.appBarColor = const Color(0xFFF5F6FC),
    this.bottomNavigationBar,
    this.bottomSheet,
    this.extendBody = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: extendBody,
      backgroundColor: backgroundColor,
      appBar: BackAppBar(title: title, backgroundColor: appBarColor, onBack: onBack),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
    );
  }
}

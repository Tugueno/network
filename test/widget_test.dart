import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ncapp/app/app_routes.dart';
import 'package:ncapp/features/payment_req/bindings/payment_req_binding.dart';
import 'package:ncapp/features/payment_req/controllers/payment_req_controller.dart';
import 'package:ncapp/features/payment_req/views/payment_req_detail_view.dart';
import 'package:ncapp/features/payment_req/views/payment_req_view.dart';
import 'package:ncapp/main.dart';
import 'package:ncapp/theme/app_theme.dart';

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(Get.reset);

  testWidgets('app opens the authentication flow', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Нэвтрэх'), findsWidgets);
  });

  testWidgets('back from payment detail returns to its list', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.theme,
        initialRoute: AppRoutes.paymentreq,
        getPages: [
          GetPage(
            name: AppRoutes.paymentreq,
            page: () => const PaymentReqView(),
            binding: PaymentReqBinding(),
          ),
          GetPage(
            name: AppRoutes.paymentreqDetail,
            page: () => const PaymentReqDetailView(),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    final controller = Get.find<PaymentReqController>();
    unawaited(controller.openDetail(controller.items.first, openInRoute: true));
    await tester.pumpAndSettle();
    expect(Get.currentRoute, AppRoutes.paymentreqDetail);

    Get.back();
    await tester.pumpAndSettle();

    expect(Get.currentRoute, AppRoutes.paymentreq);
    expect(find.text('Төлбөрийн хүсэлт'), findsOneWidget);
    expect(Get.isRegistered<PaymentReqController>(), isTrue);
    expect(Get.find<PaymentReqController>().selectedItem.value, isNull);
  });

  testWidgets('edge swipe does not pop payment detail', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      GetMaterialApp(
        popGesture: false,
        theme: AppTheme.theme,
        initialRoute: AppRoutes.paymentreq,
        getPages: [
          GetPage(
            name: AppRoutes.paymentreq,
            page: () => const PaymentReqView(),
            binding: PaymentReqBinding(),
            popGesture: false,
          ),
          GetPage(
            name: AppRoutes.paymentreqDetail,
            page: () => const PaymentReqDetailView(),
            transition: Transition.rightToLeft,
            popGesture: false,
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    final controller = Get.find<PaymentReqController>();
    unawaited(controller.openDetail(controller.items.first, openInRoute: true));
    await tester.pumpAndSettle();
    expect(Get.currentRoute, AppRoutes.paymentreqDetail);

    await tester.dragFrom(
      const Offset(1, 400),
      const Offset(360, 0),
      touchSlopY: 0,
    );
    await tester.pumpAndSettle();

    expect(Get.currentRoute, AppRoutes.paymentreqDetail);
  });
}

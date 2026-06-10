import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/bindings/home_binding.dart';
import 'package:ncapp/bindings/requests_binding.dart';
import 'package:ncapp/bindings/payment_req_binding.dart';
import 'package:ncapp/views/requests/requests_view.dart';
import 'package:ncapp/views/payment_req/payment_req_view.dart';
import 'package:ncapp/views/payment_req/payment_req_detail_view.dart';
import 'theme/app_theme.dart';
import 'app/app_routes.dart';
import 'bindings/auth_binding.dart';
import 'views/auth/auth_view.dart';
import 'views/auth/biometric_view.dart';
import 'views/home/home_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NetWork',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: AppRoutes.auth,
      getPages: [
        GetPage(
          name: AppRoutes.auth,
          page: () => const AuthView(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: AppRoutes.biometric,
          page: () => const BiometricView(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: AppRoutes.home,
          page: () => const HomeView(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: AppRoutes.requests,
          page: () => const RequestsView(),
          binding: RequestsBinding(),
        ),
        GetPage(
          name: AppRoutes.paymentreq,
          page: () => const PaymentReqView(),
          binding: PaymentReqBinding(),
        ),
        GetPage(
          name: AppRoutes.paymentreqDetail,
          page: () => const PaymentReqDetailView(),
          binding: PaymentReqBinding(),
        ),
      ],
    );
  }
}
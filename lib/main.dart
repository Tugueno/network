import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ncapp/app/app_shell.dart';
import 'package:ncapp/app/main_tab_shell.dart';
import 'package:ncapp/bindings/main_tab_binding.dart';
import 'package:ncapp/bindings/shell_binding.dart';
import 'package:ncapp/features/payment_req/bindings/payment_req_binding.dart';
import 'package:ncapp/features/payment_req/views/payment_req_detail_view.dart';
import 'package:ncapp/features/advance_req/advance_req_binding.dart';
import 'package:ncapp/features/advance_req/views/advance_req_detail_view.dart';
import 'package:ncapp/theme/app_system_ui.dart';
import 'package:ncapp/widgets/main_tab_navigation_bar.dart';
import 'theme/app_theme.dart';
import 'app/app_routes.dart';
import 'bindings/auth_binding.dart';
import 'views/auth/auth_view.dart';
import 'views/auth/biometric_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(AppSystemUi.light);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NetWork',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      popGesture: false,
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
          page: () => const MainTabShell(initialTab: MainTab.home),
          binding: MainTabBinding(),
          popGesture: false,
        ),
        GetPage(
          name: AppRoutes.shell,
          page: () => const AppShell(),
          binding: ShellBinding(),
          popGesture: false,
        ),
        GetPage(
          name: AppRoutes.requests,
          page: () => const MainTabShell(initialTab: MainTab.requests),
          binding: MainTabBinding(),
          popGesture: false,
        ),
        GetPage(
          name: AppRoutes.paymentreq,
          page: () => const MainTabShell(initialTab: MainTab.paymentReq),
          binding: MainTabBinding(),
          popGesture: false,
        ),
        GetPage(
          name: AppRoutes.paymentreqDetail,
          page: () => const PaymentReqDetailView(),
          binding: PaymentReqBinding(),
          transition: Transition.rightToLeft,
          popGesture: false,
          preventDuplicates: true,
        ),
        GetPage(
          name: AppRoutes.advancereq,
          page: () => const MainTabShell(initialTab: MainTab.advanceReq),
          binding: MainTabBinding(),
          popGesture: false,
        ),
        GetPage(
          name: AppRoutes.advancereqDetail,
          page: () => const AdvanceReqDetailView(),
          binding: AdvanceReqBinding(),
          transition: Transition.rightToLeft,
          popGesture: false,
          preventDuplicates: true,
        ),
      ],
    );
  }
}

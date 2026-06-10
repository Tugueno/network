import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/app/app_routes.dart';
import '../../controllers/home_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/network_logo.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Center(child: NetworkLogo()),
              const SizedBox(height: 32),

              // Obx — зөвхөн .obs утга ашиглах хэсгийг л ороох
              Obx(
                () => Text(
                  'Сайн байна уу, ${controller.userName.value}!',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
              ),

              const Spacer(),

              ElevatedButton(
                onPressed: () => Get.toNamed(AppRoutes.requests),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Ирцийн хүсэлт'),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () => Get.toNamed(AppRoutes.paymentreq),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Төлбөрийн хүсэлт'),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: controller.logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.error,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Гарах'),
              ),
              const SizedBox(height: 16), 
              
            ],
          ),
        ),
      ),
    );
  }
}
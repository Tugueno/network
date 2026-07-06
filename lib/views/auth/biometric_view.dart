import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../theme/app_system_ui.dart';
import '../../theme/app_theme.dart';
import '../../widgets/network_logo.dart';
import '../../widgets/face_id_icon.dart';

class BiometricView extends GetView<AuthController> {
  const BiometricView({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);

    return StatusAwarePage(
      backgroundColor: appColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 48),
            const Center(child: NetworkLogo()),
            const Spacer(),

            // Face ID icon — дугуй саарал дэвсгэртэй
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: appColors.subtleFill,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: FaceIdIcon(size: 44, color: AppTheme.primary),
              ),
            ),
            const SizedBox(height: 32),

            Text(
              'Та цаашид нэвтрэхдээ\nFace ID ашиглах уу?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: appColors.textPrimary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),

            Text(
              'Тохиргоог идэвхжүүлснээр илүү хурдан\nнэвтрэх боломжтой.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: appColors.textSecondary,
                height: 1.6,
              ),
            ),

            const Spacer(),

            // Зөвшөөрөх
            ElevatedButton(
              onPressed: controller.acceptBiometric,
              child: const Text('Зөвшөөрөх'),
            ),
            const SizedBox(height: 12),

            // Алгасах
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton(
                onPressed: controller.skipBiometric,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: appColors.border, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  foregroundColor: appColors.textPrimary,
                ),
                child: const Text(
                  'Алгасах',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/app/app_routes.dart';
import 'package:ncapp/core/responsive/app_breakpoints.dart';
import 'package:ncapp/core/widgets/adaptive_modal.dart';
import 'package:ncapp/core/widgets/empty_state.dart';
import 'package:ncapp/features/payment_req/controllers/payment_req_controller.dart';
import 'package:ncapp/features/payment_req/models/payment_req_model.dart';
import 'package:ncapp/features/payment_req/widgets/payment_req_detail_layout.dart';
import 'package:ncapp/theme/app_theme.dart';
import 'package:ncapp/widgets/app_scaffold.dart';
import 'payment_req_confirm_sheet.dart';

void _showConfirmSheet(
  BuildContext context,
  PaymentReqModel item, {
  required bool isApprove,
}) {
  showAdaptiveModal(
    context: context,
    maxWidth: 460,
    builder: (_) => PaymentReqConfirmSheet(item: item, isApprove: isApprove),
  );
}

class PaymentReqDetailView extends GetView<PaymentReqController> {
  const PaymentReqDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final item = controller.selectedItem.value;
      if (item == null) {
        return AppScaffold(
          title: 'Төлбөрийн хүсэлт',
          onBack: () => Get.offNamed(AppRoutes.paymentreq),
          body: EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'Хүсэлт сонгогдоогүй байна',
            subtitle: 'Жагсаалт руу буцаад төлбөрийн хүсэлтээ сонгоно уу.',
            actionLabel: 'Жагсаалт руу буцах',
            onAction: () => Get.offNamed(AppRoutes.paymentreq),
          ),
        );
      }
      final isWebLayout = AppBreakpoints.isDesktop(
        MediaQuery.sizeOf(context).width,
      );
      final actionArea = PaymentReqDetailActionArea(
        onReject: () => _showConfirmSheet(context, item, isApprove: false),
        onApprove: () => _showConfirmSheet(context, item, isApprove: true),
        compact: isWebLayout,
      );

      return AppScaffold(
        extendBody: true,
        title: item.id,
        backgroundColor: AppTheme.screenBackground,
        appBarColor: Colors.white,
        statusBarColor: AppTheme.screenBackground,
        onBack: () => controller.closeDetail(popRoute: true),
        body: isWebLayout
            ? Stack(
                fit: StackFit.expand,
                children: [
                  PaymentReqDetailLayout(item: item),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 0,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: actionArea,
                      ),
                    ),
                  ),
                ],
              )
            : PaymentReqDetailLayout(item: item),
        bottomNavigationBar: isWebLayout ? null : actionArea,
      );
    });
  }
}

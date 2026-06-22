import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/core/widgets/adaptive_modal.dart';
import 'package:ncapp/features/payment_req/controllers/payment_req_controller.dart';
import 'package:ncapp/features/payment_req/models/payment_req_model.dart';
import 'package:ncapp/features/payment_req/widgets/payment_req_detail_layout.dart';
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
      if (item == null) return const SizedBox.shrink();

      return AppScaffold(
        extendBody: true,
        title: item.id,
        onBack: () => controller.closeDetail(popRoute: true),
        body: PaymentReqDetailLayout(item: item),
        bottomNavigationBar: PaymentReqDetailActionArea(
          onReject: () => _showConfirmSheet(context, item, isApprove: false),
          onApprove: () => _showConfirmSheet(context, item, isApprove: true),
        ),
      );
    });
  }
}

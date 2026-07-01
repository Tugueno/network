import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/app/app_routes.dart';
import 'package:ncapp/core/widgets/empty_state.dart';
import 'package:ncapp/features/advance_req/advance_req_controller.dart';
import 'package:ncapp/features/advance_req/advance_req_model.dart';
import 'package:ncapp/features/advance_req/widgets/advance_req_attachment_sheet.dart';
import 'package:ncapp/features/advance_req/widgets/advance_req_detail_summary.dart';
import 'package:ncapp/features/advance_req/widgets/advance_req_document_form_card.dart';
import 'package:ncapp/widgets/app_scaffold.dart';

class AdvanceReqDetailView extends GetView<AdvanceReqController> {
  const AdvanceReqDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final item = controller.selectedItem.value;
      if (item == null) {
        return AppScaffold(
          title: 'Урдчилгаа хаах',
          onBack: () => Get.offNamed(AppRoutes.advancereq),
          body: EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'Хүсэлт сонгогдоогүй байна',
            subtitle: 'Жагсаалт руу буцаад урьдчилгааны хүсэлтээ сонгоно уу.',
            actionLabel: 'Жагсаалт руу буцах',
            onAction: () => Get.offNamed(AppRoutes.advancereq),
          ),
        );
      }
      return _DetailBody(item: item);
    });
  }
}

class _DetailBody extends StatefulWidget {
  final AdvanceReqModel item;
  const _DetailBody({required this.item});

  @override
  State<_DetailBody> createState() => _DetailBodyState();
}

class _DetailBodyState extends State<_DetailBody> {
  bool _isSubmitted = false;
  int _extraAttachmentCount = 0;
  bool _showToast = false;

  int get _totalCount => widget.item.attachmentCount + _extraAttachmentCount;

  void _submit() {
    setState(() {
      _isSubmitted = true;
      _extraAttachmentCount++;
      _showToast = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showToast = false);
    });
  }

  void _openAttachments() {
    if (_totalCount == 0) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AdvanceReqAttachmentSheet(count: _totalCount),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: widget.item.id,
      onBack: () =>
          Get.find<AdvanceReqController>().closeDetail(popRoute: true),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            children: [
              AdvanceReqInfoCard(item: widget.item),
              const SizedBox(height: 12),
              AdvanceReqAttachmentHeader(
                count: _totalCount,
                hasNew: _extraAttachmentCount > 0,
                onTap: _openAttachments,
              ),
              const SizedBox(height: 12),
              AdvanceReqDocumentFormCard(isSubmitted: _isSubmitted),
            ],
          ),
          if (_showToast)
            const Positioned(
              top: 12,
              left: 24,
              right: 24,
              child: AdvanceReqSuccessToast(),
            ),
        ],
      ),
      bottomNavigationBar: AdvanceReqSubmitBar(
        isSubmitted: _isSubmitted,
        onSubmit: _submit,
      ),
    );
  }
}

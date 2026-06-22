import 'package:flutter/material.dart';
import 'package:ncapp/core/widgets/adaptive_modal.dart';
import 'package:ncapp/features/payment_req/models/payment_req_model.dart';
import 'package:ncapp/features/payment_req/views/payment_req_attachment_sheet.dart';
import 'package:ncapp/features/payment_req/widgets/payment_req_approval_flow.dart';
import 'package:ncapp/features/payment_req/widgets/payment_req_attachment_description_card.dart';
import 'package:ncapp/features/payment_req/widgets/payment_req_detail_header.dart';
import 'package:ncapp/widgets/action_buttons.dart';

const double _webPanelGap = 16;

class PaymentReqDetailLayout extends StatelessWidget {
  final PaymentReqModel item;

  const PaymentReqDetailLayout({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < kAdaptiveModalBreakpoint) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              _PrimaryDetailContent(item: item, includeApprovalFlow: true),
            ],
          );
        }

        return _WebPaymentReqDetailLayout(item: item);
      },
    );
  }
}

class _WebPaymentReqDetailLayout extends StatefulWidget {
  final PaymentReqModel item;

  const _WebPaymentReqDetailLayout({required this.item});

  @override
  State<_WebPaymentReqDetailLayout> createState() =>
      _WebPaymentReqDetailLayoutState();
}

class _WebPaymentReqDetailLayoutState
    extends State<_WebPaymentReqDetailLayout> {
  double _primaryHeight = 0;

  void _updatePrimaryHeight(Size size) {
    if ((size.height - _primaryHeight).abs() < 0.5) return;
    setState(() => _primaryHeight = size.height);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 0, 16, 120),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: _MeasureSize(
              onChange: _updatePrimaryHeight,
              child: _PrimaryDetailContent(item: widget.item, bottomPadding: 0),
            ),
          ),
          const SizedBox(width: _webPanelGap),
          Expanded(
            flex: 4,
            child: PaymentReqApprovalFlow(
              steps: widget.item.approvalSteps,
              minHeight: _primaryHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _MeasureSize extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onChange;

  const _MeasureSize({required this.child, required this.onChange});

  @override
  State<_MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<_MeasureSize> {
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
    return widget.child;
  }

  void _notifySize() {
    if (!mounted) return;

    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;

    final newSize = renderObject.size;
    if (_oldSize == newSize) return;

    _oldSize = newSize;
    widget.onChange(newSize);
  }
}

class _PrimaryDetailContent extends StatelessWidget {
  final PaymentReqModel item;
  final bool includeApprovalFlow;
  final double bottomPadding;

  const _PrimaryDetailContent({
    required this.item,
    this.includeApprovalFlow = false,
    this.bottomPadding = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PaymentReqDetailHeader(item: item),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding),
          child: Column(
            children: [
              PaymentReqAttachmentDescriptionCard(
                count: item.attachmentCount,
                description: item.description,
                onAttachmentTap: () => showAdaptiveModal(
                  context: context,
                  maxWidth: 560,
                  builder: (_) =>
                      PaymentReqAttachmentSheet(groups: item.attachmentGroups),
                ),
              ),
              if (includeApprovalFlow) ...[
                const SizedBox(height: 12),
                PaymentReqApprovalFlow(steps: item.approvalSteps),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class PaymentReqDetailActionArea extends StatelessWidget {
  final VoidCallback onReject;
  final VoidCallback onApprove;
  final bool isLoading;

  const PaymentReqDetailActionArea({
    super.key,
    required this.onReject,
    required this.onApprove,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < kAdaptiveModalBreakpoint) {
          return ActionButtons(
            onReject: onReject,
            onApprove: onApprove,
            isLoading: isLoading,
          );
        }

        return SizedBox(
          width: double.infinity,
          child: ActionButtons(
            onReject: onReject,
            onApprove: onApprove,
            isLoading: isLoading,
          ),
        );
      },
    );
  }
}

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:ncapp/core/widgets/adaptive_modal.dart';
import 'package:ncapp/features/payment_req/models/payment_req_model.dart';
import 'package:ncapp/features/payment_req/views/payment_req_attachment_sheet.dart';
import 'package:ncapp/features/payment_req/widgets/payment_req_approval_flow.dart';
import 'package:ncapp/features/payment_req/widgets/payment_req_attachment_description_card.dart';
import 'package:ncapp/features/payment_req/widgets/payment_req_detail_header.dart';
import 'package:ncapp/widgets/action_buttons.dart';

const double _webPanelGap = 16;

/// Fraction of the Row's total width occupied by the primary detail
/// column (`flex: 5` out of `5 + 4`). Used to size the sticky action bar
/// so it never spans wider than the detail panel it belongs to.
const double _primaryPaneFlexFraction = 5 / 9;

/// Fallback bottom padding reserved under the scrollable content before
/// the sticky action bar's real height has been measured for the first
/// time.
const double _defaultActionAreaReservedHeight = 96;

class PaymentReqDetailLayout extends StatelessWidget {
  final PaymentReqModel item;
  final VoidCallback onReject;
  final VoidCallback onApprove;
  final bool isLoading;

  const PaymentReqDetailLayout({
    super.key,
    required this.item,
    required this.onReject,
    required this.onApprove,
    this.isLoading = false,
  });

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

        return _WebPaymentReqDetailLayout(
          item: item,
          onReject: onReject,
          onApprove: onApprove,
          isLoading: isLoading,
        );
      },
    );
  }
}

/// Desktop/web detail layout: a two-column `Row` (primary content + the
/// approval flow) with a sticky action bar layered on top via `Stack`.
///
/// The action bar is `Positioned` with an explicit `width` equal to the
/// primary column's own width (never `double.infinity`, never the full
/// window width), so it stays scoped to the detail panel and can't bleed
/// into the approval-flow column or any master list pane the caller might
/// render alongside this widget.
class _WebPaymentReqDetailLayout extends StatefulWidget {
  final PaymentReqModel item;
  final VoidCallback onReject;
  final VoidCallback onApprove;
  final bool isLoading;

  const _WebPaymentReqDetailLayout({
    required this.item,
    required this.onReject,
    required this.onApprove,
    required this.isLoading,
  });

  @override
  State<_WebPaymentReqDetailLayout> createState() =>
      _WebPaymentReqDetailLayoutState();
}

class _WebPaymentReqDetailLayoutState
    extends State<_WebPaymentReqDetailLayout> {
  double _primaryHeight = 0;
  double _actionAreaHeight = _defaultActionAreaReservedHeight;

  void _updatePrimaryHeight(Size size) {
    if ((size.height - _primaryHeight).abs() < 0.5) return;
    setState(() => _primaryHeight = size.height);
  }

  void _updateActionAreaHeight(Size size) {
    if ((size.height - _actionAreaHeight).abs() < 0.5) return;
    setState(() => _actionAreaHeight = size.height);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final primaryPaneWidth =
            (constraints.maxWidth - _webPanelGap) * _primaryPaneFlexFraction;

        return Stack(
          children: [
            SingleChildScrollView(
              // Reserve space for the measured height of the sticky action
              // bar (plus a little breathing room) so content is never cut
              // off or obscured when scrolled all the way down.
              padding: EdgeInsets.fromLTRB(
                0,
                0,
                16,
                _actionAreaHeight + 24,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: _MeasureSize(
                      onChange: _updatePrimaryHeight,
                      child: _PrimaryDetailContent(
                        item: widget.item,
                        bottomPadding: 0,
                      ),
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
            ),
            Positioned(
              left: 0,
              bottom: 0,
              width: primaryPaneWidth,
              child: _MeasureSize(
                onChange: _updateActionAreaHeight,
                child: PaymentReqDetailActionArea(
                  onReject: widget.onReject,
                  onApprove: widget.onApprove,
                  isLoading: widget.isLoading,
                ),
              ),
            ),
          ],
        );
      },
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
          padding: EdgeInsets.fromLTRB(
            16,
            12,
            16,
            includeApprovalFlow ? 0 : bottomPadding,
          ),
          child: PaymentReqAttachmentDescriptionCard(
            count: item.attachmentCount,
            description: item.description,
            onAttachmentTap: () => showAdaptiveModal(
              context: context,
              maxWidth: 560,
              builder: (_) =>
                  PaymentReqAttachmentSheet(groups: item.attachmentGroups),
            ),
          ),
        ),
        if (includeApprovalFlow) ...[
          const SizedBox(height: 12),
          PaymentReqApprovalFlow(steps: item.approvalSteps),
          SizedBox(height: bottomPadding),
        ],
      ],
    );
  }
}

/// Renders the Буцаах/Батлах action buttons.
///
/// - [compact]: always renders bare `ActionButtons` with no extra sizing,
///   background, or safe-area handling — for callers that already fully
///   own the surrounding layout (e.g. a bottom sheet).
/// - Non-compact (default): decides between a plain inline row (narrow
///   layouts) and a sticky-looking footer bar (wide layouts) based on
///   *its own* incoming constraints. Callers control the actual width by
///   constraining the parent they place this in — e.g. the detail panel
///   in `_WebPaymentReqDetailLayout` wraps it in a `Positioned` sized to
///   the primary column's width. This widget never forces
///   `width: double.infinity`, so it can never grow past whatever
///   container the caller has already scoped it to.
class PaymentReqDetailActionArea extends StatelessWidget {
  final VoidCallback onReject;
  final VoidCallback onApprove;
  final bool isLoading;
  final bool compact;

  const PaymentReqDetailActionArea({
    super.key,
    required this.onReject,
    required this.onApprove,
    this.isLoading = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttons = ActionButtons(
      onReject: onReject,
      onApprove: onApprove,
      isLoading: isLoading,
    );

    if (compact) {
      return buttons;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < kAdaptiveModalBreakpoint) {
          return buttons;
        }

        final footer = Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: buttons,
        );

        // Native iOS reserves extra bottom inset for the home indicator.
        // Web has no such inset, so skip the SafeArea wrapper there —
        // otherwise the bar picks up phantom empty space under the
        // buttons that has no native affordance behind it on web.
        if (kIsWeb) {
          return footer;
        }

        return SafeArea(top: false, child: footer);
      },
    );
  }
}
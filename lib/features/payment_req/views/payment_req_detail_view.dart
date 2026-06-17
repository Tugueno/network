import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ncapp/features/payment_req/payment_req_controller.dart';
import 'package:ncapp/features/payment_req/payment_req_model.dart';
import 'package:ncapp/features/payment_req/payment_req_status_ui.dart';
import 'package:ncapp/theme/app_theme.dart';
import 'package:ncapp/widgets/app_scaffold.dart';
import 'package:ncapp/widgets/action_buttons.dart';
import 'package:ncapp/widgets/department_tag.dart';
import 'package:ncapp/widgets/info_row.dart';
import 'package:ncapp/widgets/user_avatar.dart';
import 'payment_req_full_detail_sheet.dart';
import 'payment_req_approval_history_sheet.dart';
import 'payment_req_attachment_sheet.dart';
import 'payment_req_confirm_sheet.dart';
import 'package:ncapp/core/widgets/app_card.dart';

void _showFullDetailSheet(BuildContext context, PaymentReqModel item) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => PaymentReqFullDetailSheet(item: item),
  );
}

void _showApprovalHistorySheet(
    BuildContext context, List<ApprovalStepModel> steps) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => PaymentReqApprovalHistorySheet(steps: steps),
  );
}

void _showConfirmSheet(BuildContext context, PaymentReqModel item,
    {required bool isApprove}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
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
        appBarColor: Colors.white,
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            _DetailHeader(item: item),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
              child: Column(
                children: [
                  _AttachmentDescriptionCard(
                    count: item.attachmentCount,
                    description: item.description,
                    onAttachmentTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => PaymentReqAttachmentSheet(
                          groups: item.attachmentGroups),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ApprovalFlow(steps: item.approvalSteps),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: ActionButtons(
          onReject: () => _showConfirmSheet(context, item, isApprove: false),
          onApprove: () => _showConfirmSheet(context, item, isApprove: true),
        ),
      );
    });
  }
}

// ── Status badge ───────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final PaymentReqStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(status.icon, size: 16, color: status.color),
        const SizedBox(width: 4),
        Text(
          status.label,
          style: TextStyle(
            fontSize: 14,
            color: status.color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ── Detail header card ─────────────────────────────────────
class _DetailHeader extends StatelessWidget {
  final PaymentReqModel item;
  const _DetailHeader({required this.item});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DepartmentTag(label: item.department),
          const SizedBox(height: 8),
          Text(
            item.formattedAmount,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Нийт төсөвлөсөн',
            style: TextStyle(fontSize: 14, color: AppTheme.textGrey),
          ),
          const SizedBox(height: 8),
          _StatusBadge(status: item.status),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(name: item.assignee, avatarUrl: item.avatarUrl),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.assignee,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                    if (item.assigneeLore.isNotEmpty) ...[
                      const SizedBox(height: 1),
                      Text(
                        item.assigneeLore,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textDark),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (item.assigneeRole.isNotEmpty) ...[
                      const SizedBox(height: 1),
                      Text(
                        item.assigneeRole,
                        style: const TextStyle(
                            fontSize: 13, color: AppTheme.textGrey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          InfoRow(label: 'Үүсгэсэн огноо:', value: item.date, showDivider: false, valueWeight: FontWeight.w600),
          InfoRow(label: 'Төлбөр хийгдэх огноо:', value: item.paymentDate, showDivider: false, valueWeight: FontWeight.w600),
          InfoRow(label: 'Компани:', value: item.company, showDivider: false, valueWeight: FontWeight.w600),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () => _showFullDetailSheet(context, item),
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFF0F0F0),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                foregroundColor: AppTheme.textDark,
              ),
              child: const Text('Дэлгэрэнгүй харах'),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Attachment + Description card ─────────────────────────
class _AttachmentDescriptionCard extends StatelessWidget {
  final int count;
  final String description;
  final VoidCallback? onAttachmentTap;
  const _AttachmentDescriptionCard(
      {required this.count, required this.description, this.onAttachmentTap});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: double.infinity,
      radius: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Attachment row
          GestureDetector(
            onTap: onAttachmentTap,
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
            height: 52,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.attach_file,
                      size: 20, color: AppTheme.textGrey),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Хавсаргасан',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textDark),
                    ),
                  ),
                  if (count > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right,
                      size: 18, color: AppTheme.textGrey),
                ],
              ),
            ),
            ),
          ),
          const Divider(height: 4, thickness: 4, color: Color(0xFFF5F6FC),endIndent: 0,indent: 0,),
          // Description section
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 20, color: AppTheme.textGrey),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Тайлбар',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.bgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    description,
                    style: const TextStyle(
                        fontSize: 14, color: AppTheme.textDark),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Approval flow timeline ─────────────────────────────────
class _ApprovalFlow extends StatelessWidget {
  final List<ApprovalStepModel> steps;
  const _ApprovalFlow({required this.steps});

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) return const SizedBox.shrink();

    return AppCard(
      padding: const EdgeInsets.all(16),
      radius: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Батлах урсгал',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),
              GestureDetector(
                onTap: () => _showApprovalHistorySheet(context, steps),
                child: const Text(
                  'Дэлгэрэнгүй харах',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(
            steps.length,
            (i) => _StepRow(
              step: steps[i],
              isLast: i == steps.length - 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final ApprovalStepModel step;
  final bool isLast;
  const _StepRow({required this.step, required this.isLast});

  Color get _dotColor {
    switch (step.status) {
      case ApprovalStepStatus.done:
        return const Color(0xFF34C759);
      case ApprovalStepStatus.active:
        return AppTheme.primary;
      case ApprovalStepStatus.pending:
        return const Color(0xFFB0B8C1);
    }
  }

  Color get _dotRingColor {
    switch (step.status) {
      case ApprovalStepStatus.done:
        return const Color(0xFF34C759).withValues(alpha: 0.2);
      case ApprovalStepStatus.active:
        return AppTheme.primary.withValues(alpha: 0.2);
      case ApprovalStepStatus.pending:
        return const Color(0xFFB0B8C1).withValues(alpha: 0.25);
    }
  }

  Color get _lineColor {
    switch (step.status) {
      case ApprovalStepStatus.done:
        return const Color(0xFF34C759).withValues(alpha: 0.35);
      case ApprovalStepStatus.active:
      case ApprovalStepStatus.pending:
        return const Color(0xFFB0B8C1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 17,
                  height: 17,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: _dotRingColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2, bottom: 19),
                      child: step.status == ApprovalStepStatus.pending
                          ? CustomPaint(
                              painter: _DashedLinePainter(color: _lineColor),
                            )
                          : Container(width: 1.5, color: _lineColor),
                    ),
                  ),
                if (isLast && step.status == ApprovalStepStatus.pending)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      margin: const EdgeInsets.only(top: 2),
                      color: _lineColor,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                  Text(
                    step.person,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13, color: AppTheme.textGrey),
                  ),
                  if (step.comment != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.bgColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE5E5EA)),
                      ),
                      child: Text(
                        '"${step.comment}"',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF555555)),
                      ),
                    ),
                  ],
                  if (step.date.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      step.date,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12, color: AppTheme.textDark),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5;
    const dashHeight = 4.0;
    const dashSpace = 4.0;
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(size.width / 2, y + dashHeight),
        paint,
      );
      y += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => old.color != color;
}

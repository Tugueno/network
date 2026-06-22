import 'package:flutter/material.dart';
import 'package:ncapp/core/widgets/adaptive_modal.dart';
import 'package:ncapp/core/widgets/app_card.dart';
import 'package:ncapp/features/payment_req/models/payment_req_model.dart';
import 'package:ncapp/features/payment_req/views/payment_req_approval_history_sheet.dart';
import 'package:ncapp/theme/app_theme.dart';

void _showApprovalHistorySheet(
  BuildContext context,
  List<ApprovalStepModel> steps,
) {
  showAdaptiveModal(
    context: context,
    maxWidth: 520,
    builder: (_) => PaymentReqApprovalHistorySheet(steps: steps),
  );
}

class PaymentReqApprovalFlow extends StatelessWidget {
  final List<ApprovalStepModel> steps;
  final double minHeight;

  const PaymentReqApprovalFlow({
    super.key,
    required this.steps,
    this.minHeight = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) return const SizedBox.shrink();

    final card = AppCard(
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(
            steps.length,
            (i) => _StepRow(step: steps[i], isLast: i == steps.length - 1),
          ),
        ],
      ),
    );

    if (minHeight <= 0) return card;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: card,
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
                      fontSize: 13,
                      color: AppTheme.textGrey,
                    ),
                  ),
                  if (step.comment != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.bgColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE5E5EA)),
                      ),
                      child: Text(
                        '"${step.comment}"',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ),
                  ],
                  if (step.date.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      step.date,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: AppTheme.textDark,
                      ),
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

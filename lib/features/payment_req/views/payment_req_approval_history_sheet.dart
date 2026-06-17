import 'package:flutter/material.dart';
import 'package:ncapp/core/widgets/bottom_sheet_container.dart';
import 'package:ncapp/features/payment_req/models/payment_req_model.dart';
import 'package:ncapp/theme/app_theme.dart';

class PaymentReqApprovalHistorySheet extends StatelessWidget {
  final List<ApprovalStepModel> steps;
  const PaymentReqApprovalHistorySheet({super.key, required this.steps});

  static const _avatarColors = [
    Color(0xFF7C3AED),
    Color(0xFF059669),
    Color(0xFF2563EB),
    Color(0xFFDC2626),
    Color(0xFFD97706),
  ];

  Color _colorForIndex(int i) => _avatarColors[i % _avatarColors.length];

  @override
  Widget build(BuildContext context) {
    final doneSteps = steps
        .asMap()
        .entries
        .where((e) => e.value.status != ApprovalStepStatus.pending)
        .toList();

    return BottomSheetContainer(
      maxHeightFactor: 0.85,
      children: [
          const SizedBox(height: 16),
          const Text(
            'Дэлгэрэнгүй мэдээлэл',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
          const Divider(height: 20),
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              shrinkWrap: true,
              itemCount: doneSteps.length,
              itemBuilder: (_, i) => _HistoryItem(
                step: doneSteps[i].value,
                avatarColor: _colorForIndex(doneSteps[i].key),
              ),
            ),
          ),
        ],
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final ApprovalStepModel step;
  final Color avatarColor;
  const _HistoryItem({required this.step, required this.avatarColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: avatarColor.withValues(alpha: 0.15),
                child: Text(
                  step.person.isNotEmpty ? step.person[0] : '?',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: avatarColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.person,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                    if (step.date.isNotEmpty)
                      Text(
                        step.date,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textGrey,
                        ),
                      ),
                  ],
                ),
              ),
              _ArrowIcon(isReturned: step.isReturned),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textDark,
                  ),
                ),
                if (step.comment != null && step.comment!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '"${step.comment}"',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF555555)),
                  ),
                ],
                if (step.message != null && step.message!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    step.message!,
                    style: const TextStyle(
                        fontSize: 13, color: AppTheme.textGrey),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArrowIcon extends StatelessWidget {
  final bool isReturned;
  const _ArrowIcon({required this.isReturned});

  @override
  Widget build(BuildContext context) {
    return Icon(
      isReturned
          ? Icons.arrow_circle_left_rounded
          : Icons.arrow_circle_right_rounded,
      size: 26,
      color: isReturned ? const Color(0xFFFF9500) : const Color(0xFF34C759),
    );
  }
}


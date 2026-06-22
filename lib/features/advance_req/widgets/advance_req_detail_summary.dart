import 'package:flutter/material.dart';
import 'package:ncapp/core/utils/format.dart';
import 'package:ncapp/core/widgets/app_card.dart';
import 'package:ncapp/features/advance_req/advance_req_model.dart';
import 'package:ncapp/theme/app_theme.dart';

class AdvanceReqInfoCard extends StatelessWidget {
  final AdvanceReqModel item;
  const AdvanceReqInfoCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF9500),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Үлдэгдэл:',
                  style: TextStyle(fontSize: 14, color: AppTheme.textDark),
                ),
                const Spacer(),
                Text(
                  formatTugrik(item.remainingAmount),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                const Text(
                  'Нийт хаах:',
                  style: TextStyle(fontSize: 14, color: AppTheme.textDark),
                ),
                const Spacer(),
                Text(
                  formatTugrik(item.totalCloseAmount),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
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

// ════════════════════════════════════════════════════════════
//  Attachment header — count badge, opens sheet on tap
// ════════════════════════════════════════════════════════════

class AdvanceReqAttachmentHeader extends StatelessWidget {
  final int count;
  final bool hasNew;
  final VoidCallback onTap;

  const AdvanceReqAttachmentHeader({
    required this.count,
    required this.hasNew,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AppCard(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Row(
          children: [
            if (hasNew) ...[
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
            const Text(
              'Хавсаргасан баримтууд',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),
            const Spacer(),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: hasNew ? AppTheme.primary : AppTheme.textGrey,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: AppTheme.textGrey,
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Document form card — owns all form state
// ════════════════════════════════════════════════════════════


class AdvanceReqSubmitBar extends StatelessWidget {
  final bool isSubmitted;
  final VoidCallback onSubmit;

  const AdvanceReqSubmitBar({required this.isSubmitted, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      color: Colors.white,
      child: ElevatedButton(
        onPressed: onSubmit,
        child: Text(isSubmitted ? 'Шинээр шалгах' : 'Шалгах'),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Success toast — floating pill shown after submit
// ════════════════════════════════════════════════════════════

class AdvanceReqSuccessToast extends StatelessWidget {
  const AdvanceReqSuccessToast();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 22, color: Color(0xFF34C759)),
            SizedBox(width: 8),
            Text(
              'Урдчилгаа амжилттай хаагдлаа.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Suggested docs dialog — positioned dropdown at top
// ════════════════════════════════════════════════════════════



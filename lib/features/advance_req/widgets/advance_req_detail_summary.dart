import 'package:flutter/material.dart';
import 'package:ncapp/core/utils/format.dart';
import 'package:ncapp/core/widgets/app_card.dart';
import 'package:ncapp/features/advance_req/advance_req_model.dart';
import 'package:ncapp/theme/app_theme.dart';

// 🌟 API ХОЛБОЛТЫН ТҮЛХҮҮРИЙГ АШИГЛАХЫН ТУЛД ФОРМ КАРТЫГ ЭНД ИМПОРТ ХИЙНЭ
import 'package:ncapp/features/advance_req/widgets/advance_req_document_form_card.dart';

// Үндсэн дэлгэц дээр дуудаж ашиглах GlobalKey (Форм карттай холбох зориулалттай нээлттэй түлхүүр)
final GlobalKey<AdvanceReqDocumentFormCardState> advanceReqFormCardKey = GlobalKey<AdvanceReqDocumentFormCardState>();

class AdvanceReqInfoCard extends StatelessWidget {
  final AdvanceReqModel item;
  const AdvanceReqInfoCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
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
                Text(
                  'Үлдэгдэл:',
                  style: TextStyle(fontSize: 14, color: appColors.textPrimary),
                ),
                const Spacer(),
                Text(
                  formatTugrik(item.remainingAmount),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: appColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: appColors.border),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                Text(
                  'Нийт хаах:',
                  style: TextStyle(fontSize: 14, color: appColors.textPrimary),
                ),
                const Spacer(),
                Text(
                  formatTugrik(item.totalCloseAmount),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: appColors.textPrimary,
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

  const AdvanceReqAttachmentHeader({super.key, 
    required this.count,
    required this.hasNew,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
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
            Text(
              'Хавсаргасан баримтууд',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: appColors.textPrimary,
              ),
            ),
            const Spacer(),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: hasNew ? AppTheme.primary : appColors.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: appColors.textSecondary,
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

  const AdvanceReqSubmitBar({super.key, 
    required this.isSubmitted,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      color: appColors.cardBackground,
      child: ElevatedButton(
        onPressed: () {
          // 🌟 ЭНД "ШАЛГАХ" ТОВЧ ДАРАГДАХ ҮЕД ЦААНАА ФОРМ ДЭЭР БАЙГАА ӨГӨГДЛИЙГ SQLite РУУ ИЛГЕЭНЭ
          advanceReqFormCardKey.currentState?.sendFeedbackToServer();
          
          // Таны апп-ын хуучин шалгах үйлдэл хэвээрээ ажиллана
          onSubmit();
        },
        child: Text(isSubmitted ? 'Шинээр шалгах' : 'Шалгах'),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Success toast — floating pill shown after submit
// ════════════════════════════════════════════════════════════

class AdvanceReqSuccessToast extends StatelessWidget {
  const AdvanceReqSuccessToast({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: appColors.elevatedSurface,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 22, color: Color(0xFF34C759)),
            const SizedBox(width: 8),
            Text(
              'Урдчилгаа амжилттай хаагдлаа.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: appColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

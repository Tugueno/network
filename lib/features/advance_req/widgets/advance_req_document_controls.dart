import 'package:flutter/material.dart';
import 'package:ncapp/features/advance_req/widgets/advance_req_document_dialogs.dart';
import 'package:ncapp/theme/app_theme.dart';

class AdvanceReqDocumentTabSelector extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const AdvanceReqDocumentTabSelector({
    required this.tabs,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final selected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: appColors.cardBackground,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: selected ? AppTheme.primary : appColors.border,
                  width: selected ? 1.3 : 1,
                ),
              ),
              child: Text(
                tabs[i],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: selected ? AppTheme.primary : appColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Suggested docs row — grey box, opens dialog on tap
// ════════════════════════════════════════════════════════════

class SuggestedAdvanceDocsRow extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const SuggestedAdvanceDocsRow({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: appColors.subtleFill,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text(
              'Санал болгож буй баримтууд',
              style: TextStyle(fontSize: 14, color: appColors.textSecondary),
            ),
            const Spacer(),
            Text(
              '$count',
              style: TextStyle(fontSize: 14, color: appColors.textSecondary),
            ),
            const SizedBox(width: 4),
            Icon(Icons.unfold_more, size: 18, color: appColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  File upload box — dashed border, shows attached file
// ════════════════════════════════════════════════════════════

class AdvanceReqFileUploadBox extends StatelessWidget {
  final String? attachedFile;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  const AdvanceReqFileUploadBox({
    required this.attachedFile,
    required this.onPick,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = attachedFile != null;

    return GestureDetector(
      onTap: hasFile ? null : onPick,
      child: CustomPaint(
        painter: AdvanceReqDashedBorderPainter(
          color: AppTheme.primary,
          radius: 10,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: hasFile
                ? _AttachedFileRow(file: attachedFile!, onRemove: onRemove)
                : const _UploadPrompt(),
          ),
        ),
      ),
    );
  }
}

class _UploadPrompt extends StatelessWidget {
  const _UploadPrompt();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.upload_outlined, size: 20, color: AppTheme.primary),
        SizedBox(width: 10),
        Text(
          'Файл хавсаргах',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.primary,
          ),
        ),
      ],
    );
  }
}

class _AttachedFileRow extends StatelessWidget {
  final String file;
  final VoidCallback onRemove;

  const _AttachedFileRow({required this.file, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    return Row(
      children: [
        const Icon(
          Icons.insert_drive_file_outlined,
          size: 18,
          color: AppTheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            file,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.primary,
              decoration: TextDecoration.underline,
              decorationColor: AppTheme.primary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: onRemove,
          child: Icon(Icons.close, size: 18, color: appColors.textSecondary),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════
//  OCR warning box — shown when image file cannot be parsed
// ════════════════════════════════════════════════════════════

class AdvanceReqOcrWarningBox extends StatelessWidget {
  const AdvanceReqOcrWarningBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFFCC00).withValues(alpha: 0.4),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, size: 18, color: Color(0xFFFF9500)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Дүн болон ДДТД таньж чадсангүй. Зургийг дахин авах эсвэл гараар оруулна уу.',
              style: TextStyle(fontSize: 13, color: Color(0xFF7A5C00)),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Partial section — toggle + amount input + computed total
// ════════════════════════════════════════════════════════════

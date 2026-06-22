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
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: selected ? AppTheme.primary : AppTheme.borderColor,
                  width: selected ? 1.3 : 1,
                ),
              ),
              child: Text(
                tabs[i],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: selected ? AppTheme.primary : AppTheme.textGrey,
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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Text(
              'Санал болгож буй баримтууд',
              style: TextStyle(fontSize: 14, color: AppTheme.textGrey),
            ),
            const Spacer(),
            Text(
              '$count',
              style: const TextStyle(fontSize: 14, color: AppTheme.textGrey),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.unfold_more, size: 18, color: AppTheme.textGrey),
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
        painter: AdvanceReqDashedBorderPainter(color: AppTheme.primary, radius: 10),
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
          child: const Icon(Icons.close, size: 18, color: AppTheme.textGrey),
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


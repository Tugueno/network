import 'package:flutter/material.dart';
import 'package:ncapp/core/widgets/bottom_sheet_container.dart';
import 'package:ncapp/theme/app_theme.dart';

class AdvanceReqAttachmentSheet extends StatelessWidget {
  final int count;
  const AdvanceReqAttachmentSheet({required this.count});

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      maxHeightFactor: 0.75,
      children: [
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Хавсаргасан баримтууд',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Flexible(
          child: GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.8,
            ),
            itemCount: count,
            itemBuilder: (_, i) => _AttachmentTile(index: i),
          ),
        ),
      ],
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  final int index;
  const _AttachmentTile({required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: const Color(0xFFF2F2F7),
              width: double.infinity,
              child: const Center(
                child: Icon(
                  Icons.receipt_long_outlined,
                  size: 32,
                  color: AppTheme.textGrey,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "27'000₮",
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark,
          ),
        ),
        const Text(
          '05/20/2026',
          style: TextStyle(fontSize: 10, color: AppTheme.textGrey),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Dashed border painter
// ════════════════════════════════════════════════════════════



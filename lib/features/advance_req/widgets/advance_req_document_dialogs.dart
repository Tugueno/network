import 'package:flutter/material.dart';
import 'package:ncapp/theme/app_theme.dart';

class SuggestedAdvanceDoc {
  final String amount;
  final String account;
  const SuggestedAdvanceDoc({required this.amount, required this.account});
}

class AdvanceReqSuggestedDocsDialog extends StatelessWidget {
  final List<SuggestedAdvanceDoc> docs;
  final ValueChanged<SuggestedAdvanceDoc> onSelect;

  const AdvanceReqSuggestedDocsDialog({required this.docs, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 180, 16, 0),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: Text(
                    'Санал болгож буй баримтууд',
                    style: TextStyle(fontSize: 14, color: AppTheme.textGrey),
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F0F0),
                ),
                for (int i = 0; i < docs.length; i++) ...[
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onSelect(docs[i]),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            docs[i].amount,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            docs[i].account,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (i < docs.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF0F0F0),
                    ),
                ],
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  File picker dialog — right-aligned popup with 3 options
// ════════════════════════════════════════════════════════════

class AdvanceReqFilePickerDialog extends StatelessWidget {
  final ValueChanged<String> onPick;
  const AdvanceReqFilePickerDialog({required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, top: 40),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PickerOption(
                  icon: Icons.photo_library_outlined,
                  label: 'Зургын цомог',
                  onTap: () => onPick('IMG.2424.pdf'),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F0F0),
                ),
                _PickerOption(
                  icon: Icons.camera_alt_outlined,
                  label: 'Камер',
                  onTap: () => onPick('PHOTO.jpg'),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F0F0),
                ),
                _PickerOption(
                  icon: Icons.folder_outlined,
                  label: 'Файл сонгох',
                  onTap: () => onPick('document.pdf'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PickerOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickerOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: AppTheme.textDark),
            ),
            const Spacer(),
            Icon(icon, size: 22, color: AppTheme.textGrey),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Attachment bottom sheet — grid of uploaded files
// ════════════════════════════════════════════════════════════



class AdvanceReqDashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  const AdvanceReqDashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dash = 6.0;
    const gap = 4.0;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + dash), paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(AdvanceReqDashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}




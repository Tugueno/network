import 'package:cupertino_native/cupertino_native.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ncapp/theme/app_theme.dart';

class SuggestedAdvanceDoc {
  final String amount;
  final String account;

  const SuggestedAdvanceDoc({required this.amount, required this.account});
}

class AdvanceReqSuggestedDocsDialog extends StatelessWidget {
  final List<SuggestedAdvanceDoc> docs;
  final ValueChanged<SuggestedAdvanceDoc> onSelect;

  const AdvanceReqSuggestedDocsDialog({
    super.key,
    required this.docs,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppTheme.colors(context);
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 180, 16, 0),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: appColors.elevatedSurface,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: Text(
                    'Санал болгож буй баримтууд',
                    style: TextStyle(
                      fontSize: 14,
                      color: appColors.textSecondary,
                    ),
                  ),
                ),
                Divider(height: 1, thickness: 1, color: appColors.border),
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
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: appColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            docs[i].account,
                            style: TextStyle(
                              fontSize: 14,
                              color: appColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (i < docs.length - 1)
                    Divider(height: 1, thickness: 1, color: appColors.border),
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

class AdvanceReqFilePickerDialog extends StatelessWidget {
  final ValueChanged<String> onPick;

  const AdvanceReqFilePickerDialog({super.key, required this.onPick});

  Future<void> _pickFromGallery(BuildContext context) async {
    await _runPicker(context, () async {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        onPick(image.path);
      }
    });
  }

  Future<void> _pickFromCamera(BuildContext context) async {
    await _runPicker(context, () async {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image != null) {
        onPick(image.path);
      }
    });
  }

  Future<void> _pickFromFiles(BuildContext context) async {
    await _runPicker(context, () async {
      final result = await FilePicker.pickFiles();
      final file = result?.files.single;
      final path = file?.path;
      if (path != null && path.isNotEmpty) {
        onPick(path);
      }
    });
  }

  Future<void> _runPicker(
    BuildContext context,
    Future<void> Function() picker,
  ) async {
    try {
      await picker();
    } on MissingPluginException {
      if (context.mounted) {
        _showPickerError(context);
      }
    } on PlatformException {
      if (context.mounted) {
        _showPickerError(context);
      }
    }
  }

  void _showPickerError(BuildContext context) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      const SnackBar(
        content: Text(
          'Файл сонгогчийг ажиллуулахын тулд апп-аа дахин нээнэ үү.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CNPopupMenuButton(
      buttonLabel: 'Файл хавсаргах',
      height: 42,
      shrinkWrap: true,
      buttonStyle: CNButtonStyle.plain,
      tint: CupertinoColors.activeBlue,
      items: const [
        CNPopupMenuItem(
          label: 'Зургын цомог',
          icon: CNSymbol('photo.on.rectangle', size: 18),
        ),
        CNPopupMenuItem(label: 'Камер', icon: CNSymbol('camera', size: 18)),
        CNPopupMenuItem(
          label: 'Файл сонгох',
          icon: CNSymbol('folder', size: 18),
        ),
      ],
      onSelected: (index) async {
        switch (index) {
          case 0:
            await _pickFromGallery(context);
          case 1:
            await _pickFromCamera(context);
          case 2:
            await _pickFromFiles(context);
        }
      },
    );
  }
}

class AdvanceReqFileUploadPrompt extends StatelessWidget {
  final ValueChanged<String> onPick;

  const AdvanceReqFileUploadPrompt({super.key, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          CupertinoIcons.arrow_up_doc,
          size: 20,
          color: CupertinoColors.activeBlue,
        ),
        const SizedBox(width: 10),
        AdvanceReqFilePickerDialog(onPick: onPick),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Attachment bottom sheet — grid of uploaded files
// ════════════════════════════════════════════════════════════

class AdvanceReqDashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  const AdvanceReqDashedBorderPainter({
    required this.color,
    required this.radius,
  });

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

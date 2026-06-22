// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:ncapp/features/payment_req/models/payment_req_model.dart';

Future<void> openAttachmentFile(
  BuildContext context,
  AttachmentFile file,
) async {
  final previewUrl = _previewUrl(file);
  if (previewUrl.isEmpty) {
    if (context.mounted) {
      _showMessage(context, 'Файлын холбоос олдсонгүй');
    }
    return;
  }

  final viewType =
      'attachment-preview-${DateTime.now().microsecondsSinceEpoch}';

  ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    return html.IFrameElement()
      ..src = previewUrl
      ..style.border = '0'
      ..style.width = '100%'
      ..style.height = '100%'
      ..allowFullscreen = true;
  });

  if (!context.mounted) return;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        insetPadding: const EdgeInsets.all(24),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: 920,
          height: MediaQuery.sizeOf(dialogContext).height * 0.86,
          child: Column(
            children: [
              _PreviewHeader(
                title: file.name,
                onClose: () => Navigator.of(dialogContext).pop(),
              ),
              Expanded(child: HtmlElementView(viewType: viewType)),
            ],
          ),
        ),
      );
    },
  );
}

String _previewUrl(AttachmentFile file) {
  if (file.url.isNotEmpty) return file.url;
  if (file.assetPath.isEmpty) return '';

  return Uri.base
      .resolve('assets/${Uri.encodeFull(file.assetPath)}')
      .toString();
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

class _PreviewHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const _PreviewHeader({required this.title, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            tooltip: 'Хаах',
            onPressed: onClose,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

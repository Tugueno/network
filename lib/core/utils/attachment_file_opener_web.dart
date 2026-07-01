// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:ncapp/features/payment_req/models/payment_req_model.dart';

Future<void> openAttachmentFile(
  BuildContext context,
  AttachmentFile file,
) async {
  final url = _fileUrl(file);
  if (url.isEmpty) {
    if (context.mounted) {
      _showMessage(context, 'Файлын холбоос олдсонгүй');
    }
    return;
  }

  html.window.open(url, '_blank');
}

String _fileUrl(AttachmentFile file) {
  if (file.url.isNotEmpty) return file.url;
  if (file.assetPath.isEmpty) return '';

  return Uri.base
      .resolve('assets/${Uri.encodeFull(file.assetPath)}')
      .toString();
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ncapp/features/payment_req/models/payment_req_model.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

Future<void> openAttachmentFile(
  BuildContext context,
  AttachmentFile file,
) async {
  try {
    final localPath = await _resolveLocalPath(file);
    if (localPath == null) {
      if (context.mounted) {
        _showMessage(context, 'Файлын зам олдсонгүй');
      }
      return;
    }

    final result = await OpenFile.open(localPath);
    if (result.type != ResultType.done && context.mounted) {
      _showMessage(context, result.message);
    }
  } catch (_) {
    if (context.mounted) {
      _showMessage(context, 'Файлыг нээж чадсангүй');
    }
  }
}

Future<String?> _resolveLocalPath(AttachmentFile file) async {
  final fileName = _safeFileName(file.name);
  final tempDir = await getTemporaryDirectory();
  final output = File('${tempDir.path}/$fileName');

  if (file.assetPath.isNotEmpty) {
    final bytes = await rootBundle.load(file.assetPath);
    await output.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    return output.path;
  }

  if (file.url.isNotEmpty) {
    await Dio().download(file.url, output.path);
    return output.path;
  }

  return null;
}

String _safeFileName(String value) {
  final trimmed = value.trim().isEmpty ? 'attachment.pdf' : value.trim();
  return trimmed.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

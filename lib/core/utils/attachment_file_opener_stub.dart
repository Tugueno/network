import 'package:flutter/material.dart';
import 'package:ncapp/features/payment_req/models/payment_req_model.dart';

Future<void> openAttachmentFile(
  BuildContext context,
  AttachmentFile file,
) async {
  if (!context.mounted) return;

  ScaffoldMessenger.of(
    context,
  ).showSnackBar(const SnackBar(content: Text('Файл нээх боломжгүй байна')));
}

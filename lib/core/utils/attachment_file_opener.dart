import 'package:flutter/material.dart';
import 'package:ncapp/features/payment_req/models/payment_req_model.dart';

import 'attachment_file_opener_stub.dart'
    if (dart.library.io) 'attachment_file_opener_io.dart'
    if (dart.library.html) 'attachment_file_opener_web.dart'
    as platform;

class AttachmentFileOpener {
  const AttachmentFileOpener._();

  static Future<void> open(BuildContext context, AttachmentFile file) {
    return platform.openAttachmentFile(context, file);
  }
}

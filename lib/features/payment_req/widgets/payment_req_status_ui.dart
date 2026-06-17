import 'package:flutter/material.dart';
import 'package:ncapp/features/payment_req/models/payment_req_model.dart';
import 'package:ncapp/theme/app_theme.dart';

/// [PaymentReqStatus] enum-д харагдах байдлын (UI) getter-үүд "наасан" extension.
///
/// Дата (`payment_req_model.dart`) ба UI-г салгаж байгаа тул энэ нь тусдаа
/// файлд байрлана. Ингэснээр статус → дүрс/өнгө/нэр гэсэн mapping **нэг газар**
/// төвлөрнө.
extension PaymentReqStatusUI on PaymentReqStatus {
  /// Статусын дүрс (icon). _TotalCard ба _StatusBadge хоёулаа хуваалцана.
  IconData get icon => switch (this) {
        PaymentReqStatus.pending => Icons.monetization_on,
        PaymentReqStatus.approved => Icons.check_circle,
        PaymentReqStatus.rejected => Icons.cancel,
      };

  /// Семантик статусын өнгө: хүлээгдэж буй=саарал, зөвшөөрсөн=ногоон,
  /// буцаасан=улаан. (_StatusBadge ашиглана.)
  Color get color => switch (this) {
        PaymentReqStatus.pending => AppTheme.textGrey,
        PaymentReqStatus.approved => const Color(0xFF34C759),
        PaymentReqStatus.rejected => AppTheme.error,
      };

  /// Статусын нэр.
  String get label => switch (this) {
        PaymentReqStatus.pending => 'Хүлээгдэж буй',
        PaymentReqStatus.approved => 'Зөвшөөрсөн',
        PaymentReqStatus.rejected => 'Цуцлагдсан',
      };

  /// Шийдвэрийн огнооны шошго (зөвшөөрсөн/буцаасан үед; хүлээгдэж буйд хоосон).
  String get decisionLabel => switch (this) {
        PaymentReqStatus.approved => 'Зөвшөөрсөн өдөр:',
        PaymentReqStatus.rejected => 'Буцаасан өдөр:',
        PaymentReqStatus.pending => '',
      };
}

import 'package:flutter/material.dart';
import 'package:ncapp/theme/app_theme.dart';

/// Жагсаалт хоосон үед дэлгэцийн төвд харуулах ерөнхий "хоосон төлөв".
///
/// [subtitle] заавал биш — өгөхгүй бол зөвхөн гарчиг (нэг текст) харагдана
/// (ж: requests дэлгэц). Өгвөл доор нь хоёр дахь текст нэмж харуулна
/// (ж: payment_req, advance_req).
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppTheme.textDark,
            ),
          ),
          // subtitle байгаа үед л хоёр дахь текст + зайг нэмнэ
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppTheme.textGrey),
            ),
          ],
        ],
      ),
    );
  }
}

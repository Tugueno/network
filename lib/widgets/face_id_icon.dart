// ═══════════════════════════════════════════════════════
//  face_id_icon.dart — Apple Face ID дүрс
//  network_logo.dart-аас тусдаа файлд гаргасан
// ═══════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FaceIdIcon extends StatelessWidget {
  final double size;
  final Color color;
  const FaceIdIcon({super.key, this.size = 24, this.color = AppTheme.primary});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(painter: _FaceIdPainter(color: color)),
  );
}

class _FaceIdPainter extends CustomPainter {
  final Color color;
  const _FaceIdPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07
      ..strokeCap = StrokeCap.round;
    final w = size.width, h = size.height, cr = w * 0.18;

    // 4 булан
    canvas.drawArc(
      Rect.fromLTWH(0, 0, cr * 2, cr * 2),
      3.14159 * 1.0,
      3.14159 * 0.5,
      false,
      p,
    );
    canvas.drawLine(Offset(cr, 0), Offset(w * 0.32, 0), p);
    canvas.drawLine(Offset(0, cr), Offset(0, h * 0.32), p);

    canvas.drawArc(
      Rect.fromLTWH(w - cr * 2, 0, cr * 2, cr * 2),
      3.14159 * 1.5,
      3.14159 * 0.5,
      false,
      p,
    );
    canvas.drawLine(Offset(w - cr, 0), Offset(w * 0.68, 0), p);
    canvas.drawLine(Offset(w, cr), Offset(w, h * 0.32), p);

    canvas.drawArc(
      Rect.fromLTWH(0, h - cr * 2, cr * 2, cr * 2),
      3.14159 * 0.5,
      3.14159 * 0.5,
      false,
      p,
    );
    canvas.drawLine(Offset(cr, h), Offset(w * 0.32, h), p);
    canvas.drawLine(Offset(0, h - cr), Offset(0, h * 0.68), p);

    canvas.drawArc(
      Rect.fromLTWH(w - cr * 2, h - cr * 2, cr * 2, cr * 2),
      0,
      3.14159 * 0.5,
      false,
      p,
    );
    canvas.drawLine(Offset(w - cr, h), Offset(w * 0.68, h), p);
    canvas.drawLine(Offset(w, h - cr), Offset(w, h * 0.68), p);

    // Нүд
    final f = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.35, h * 0.38), w * 0.06, f);
    canvas.drawCircle(Offset(w * 0.65, h * 0.38), w * 0.06, f);

    // Хамар
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.5, h * 0.44)
        ..lineTo(w * 0.5, h * 0.58)
        ..lineTo(w * 0.44, h * 0.63),
      p,
    );

    // Инээмсэглэл
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.33, h * 0.70)
        ..quadraticBezierTo(w * 0.5, h * 0.82, w * 0.67, h * 0.70),
      p,
    );
  }

  @override
  bool shouldRepaint(_FaceIdPainter old) => old.color != color;
}
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NetworkLogo extends StatelessWidget {
  const NetworkLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Hexagon W icon
        SizedBox(
          width: 38,
          height: 38,
          child: CustomPaint(
            painter: _HexagonPainter(color: AppTheme.primary),
            child: const Center(
              child: Text(
                'W',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'NETWORK',
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _HexagonPainter extends CustomPainter {
  final Color color;
  const _HexagonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (60 * i - 30) * math.pi / 180;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_HexagonPainter old) => old.color != color;
}
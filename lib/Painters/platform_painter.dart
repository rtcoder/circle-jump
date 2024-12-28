import 'package:circle_jump/game.dart';
import 'package:flutter/material.dart';
import '../utils.dart';

class PlatformPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.brown;

    final center = getCenterOfCircle(size);

    for (final platform in game.platforms) {
      paint.strokeWidth = platform.thickness;
      final rect = Rect.fromCircle(
        center: Offset(center.centerX, center.centerY),
        radius: platform.radius + center.radius,
      );

      canvas.drawArc(
        rect,
        platform.angle,
        platform.arcLength,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

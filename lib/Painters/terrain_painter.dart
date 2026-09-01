import 'dart:math';

import 'package:circle_jump/Models/game.dart';
import 'package:flutter/material.dart';

class TerrainPainter extends CustomPainter {
  static const int _segments = 180;

  final Color earthColor;
  final Color grassColor;

  const TerrainPainter({
    this.earthColor = const Color(0xFF7A4A24),
    this.grassColor = const Color(0xFF49B83F),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = game.circleCenter;
    final earthPaint = Paint()
      ..color = earthColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 34;
    final grassPaint = Paint()
      ..color = grassColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 7;

    final path = Path();
    for (int i = 0; i <= _segments; i++) {
      final angle = (i / _segments) * 2 * pi;
      final radius = center.radius +
          game.world.terrainHeightAtScreenAngle(
            angle,
          );
      final point = Offset(
        center.centerX + radius * cos(angle),
        center.centerY + radius * sin(angle),
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();

    canvas.drawPath(path, earthPaint);
    canvas.drawPath(path, grassPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

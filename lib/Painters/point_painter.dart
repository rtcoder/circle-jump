import 'package:flutter/material.dart';

import '../Models/game.dart';

class PointPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    for (final point in game.points) {
      canvas.drawCircle(
        Offset(point.x, point.y),
        point.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

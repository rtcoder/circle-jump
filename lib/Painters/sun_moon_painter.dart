import 'package:circle_jump/Models/game.dart';
import 'package:flutter/material.dart';

import '../Models/circle_center.dart';
import '../utils.dart';

void drawMoon(Canvas canvas, Paint paint, Size size, double angleDeg) {
  final CircleCenter center = game.circleCenter;
  final position = angleToPositionOnCircle(center, angleDeg, 200);
  double x = position.dx;
  double y = position.dy;
  paint.color = Colors.grey;
  canvas.drawCircle(Offset(x, y), 30, paint);

  paint.color = const Color(0x1701011E);
  canvas.drawCircle(Offset(x - 10, y - 10), 5, paint);
  canvas.drawCircle(Offset(x + 8, y + 12), 4, paint);
  canvas.drawCircle(Offset(x + 15, y - 5), 6, paint);
}

void drawSun(Canvas canvas, Paint paint, Size size, double angleDeg) {
  final CircleCenter center = game.circleCenter;
  final position = angleToPositionOnCircle(center, angleDeg, 200);
  double x = position.dx;
  double y = position.dy;
  paint.color = Colors.yellow;
  canvas.drawCircle(Offset(x, y), 30, paint);
}

class SunMoonPainter extends CustomPainter {
  final double time;

  SunMoonPainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final sunAngleDeg = _interpolateAngle(time <= 0.5 ? time * 2 : 0);
    final moonAngleDeg = _interpolateAngle(time > 0.5 ? (time - 0.5) * 2 : 0);

    if (time <= 0.5) {
      drawSun(canvas, paint, size, sunAngleDeg);
    } else {
      drawMoon(canvas, paint, size, moonAngleDeg);
    }
  }

  double _interpolateAngle(double progress) {
    return 243 + (296 - 243) * progress;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

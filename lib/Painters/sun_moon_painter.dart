import 'package:flutter/material.dart';

import '../utils.dart';

void drawMoon(
    Canvas canvas, Paint paint, CircleCenter center, double angleDeg) {
  final position = angleToPositionOnCircle(center, angleDeg, 200);
  double x = position.dx;
  double y = position.dy;

  paint.color = Colors.grey;
  canvas.drawCircle(Offset(x, y), 30, paint);

  paint.color = Color(0x1701011E);
  canvas.drawCircle(Offset(x - 10, y - 10), 5, paint);
  canvas.drawCircle(Offset(x + 8, y + 12), 4, paint);
  canvas.drawCircle(Offset(x + 15, y - 5), 6, paint);
}

void drawSun(Canvas canvas, Paint paint, CircleCenter center, double angleDeg) {
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

    var center = getCenterOfCircle(size);
    final angleDegSun = 360 * time;
    final angleDegMoon = angleDegSun - 180;

    drawSun(canvas, paint, center, angleDegSun);
    drawMoon(canvas, paint, center, angleDegMoon);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

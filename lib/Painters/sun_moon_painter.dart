import 'package:flutter/material.dart';
import '../utils.dart';

void drawMoon(Canvas canvas, Paint paint, CircleCenter center, Size size,
    double angleDeg) {
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

void drawSun(Canvas canvas, Paint paint, CircleCenter center, Size size,
    double angleDeg) {
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
    final sunAngleDeg = _interpolateAngle(time <= 0.5 ? time * 2 : 0); // Dzień
    final moonAngleDeg = _interpolateAngle(time > 0.5 ? (time - 0.5) * 2 : 0); // Noc

    if (time <= 0.5) {
      // Rysowanie słońca (dzień)
      drawSun(canvas, paint, center, size, sunAngleDeg);
    } else {
      // Rysowanie księżyca (noc)
      drawMoon(canvas, paint, center, size, moonAngleDeg);
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

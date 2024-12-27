import 'package:circle_jump/game.dart';
import 'package:flutter/material.dart';

import '../images.dart';
import '../utils.dart';

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    var center = getCenterOfCircle(size);
    final centerX = center.centerX;
    final centerY = center.centerY;
    final radius = center.radius;
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);

    final newSize = (radius * 2) + 30;
    final circleOffset = Offset(centerX - newSize / 2, centerY - newSize / 2);
    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(-game.circleAngle);
    canvas.translate(-centerX, -centerY);
    canvas.drawImageRect(
        Images.circleImage!,
        Rect.fromLTRB(
            0, 0, Images.circleImage!.width.toDouble(), Images.circleImage!.height.toDouble()),
        Rect.fromLTWH(circleOffset.dx, circleOffset.dy, newSize, newSize),
        paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

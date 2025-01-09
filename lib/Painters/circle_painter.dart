import 'package:circle_jump/Models/game.dart';
import 'package:circle_jump/images.dart';
import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (Images.circleImage == null) {
      return;
    }
    final image = Images.circleImage!;
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    var center = game.circleCenter;
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
        image,
        Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromLTWH(circleOffset.dx, circleOffset.dy, newSize, newSize),
        paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

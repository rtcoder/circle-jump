import 'package:circle_jump/images.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class PlayerPainter extends CustomPainter {
  final double playerY;
  final bool isJumping;

  PlayerPainter({
    required this.playerY,
    required this.isJumping,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isJumping ? Colors.blue : Colors.red
      ..style = PaintingStyle.fill;

    final playerX = size.width / 2;

    canvas.drawCircle(Offset(playerX, playerY), playerRadius, paint);
    final newSize = 40.0;
    final circleOffset = Offset(playerX - newSize / 2, playerY - newSize / 2);
    canvas.save();
    canvas.translate(playerX, playerY);
    canvas.rotate(playerAngle);
    canvas.translate(-playerX, -playerY);
    canvas.drawImageRect(
        Images.ballImage!,
        Rect.fromLTRB(0, 0, Images.ballImage!.width.toDouble(),
            Images.ballImage!.height.toDouble()),
        Rect.fromLTWH(circleOffset.dx, circleOffset.dy, newSize, newSize),
        paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

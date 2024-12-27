import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../utils.dart';

class PlayerPainter extends CustomPainter {
  final double playerY;
  final bool isJumping;
  final ui.Image playerImage;
  final double playerAngle;

  PlayerPainter({
    required this.playerY,
    required this.isJumping,
    required this.playerImage,
    required this.playerAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isJumping ? Colors.blue : Colors.red
      ..style = PaintingStyle.fill;

    final playerX = size.width / 2;
print(playerAngle);
    canvas.drawCircle(Offset(playerX, playerY), playerRadius, paint);
    final newSize = 40.0;
    final circleOffset = Offset(playerX - newSize / 2, playerY - newSize / 2);
    canvas.save();
    canvas.translate(playerX, playerY);
    canvas.rotate(playerAngle);
    canvas.translate(-playerX, -playerY);
    canvas.drawImageRect(
        playerImage,
        Rect.fromLTRB(
            0, 0, playerImage.width.toDouble(), playerImage.height.toDouble()),
        Rect.fromLTWH(circleOffset.dx, circleOffset.dy, newSize, newSize),
        paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

import 'package:circle_jump/game.dart';
import 'package:circle_jump/images.dart';
import 'package:flutter/material.dart';

class PlayerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final playerX = size.width / 2;
    final playerY = (size.height / 2) - game.player.playerY;

    canvas.drawCircle(Offset(playerX, playerY), game.player.playerRadius, paint);
    const newSize = 40.0;
    final circleOffset = Offset(playerX - newSize / 2, playerY - newSize / 2);
    canvas.save();
    canvas.translate(playerX, playerY);
    canvas.rotate(game.player.playerAngle);
    canvas.translate(-playerX, -playerY);
    canvas.drawImageRect(
        Images.ballImage,
        Rect.fromLTRB(0, 0, Images.ballImage.width.toDouble(),
            Images.ballImage.height.toDouble()),
        Rect.fromLTWH(circleOffset.dx, circleOffset.dy, newSize, newSize),
        paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

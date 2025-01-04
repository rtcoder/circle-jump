import 'package:circle_jump/Models/game.dart';
import 'package:circle_jump/Models/Player/player.dart';
import 'package:circle_jump/images.dart';
import 'package:flutter/material.dart';

class PlayerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if(Images.ballImage == null) {
      return;
    }
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final img = Images.ballImage!;
    final w = img.width.toDouble();
    final h = img.height.toDouble();
    final Player player = game.player;
    final playerX = player.playerX;
    final playerY = player.playerYAbsolutePosition;
    final radius = player.radius;
    final playerW = radius * 2;
    final circleOffset = Offset(playerX - radius, playerY - radius);

    canvas.drawCircle(Offset(playerX, playerY), radius, paint);
    canvas.save();
    canvas.translate(playerX, playerY);
    canvas.rotate(player.playerAngle);
    canvas.translate(-playerX, -playerY);
    canvas.drawImageRect(
        img,
        Rect.fromLTRB(0, 0, w, h),
        Rect.fromLTWH(circleOffset.dx, circleOffset.dy, playerW, playerW),
        paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

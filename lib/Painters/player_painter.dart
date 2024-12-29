import 'package:circle_jump/game.dart';
import 'package:circle_jump/images.dart';
import 'package:circle_jump/player.dart';
import 'package:flutter/material.dart';

class PlayerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final img = Images.ballImage;
    final w = img.width.toDouble();
    final h = img.height.toDouble();
    final Player player = game.player;
    final playerX = size.width / 2;
    final playerY = (size.height / 2) - (player.playerY + player.jumpProgress);
    final radius = player.radius;
    final playerW = radius * 2;
    final circleOffset = Offset(playerX - radius, playerY - radius);

    drawFire(canvas, player, playerW, circleOffset, paint);

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

  void drawFire(Canvas canvas, Player player, double playerW,
      Offset circleOffset, Paint paint) {
    if (!player.withFire) {
      return;
    }
    final imgFire = Images.fireEngineImage;
    final imgFireW = imgFire.width.toDouble();
    final imgFireH = imgFire.height.toDouble();
    final ratio = imgFireW / playerW;
    final newH = imgFireH / ratio;
    canvas.drawImageRect(
        imgFire,
        Rect.fromLTRB(0, 0, imgFireW, imgFireH),
        Rect.fromLTWH(
            circleOffset.dx, circleOffset.dy + player.radius, playerW, newH),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

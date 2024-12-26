import 'package:flutter/material.dart';

class PlayerPainter extends CustomPainter {
  final double playerY;
  final bool isJumping;

  PlayerPainter({required this.playerY, required this.isJumping});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final playerX = size.width / 2;

    canvas.drawCircle(Offset(playerX, playerY), 20, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

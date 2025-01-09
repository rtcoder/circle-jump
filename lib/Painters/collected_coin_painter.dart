import 'package:circle_jump/images.dart';
import 'package:flutter/material.dart';

class CollectedCoinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (Images.coinImage == null) {
      return;
    }
    const Rect sourceRect = Rect.fromLTWH(0, 0, 64, 64);
    final Rect destinationRect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawImageRect(
      Images.coinImage!,
      sourceRect,
      destinationRect,
      Paint(),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

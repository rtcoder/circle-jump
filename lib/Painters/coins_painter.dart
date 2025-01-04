import 'package:flutter/material.dart';

import '../Models/game.dart';
import '../images.dart';

class CoinsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (Images.coinImage == null) {
      return;
    }

    final coinImage = Images.coinImage!;
    for (final coin in game.coinCollector.visibleItems) {
      const int frameWidth = 64;
      const int frameHeight = 64;

      final Rect srcRect = Rect.fromLTWH(
        (coin.animationFrame % 4) * frameWidth.toDouble(),
        (coin.animationFrame ~/ 4) * frameHeight.toDouble(),
        frameWidth.toDouble(),
        frameHeight.toDouble(),
      );

      final Rect dstRect = Rect.fromCenter(
        center: Offset(coin.x, coin.y),
        width: coin.radius * 2,
        height: coin.radius * 2,
      );

      canvas.drawImageRect(coinImage, srcRect, dstRect, Paint());
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

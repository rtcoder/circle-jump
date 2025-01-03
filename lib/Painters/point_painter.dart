import 'package:flutter/material.dart';

import '../Models/game.dart';
import '../images.dart';

class PointPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (Images.coinImage == null) {
      return;
    }

    final coinImage = Images.coinImage!;
    for (final point in game.points) {
      // Rozmiar pojedynczej klatki w sprite sheet
      const int frameWidth = 64;
      const int frameHeight = 64;

      // Obliczanie prostokąta wycinka dla klatki
      final Rect srcRect = Rect.fromLTWH(
        (point.animationFrame % 4) * frameWidth.toDouble(),
        // Kolumna (4 klatki na wiersz)
        (point.animationFrame ~/ 4) * frameHeight.toDouble(), // Wiersz
        frameWidth.toDouble(),
        frameHeight.toDouble(),
      );

      // Obliczanie miejsca docelowego na canvasie
      final Rect dstRect = Rect.fromCenter(
        center: Offset(point.x, point.y),
        width: point.radius * 2,
        height: point.radius * 2,
      );

      // Rysowanie wycinka obrazu
      canvas.drawImageRect(coinImage, srcRect, dstRect, Paint());
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

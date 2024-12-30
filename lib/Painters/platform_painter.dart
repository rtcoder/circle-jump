import 'dart:math';

import 'package:circle_jump/game.dart';
import 'package:circle_jump/images.dart';
import 'package:circle_jump/platform.dart';
import 'package:circle_jump/utils.dart';
import 'package:flutter/material.dart';

class PlatformPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke;

    for (final platform in game.platforms) {
      drawPlatform(canvas, platform, paint);
    }
  }

  void drawPlatform(Canvas canvas, PlatformModel platform, Paint paint) {
    final center = game.circleCenter;
    paint.color = platform.color;
    final Rect rect = Rect.fromCircle(
      center: Offset(center.centerX, center.centerY),
      radius: platform.height + center.radius,
    );

    final double startAngle = platform.startAngle;
    double sweepAngle = (platform.endAngle - platform.startAngle) % (2 * pi);
    if (sweepAngle <= 0) {
      sweepAngle += 2 * pi;
    }
    // Obliczamy macierz transformacji, aby pattern obracał się zgodnie z platformą

    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = platform.strokeWidth;

    _fillWithImage(canvas, platform, center, paint);
  }

  void _fillWithImage(
      Canvas canvas, PlatformModel platform, CircleCenter center, Paint paint) {

    final double platformRadius = platform.height + center.radius;
    final double startAngle = platform.startAngle;
    double sweepAngle = (platform.endAngle - platform.startAngle) % (2 * pi);
    if (sweepAngle <= 0) {
      sweepAngle += 2 * pi;
    }
    final image = Images.blockImage;
    // Szerokość obrazka (przyjmujemy, że obrazek jest kwadratowy)
    final double imageWidth = image.width.toDouble();
    final double imageHeight = image.height.toDouble();

    // Wysokość platformy (grubość łuku)
    final double platformThickness = platform.strokeWidth;

    // Obliczamy liczbę obrazków potrzebnych do wypełnienia łuku
    final double arcLength = platformRadius * sweepAngle;
    final int imageCount = (arcLength / imageWidth).ceil();

    for (int i = 0; i < imageCount; i++) {
      // Kąt środka aktualnego obrazka
      final double angle = startAngle + (i * imageWidth / platformRadius);

      // Pozycja środka obrazka
      final double x = center.centerX + platformRadius * cos(angle);
      final double y = center.centerY + platformRadius * sin(angle);

      // Obrót obrazka
      final double rotation = angle + pi / 2;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      // Dopasowanie rozmiaru obrazka do grubości platformy
      final Rect src = Rect.fromLTWH(0, 0, imageWidth, imageHeight);
      final Rect dst = Rect.fromCenter(
        center: Offset(0, 0),
        width: imageWidth,
        height: platformThickness, // Dopasowujemy wysokość do grubości platformy
      );

      // Rysujemy obrazek
      canvas.drawImageRect(image, src, dst, paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

import 'dart:math';
import 'dart:ui' as ui;

import 'package:circle_jump/Enums/danger_platform_type.dart';
import 'package:circle_jump/Models/Platform/curve_platform.dart';
import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/Platform/ramp_platform.dart';
import 'package:circle_jump/Models/direction_rotation.dart';
import 'package:circle_jump/Models/game.dart';
import 'package:circle_jump/images.dart';
import 'package:flutter/material.dart';

class PlatformPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (Images.blockImage == null) {
      return;
    }
    final paint = Paint()..style = PaintingStyle.stroke;

    for (final platform in game.world.getPlatforms(onlyVisible: true)) {
      _drawPlatform(canvas, platform, paint);
    }
  }

  void _drawPlatform(Canvas canvas, PlatformModel platform, Paint paint) {
    if (platform is RampPlatform) {
      ui.Image? texture = getPlatformImage(platform);
      _drawRamp(canvas, platform, paint, texture);
    }
    if (platform is CurvePlatform) {
      _drawCurve(canvas, platform, paint);
    }
    return;
  }

  void _drawCurve(Canvas canvas, CurvePlatform platform, Paint paint) {
    final center = game.circleCenter;

    final double platformRadius = platform.height + center.radius;
    final double startAngle = platform.startAngle;
    final double sweepAngle = platform.sweepAngle;
    final ui.Image image = getPlatformImage(platform);
    final double imageWidth = image.width.toDouble();
    final double imageHeight = image.height.toDouble();
    final double platformThickness = platform.strokeWidth;
    final double arcLength = platformRadius * sweepAngle;

    // Obliczenie skali, aby dopasować wysokość obrazka do grubości platformy
    final double scale = platformThickness / imageHeight;
    final double scaledImageWidth = imageWidth * scale;

    // Liczba obrazków potrzebnych do wypełnienia łuku
    final int imageCount = (arcLength / scaledImageWidth).ceil();

    for (int i = 0; i < imageCount; i++) {
      // Kąt dla bieżącej pozycji obrazka
      final double angle = startAngle + (i * scaledImageWidth / platformRadius);

      // Pozycja obrazka na okręgu
      final double x = center.centerX + platformRadius * cos(angle);
      final double y = center.centerY + platformRadius * sin(angle);

      // Obrót obrazka na podstawie kąta łuku i kierunku
      final double rotation = angle + pi / 2 + DirectionRotation.getRotationAngle(platform.imageDirection);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      // Obszar źródłowy (cały obrazek)
      final Rect src = Rect.fromLTWH(0, 0, imageWidth, imageHeight);

      // Obszar docelowy (proporcjonalne skalowanie obrazka)
      final Rect dst = Rect.fromCenter(
        center: const Offset(0, 0),
        width: scaledImageWidth, // Proporcjonalna szerokość
        height: platformThickness, // Grubość platformy
      );

      // Rysowanie obrazka na canvas
      canvas.drawImageRect(image, src, dst, paint);
      canvas.restore();
    }
  }


  ui.Image getPlatformImage(PlatformModel platform) {
    if (!platform.isDanger) {
      return Images.blockImage!;
    }

    switch (platform.dangerPlatformType) {
      case null:
        return Images.blockImage!;
      case DangerPlatformType.longSpike:
        return Images.longSpikeImage!;
      case DangerPlatformType.smallSpike:
        return Images.smallSpikeImage!;
    }
  }

  void _drawRamp(
      Canvas canvas, RampPlatform platform, Paint paint, ui.Image? texture) {
    final double centerX = (platform.startX + platform.endX) / 2;
    final double centerY = (platform.startY + platform.endY) / 2;
    final double angle =
        atan2(platform.endY - platform.startY, platform.endX - platform.startX);
    final double rampLength = sqrt(pow(platform.endX - platform.startX, 2) +
        pow(platform.endY - platform.startY, 2));
    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(angle);

    final Rect rampRect = Rect.fromCenter(
      center: const Offset(0, 0),
      width: rampLength,
      height: platform.strokeWidth,
    );

    if (texture != null) {
      final double imageWidth = texture.width.toDouble();
      final double imageHeight = texture.height.toDouble();
      final double scale = platform.strokeWidth / imageHeight;
      final double scaledImageWidth = imageWidth * scale;
      final int imageCount = (rampLength / scaledImageWidth).ceil();

      for (int i = 0; i < imageCount; i++) {
        final Rect src = Rect.fromLTWH(0, 0, imageWidth, imageHeight);
        final Rect dst = Rect.fromLTWH(
          -rampLength / 2 + i * scaledImageWidth,
          -platform.strokeWidth / 2,
          scaledImageWidth,
          platform.strokeWidth,
        );

        canvas.save();
        canvas.translate(dst.center.dx, dst.center.dy);
        if (platform.imageDirection != null) {
          canvas.rotate(
           DirectionRotation.getRotationAngle(platform.imageDirection));
        }
        canvas.drawImageRect(texture, src, dst.shift(-dst.center), paint);
        canvas.restore();
      }
    } else {
      paint.color = platform.color;
      paint.style = PaintingStyle.fill;
      canvas.drawRect(rampRect, paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

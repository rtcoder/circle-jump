import 'dart:math';

import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/game.dart';
import 'package:circle_jump/images.dart';
import 'package:flutter/material.dart';

import '../Enums/platform_type.dart';

class PlatformPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke;

    for (final platform in game.platforms) {
      _drawPlatform(canvas, platform, paint);
    }
  }

  void _drawPlatform(Canvas canvas, PlatformModel platform, Paint paint) {
    if (platform.type == PlatformType.ramp) {
      _drawRamp(canvas, platform, paint);
    } else {
      _drawCurve(canvas, platform, paint);
    }
    return;
  }

  void _drawCurve(Canvas canvas, PlatformModel platform, Paint paint) {
    final center = game.circleCenter;

    final double platformRadius = platform.startHeight + center.radius;
    final double startAngle = platform.startAngle;
    final double sweepAngle = platform.sweepAngle;
    final image = Images.blockImage;
    final double imageWidth = image.width.toDouble();
    final double imageHeight = image.height.toDouble();
    final double platformThickness = platform.strokeWidth;
    final double arcLength = platformRadius * sweepAngle;
    final int imageCount = (arcLength / imageWidth).ceil();

    for (int i = 0; i < imageCount; i++) {
      final double angle = startAngle + (i * imageWidth / platformRadius);
      final double x = center.centerX + platformRadius * cos(angle);
      final double y = center.centerY + platformRadius * sin(angle);
      final double rotation = angle + pi / 2;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      final Rect src = Rect.fromLTWH(0, 0, imageWidth, imageHeight);
      final Rect dst = Rect.fromCenter(
        center: const Offset(0, 0),
        width: imageWidth,
        height: platformThickness,
      );

      canvas.drawImageRect(image, src, dst, paint);
      canvas.restore();
    }
  }

  void _drawRamp(Canvas canvas, PlatformModel platform, Paint paint) {
    paint.color = platform.color;
    paint.strokeWidth = platform.strokeWidth;
    final Path rampPath = Path()
      ..moveTo(platform.startX, platform.startY)
      ..lineTo(platform.endX, platform.endY);

    canvas.drawPath(rampPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

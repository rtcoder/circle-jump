import 'dart:math';
import 'dart:ui' as ui;

import 'package:circle_jump/Enums/danger_platform_type.dart';
import 'package:circle_jump/Models/Platform/curve_platform.dart';
import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/Platform/ramp_platform.dart';
import 'package:circle_jump/Models/game.dart';
import 'package:circle_jump/images.dart';
import 'package:circle_jump/utils.dart';
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
      _drawRamp(canvas, platform, paint);
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
    final int imageCount = (arcLength / imageWidth).ceil();

    for (int i = 0; i < imageCount; i++) {
      final double angle = startAngle + (i * imageWidth / platformRadius);
      final double x = center.centerX + platformRadius * cos(angle);
      final double y = center.centerY + platformRadius * sin(angle);
      final double rotation = angle + pi / 2 + platform.rotatePlatformImageAngle;

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

  ui.Image getPlatformImage(PlatformModel platform) {
    if (!platform.isDanger) {
      return Images.blockImage!;
    }

    switch (platform.dangerPlatformType) {
      case null:
        return Images.blockImage!;
      case DangerPlatformType.longSpikeUp:
        return Images.longSpikeImage!;
      case DangerPlatformType.smallSpikeUp:
        return Images.smallSpikeImage!;
      case DangerPlatformType.longSpikeDown:
        return Images.longSpikeImage!;
      case DangerPlatformType.smallSpikeDown:
        return Images.smallSpikeImage!;
      case DangerPlatformType.longSpikeLeft:
        return Images.longSpikeImage!;
      case DangerPlatformType.smallSpikeLeft:
        return Images.smallSpikeImage!;
      case DangerPlatformType.longSpikeRight:
        return Images.longSpikeImage!;
      case DangerPlatformType.smallSpikeRight:
        return Images.smallSpikeImage!;
    }
  }

  void _drawRamp(Canvas canvas, RampPlatform platform, Paint paint) {
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

import 'dart:ui' as ui;

import 'package:circle_jump/Background/Cloud/cloud.dart';
import 'package:circle_jump/Models/game.dart';
import 'package:circle_jump/images.dart';
import 'package:circle_jump/utils.dart';
import 'package:flutter/material.dart';

class CloudPainter extends CustomPainter {
  final List<Cloud> clouds;

  CloudPainter({required this.clouds});

  @override
  void paint(Canvas canvas, Size size) {
    if (Images.cloudImage == null) {
      return;
    }
    final center = game.circleCenter;
    final centerX = center.centerX;
    final centerY = center.centerY;
    final radius = center.radius;

    for (final cloud in clouds) {
      final x = cloud.calculateX(centerX, radius);
      final y = cloud.calculateY(centerY, radius);
      _drawCloudImage(canvas, Offset(x, y), cloud, Images.cloudImage!);
    }
  }

  void _drawCloudImage(
      Canvas canvas, Offset position, Cloud cloud, ui.Image image) {
    final paint = Paint()
      ..color = Color.fromARGB((cloud.opacity * 255).toInt(), 255, 255, 255);
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(cloud.angle + degreesToRadians(90));
    canvas.translate(-position.dx, -position.dy);
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromCenter(
        center: position,
        width: cloud.size * 1.5,
        height: cloud.size * 0.75,
      ),
      paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

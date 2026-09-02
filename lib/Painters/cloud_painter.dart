import 'dart:ui' as ui;

import 'package:circle_jump/Background/Cloud/cloud.dart';
import 'package:circle_jump/images.dart';
import 'package:flutter/material.dart';

class CloudPainter extends CustomPainter {
  final List<Cloud> clouds;

  CloudPainter({required this.clouds});

  @override
  void paint(Canvas canvas, Size size) {
    if (Images.cloudImage == null) {
      return;
    }

    for (final cloud in clouds) {
      _drawCloudImage(
        canvas,
        Offset(cloud.x, cloud.y),
        cloud,
        Images.cloudImage!,
      );
    }
  }

  void _drawCloudImage(
      Canvas canvas, Offset position, Cloud cloud, ui.Image image) {
    final paint = Paint()
      ..color = Color.fromARGB((cloud.opacity * 255).toInt(), 255, 255, 255);
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

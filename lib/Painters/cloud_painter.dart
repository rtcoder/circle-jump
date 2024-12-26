import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../Background/Cloud/cloud.dart';
import '../utils.dart';

class CloudPainter extends CustomPainter {
  final List<Cloud> clouds;
  final ui.Image cloudImage; // Obraz chmury

  CloudPainter({required this.clouds, required this.cloudImage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = getCenterOfCircle(size);
    final centerX = center.centerX;
    final centerY = center.centerY;
    final radius = center.radius;

    for (final cloud in clouds) {
      final x = cloud.calculateX(centerX, radius);
      final y = cloud.calculateY(centerY, radius);
      _drawCloudImage(canvas, Offset(x, y), cloud.size);
    }
  }

  void _drawCloudImage(Canvas canvas, Offset position, double size) {
    canvas.drawImageRect(
      cloudImage,
      Rect.fromLTWH(0, 0, cloudImage.width.toDouble(), cloudImage.height.toDouble()),
      Rect.fromCenter(
        center: position,
        width: size * 1.5, // Szerokość obrazka
        height: size * 0.75, // Wysokość obrazka
      ),
      Paint(),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Zawsze odświeżaj, gdy zmieniają się chmury
  }
}

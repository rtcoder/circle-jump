import 'package:circle_jump/images.dart';
import 'package:flutter/material.dart';

import '../Background/Cloud/cloud.dart';
import '../utils.dart';

class CloudPainter extends CustomPainter {
  final List<Cloud> clouds;

  CloudPainter({required this.clouds});

  @override
  void paint(Canvas canvas, Size size) {
    final center = getCenterOfCircle(size);
    final centerX = center.centerX;
    final centerY = center.centerY;
    final radius = center.radius;

    for (final cloud in clouds) {
      final x = cloud.calculateX(centerX, radius);
      final y = cloud.calculateY(centerY, radius);
      _drawCloudImage(canvas, Offset(x, y), cloud.size, cloud.opacity);
    }
  }

  void _drawCloudImage(
      Canvas canvas, Offset position, double size, double opacity) {
    final paint = Paint()
      ..color = Color.fromARGB((opacity * 255).toInt(), 255, 255, 255);

    canvas.drawImageRect(
      Images.cloudImage!,
      Rect.fromLTWH(0, 0, Images.cloudImage!.width.toDouble(),
          Images.cloudImage!.height.toDouble()),
      Rect.fromCenter(
        center: position,
        width: size * 1.5,
        height: size * 0.75,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

import 'package:flutter/material.dart';

import '../Background/Cloud/cloud.dart';
import '../utils.dart';

class CloudPainter extends CustomPainter {
  final List<Cloud> clouds;

  CloudPainter({required this.clouds});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    var center = getCenterOfCircle(size);
    final centerX = center.centerX;
    final centerY = center.centerY;
    final radius = center.radius;
    for (final cloud in clouds) {
      double x = cloud.calculateX(centerX, radius);
      double y = cloud.calculateY(centerY, radius);
      final offset = Offset(x, y);
      canvas.drawCircle(offset, 20, paint); // Środek chmury
      canvas.drawCircle(offset.translate(-30, 0), 15, paint); // Lewa część
      canvas.drawCircle(offset.translate(30, 0), 15, paint); // Prawa część
      canvas.drawCircle(offset.translate(0, -10), 10, paint); // Górna część
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

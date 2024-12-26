import 'dart:math';

import 'package:flutter/material.dart';

import '../utils.dart';

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    var center = getCenterOfCircle(size);
    final centerX = center.centerX;
    final centerY = center.centerY;
    final radius = center.radius;
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

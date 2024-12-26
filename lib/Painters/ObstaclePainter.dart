import 'dart:math';

import 'package:circle_jump/Obstacle.dart';
import 'package:flutter/material.dart';

class ObstaclePainter extends CustomPainter {
  final List<Obstacle> obstacles; // Lista pozycji przeszkód

  ObstaclePainter({required this.obstacles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;


    final maxSize = max(size.width, size.height);
    final radius = maxSize; // Promień okręgu = wysokość ekranu

    // Środek okręgu
    final centerX = size.width / 2;
    final centerY = size.height / 2 + radius;

    for (final obstacle in obstacles) {
      final obstacleX = centerX + radius * cos(obstacle.angle);
      final obstacleY = centerY + radius * sin(obstacle.angle);

      canvas.drawCircle(Offset(obstacleX, obstacleY), 10, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Zawsze przerysowuj, gdy zmienia się pozycja przeszkód
  }
}

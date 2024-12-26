import 'package:circle_jump/Obstacles/obstacle.dart';
import 'package:flutter/material.dart';

import '../Obstacles/obstacle_type.dart';
import '../utils.dart';

class ObstaclePainter extends CustomPainter {
  final List<Obstacle> obstacles;

  ObstaclePainter({required this.obstacles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    var center = getCenterOfCircle(size);
    final centerX = center.centerX;
    final centerY = center.centerY;
    final radius = center.radius;

    for (final obstacle in obstacles) {
      double x = obstacle.calculateX(centerX, radius);
      double y = obstacle.calculateY(centerY, radius);

      if (obstacle.type == ObstacleType.ground) {
        paint.color = Colors.green;
      } else if (obstacle.type == ObstacleType.air) {
        paint.color = Colors.black;
      } else if (obstacle.type == ObstacleType.oscillating) {
        paint.color = Colors.blue;
      }

      canvas.drawCircle(Offset(x, y), 10, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return obstacles.any((o) =>
        o.angle !=
        (oldDelegate as ObstaclePainter).obstacles[obstacles.indexOf(o)].angle);
  }
}

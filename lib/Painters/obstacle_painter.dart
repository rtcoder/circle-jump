import 'package:circle_jump/Obstacles/obstacle.dart';
import 'package:circle_jump/game.dart';
import 'package:flutter/material.dart';

import '../Obstacles/obstacle_type.dart';

class ObstaclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final obstacle in game.obstacles) {
      drawSingleObstacle(canvas, paint, obstacle);
    }
  }

  void drawSingleObstacle(Canvas canvas, Paint paint, Obstacle obstacle) {
    final center = game.circleCenter;
    final size = game.screenSize;
    double x = obstacle.calculateX(center.centerX, center.radius);
    double y = obstacle.calculateY(center.centerY, center.radius);

    if (x < -10 || y < -10 || x > size.width + 10 || y > size.height + 10) {
      return;
    }

    if (obstacle.type == ObstacleType.ground) {
      paint.color = Colors.green;
    } else if (obstacle.type == ObstacleType.air) {
      paint.color = Colors.black;
    } else if (obstacle.type == ObstacleType.oscillating) {
      paint.color = Colors.blue;
    }

    canvas.drawCircle(Offset(x, y), 10, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

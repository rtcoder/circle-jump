import 'dart:math';

import 'game.dart';
import '../utils.dart';
import '../Enums/obstacle_type.dart';

class Obstacle {
  double angle;
  final ObstacleType type;
  double oscillationOffset = 0;
  double airHeight = 0;

  get x {
    final center = game.circleCenter;
    final radius = calculateRadius(center.radius);
    return getXPosOnCircle(center.centerX, radius, angle);
  }

  get y {
    final center = game.circleCenter;
    final radius = calculateRadius(center.radius);
    return getYPosOnCircle(center.centerY, radius, angle);
  }

  Obstacle({
    required this.angle,
    required this.type,
  }) {
    airHeight =
        (type == ObstacleType.air) ? Random().nextDouble() * 100 + 50 : 0;
  }

  void move(double delta) {
    angle -= delta;

    angle %= 2 * pi;

    if (type == ObstacleType.oscillating) {
      oscillationOffset = cos(angle * 20) * 50;
    }
  }

  double calculateRadius(double radius) {
    if (type == ObstacleType.air) {
      return radius + airHeight;
    }

    if (type == ObstacleType.oscillating) {
      return radius - oscillationOffset;
    }

    return radius;
  }
}

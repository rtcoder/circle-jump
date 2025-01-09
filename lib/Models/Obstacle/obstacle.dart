import 'dart:math';

import 'package:circle_jump/Enums/obstacle_type.dart';
import 'package:circle_jump/Models/game.dart';
import 'package:circle_jump/Models/movable.dart';
import 'package:circle_jump/utils.dart';

class Obstacle extends Movable {
  double angle;
  double angleDeg;
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
    required this.angleDeg,
    required this.type,
  }) {
    airHeight =
        (type == ObstacleType.air) ? Random().nextDouble() * 100 + 50 : 0;
  }

  @override
  void move(double delta) {
    angle = updateAngle(angle, delta);
    angleDeg = updateAngleDeg(angleDeg, delta);

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

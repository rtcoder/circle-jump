import 'dart:math';
import 'obstacle_type.dart';

class Obstacle {
  double angle;
  final ObstacleType type;
  double oscillationOffset = 0;
  double airHeight = 0;

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

  double _calculateRadius(double radius) {
    if (type == ObstacleType.air) {
      return radius + airHeight;
    }

    if (type == ObstacleType.oscillating) {
      return radius - oscillationOffset;
    }

    return radius;
  }

  double calculateX(double centerX, double radius) {
    return centerX + _calculateRadius(radius) * cos(angle);
  }

  double calculateY(double centerY, double radius) {
    return centerY + _calculateRadius(radius) * sin(angle);
  }
}

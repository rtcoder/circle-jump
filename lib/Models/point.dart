import 'dart:math';

import 'package:circle_jump/Models/movable.dart';

import '../utils.dart';
import 'game.dart';

class Point extends Movable {
  double angle;
  double airHeight;
  double _oscillationDirection = 1;
  double oscillationOffset = 0;
  final double radius = 10;

  Point({required this.angle, this.airHeight = 0});

  get x {
    final center = game.circleCenter;
    return getXPosOnCircle(
        center.centerX, _calculateRadius(center.radius), angle);
  }

  get y {
    final center = game.circleCenter;
    return getYPosOnCircle(
        center.centerY, _calculateRadius(center.radius), angle);
  }

  @override
  void move(double delta) {
    angle=updateAngle(angle, delta);
    oscillationOffset += _oscillationDirection * 0.5;
    if (oscillationOffset > 10 || oscillationOffset < -10) {
      _oscillationDirection *= -1;
    }
  }

  double _calculateRadius(double radius) {
    return radius - oscillationOffset;
  }

  @override
  String toString() {
    return 'Point(angle: $angle, airHeight: $airHeight)';
  }
}

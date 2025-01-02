import 'dart:math';

import 'package:circle_jump/Models/movable.dart';

import '../utils.dart';
import 'game.dart';

class Point extends Movable {
  double angle;
  double airHeight;
  final double radius = 10;

  Point({required this.angle, this.airHeight = 0});

  get x {
    final center = game.circleCenter;
    return getXPosOnCircle(center.centerX, center.radius + radius, angle);
  }

  get y {
    final center = game.circleCenter;
    return getYPosOnCircle(center.centerY, center.radius + radius, angle);
  }

  @override
  void move(double delta) {
    angle -= delta;

    angle %= 2 * pi;
  }

  @override
  String toString() {
    return 'Point(angle: $angle, airHeight: $airHeight)';
  }
}

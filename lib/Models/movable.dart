import 'dart:math';

import 'package:circle_jump/utils.dart';

abstract class Movable {
  void move(double delta);

  double updateAngle(double angle, double delta) {
    return (angle - delta) % (2 * pi);
  }

  double updateAngleDeg(double angle, double delta) {
    return (angle - radiansToDegrees(delta));
  }
}

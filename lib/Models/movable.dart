import 'dart:math';

abstract class Movable {
  void move(double delta);

  double updateAngle(double angle, double delta) {
    return (angle - delta) % (2 * pi);
  }
}

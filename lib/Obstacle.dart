import 'dart:math';

class Obstacle {
  double angle;
  final double speed;
  final bool clockwise;

  Obstacle({required this.angle, required this.speed, required this.clockwise});

  void updateAngle() {
    if (clockwise) {
      angle += speed;
    } else {
      angle -= speed;
    }

    angle %= 2 * pi;
  }
}
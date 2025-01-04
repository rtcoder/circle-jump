import 'package:circle_jump/Models/movable.dart';

import '../utils.dart';
import 'game.dart';

class Coin extends Movable {
  double angle;
  double angleDeg;
  double airHeight;
  double _oscillationDirection = 1;
  double oscillationOffset = 0;
  int animationFrame = 0;
  int _animationCounter = 0;
  final int _animationSpeed = 5;
  final double radius = 15;

  Coin({required this.angle, required this.angleDeg, this.airHeight = 0});

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
    angle = updateAngle(angle, delta);
    angleDeg = updateAngleDeg(angleDeg, delta);
    oscillationOffset += _oscillationDirection * 0.5;
    if (oscillationOffset > 10 || oscillationOffset < -10) {
      _oscillationDirection *= -1;
    }
    updateAnimation();
  }

  void updateAnimation() {
    _animationCounter++;

    if (_animationCounter >= _animationSpeed) {
      animationFrame = (animationFrame + 1) % 16;
      _animationCounter = 0;
    }
  }

  double _calculateRadius(double radius) {
    return radius - oscillationOffset;
  }

  @override
  String toString() {
    return 'Coin(angle: $angle, airHeight: $airHeight)';
  }
}

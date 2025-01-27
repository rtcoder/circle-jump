import 'package:circle_jump/Models/Coin/coin_oscillation.dart';
import 'package:circle_jump/Models/game.dart';
import 'package:circle_jump/Models/movable.dart';
import 'package:circle_jump/utils.dart';

class Coin extends Movable {
  double angle;
  double angleDeg;
  double airHeight;
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
    _updateAnimation();
  }

  void _updateAnimation() {
    _animationCounter++;

    if (_animationCounter >= _animationSpeed) {
      animationFrame = (animationFrame + 1) % 16;
      _animationCounter = 0;
    }
  }

  double _calculateRadius(double radius) {
    return radius + airHeight - CoinOscillation.oscillationOffset;
  }

  @override
  String toString() {
    return 'Coin(angle: $angle, airHeight: $airHeight)';
  }
}

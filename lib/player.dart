import 'package:circle_jump/game.dart';

class Player {
  final int _jumpSpeed = 15;
  final int _jumpSize = 200;
  bool _isJumping = false;
  int _jumpDirection = 1;
  double playerY = 0;
  double jumpProgress = 0;
  double playerAngle = 0;
  final playerRadius = 20.0;
  final radius = 20.0;

  void update() {
    _incrementPlayerAngle();
    _processJump();
  }

  void _processJump() {
    if (!_isJumping) {
      return;
    }
    if (jumpProgress == 0) {
      _jumpDirection = 1;
    }
    if (jumpProgress >= _jumpSize) {
      _jumpDirection = -1;
    }
    jumpProgress += (_jumpDirection * _jumpSpeed);

    if (jumpProgress <= 0) {
      jumpProgress = 0;
      _isJumping = false;
    }
  }

  void jump() {
    if (_isJumping) {
      return;
    }
    _isJumping = true;
  }

  void _incrementPlayerAngle() {
    playerAngle += _calculatePlayerAngleDelta() * (_isJumping ? 3 : 1);
  }

  double _calculatePlayerAngleDelta() {
    return game.circleAngleDelta * game.circleRadius / radius;
  }
}

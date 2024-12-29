import 'package:circle_jump/game.dart';

enum JumpState { none, single, double }

class Player {
  final int _jumpSpeed = 15;
  final int _jumpSize = 200;
  JumpState _jumpState = JumpState.none;
  int _jumpDirection = 1;
  double playerY = 0;
  double jumpProgress = 0;
  double playerAngle = 0;
  final radius = 20.0;

  bool get withFire {
    return _jumpState != JumpState.none && _jumpDirection == 1;
  }

  void update() {
    _incrementPlayerAngle();
    _processJump();
  }

  void _processJump() {
    if (_jumpState == JumpState.none) {
      return;
    }
    if (jumpProgress == 0) {
      _jumpDirection = 1;
    }
    if (_shouldReverseJump()) {
      _jumpDirection = -1;
    }
    jumpProgress += (_jumpDirection * _jumpSpeed);

    if (jumpProgress <= 0) {
      jumpProgress = 0;
      _jumpState = JumpState.none;
    }
  }

  bool _shouldReverseJump() {
    if (_jumpState == JumpState.double && jumpProgress >= _jumpSize * 1.5) {
      return true;
    }
    if (_jumpState == JumpState.single && jumpProgress >= _jumpSize) {
      return true;
    }
    return false;
  }

  void jump() {
    if (_jumpState == JumpState.double) {
      return;
    }
    if (_jumpState == JumpState.single) {
      _jumpState = JumpState.double;
      _jumpDirection = 1;
      return;
    }
    _jumpState = JumpState.single;
  }

  void _incrementPlayerAngle() {
    playerAngle +=
        _calculatePlayerAngleDelta() * (_jumpState != JumpState.none ? 3 : 1);
  }

  double _calculatePlayerAngleDelta() {
    return game.circleAngleDelta * game.circleRadius / radius;
  }
}

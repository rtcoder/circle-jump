import 'package:circle_jump/game.dart';

class Player {
  double playerY = 0;
  bool isJumping = false;
  double jumpSize = 200;
  final jumpDurationMs = 500;
  double playerAngle = 0;
  final playerRadius = 20.0;
  final radius = 20.0;

  void update() {
    _incrementPlayerAngle();
  }

  void _incrementPlayerAngle() {
    playerAngle += _calculatePlayerAngleDelta() * (isJumping ? 3 : 1);
  }

  double _calculatePlayerAngleDelta() {
    return game.circleAngleDelta * game.circleRadius / playerRadius;
  }
}


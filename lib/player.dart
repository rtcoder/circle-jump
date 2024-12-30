import 'package:circle_jump/game.dart';
import 'package:circle_jump/player_platform.dart';

class Player {
  double velocityY = 0;
  final double jumpPower = -12;
  bool onGround = true;
  double playerY = 0;
  double playerAngle = 0;
  final radius = 20.0;
  bool canDoubleJump = false;
  final PlayerPlatform playerPlatform = PlayerPlatform();

  void update() {
    _incrementPlayerAngle();
    onGround = false;
    double newY = playerY;
    velocityY += game.gravity;
    newY -= velocityY;


    if (velocityY >= 0) {
      final onAnyPlatform = playerPlatform.isOnAnyPlatform(newY);
      if (onAnyPlatform != null) {
        velocityY = 0;
        newY = onAnyPlatform.height+radius;
        onGround = true;
      }
    }
    if (newY <= 0) {
      velocityY = 0;
      newY = 0;
      onGround = true;
    }
    playerY = newY;
  }

  void jump() {
    if (onGround) {
      velocityY = jumpPower;
      canDoubleJump = true; // Zezwól na podwójny skok
    } else if (canDoubleJump) {
      velocityY = jumpPower;
      canDoubleJump = false; // Wykorzystaj podwójny skok
    }
  }

  void _incrementPlayerAngle() {
    playerAngle += _calculatePlayerAngleDelta();
  }

  double _calculatePlayerAngleDelta() {
    return game.circleAngleDelta * game.circleRadius / radius;
  }
}

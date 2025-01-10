import 'package:circle_jump/Models/game.dart';
import 'package:circle_jump/Services/player_platform_collision.dart';
import 'package:flutter/material.dart';

class Player {
  double _velocityY = 0;
  bool _onGround = true;
  double playerY = 0;
  double playerAngle = 0;
  bool _canDoubleJump = false;
  int score = 0;
  final double radius = 20.0;
  final double _jumpPower = -12;
  final PlayerPlatformCollision playerPlatformCollision =
      PlayerPlatformCollision();

  double get playerX {
    return game.screenSize.width / 2;
  }

  double get playerYAbsolutePosition {
    return (game.screenSize.height / 2) - playerY;
  }

  void restart() {
    _velocityY = 0;
    _onGround = true;
    playerY = 0;
    playerAngle = 0;
    _canDoubleJump = false;
    score = 0;
  }

  void update(BuildContext context) {
    _incrementPlayerAngle();
    _updatePlayerY(context);
  }

  void jump() {
    if (_onGround) {
      _velocityY = _jumpPower;
      _canDoubleJump = true; // Zezwól na podwójny skok
    } else if (_canDoubleJump) {
      _velocityY = _jumpPower;
      _canDoubleJump = false; // Wykorzystaj podwójny skok
    }
  }

  void _updatePlayerY(BuildContext context) {
    _onGround = false;
    double newY = playerY;

    _velocityY += game.gravity;
    newY -= _velocityY;

    final platformCollision = playerPlatformCollision.isOnAnyPlatform(newY);
    if (platformCollision != null) {
      if (platformCollision.isDanger) {
        game.isGameOver = true;
        Navigator.pushNamed(context, '/game-over', arguments: score);
        return;
      }
      if (_velocityY >= 0) {
        if (playerY > platformCollision.height) {
          _velocityY = 0;
          newY = platformCollision.height + radius;
          _onGround = true;
        }
      } else {
        if (playerY < platformCollision.height) {
          _velocityY = -_velocityY * 0.5;
          newY = platformCollision.height - radius;
        }
      }
    }

    if (newY <= 0) {
      _velocityY = 0;
      newY = 0;
      _onGround = true;
    }

    playerY = newY;
  }

  void _incrementPlayerAngle() {
    playerAngle += _calculatePlayerAngleDelta();
  }

  double _calculatePlayerAngleDelta() {
    return game.gameCircle.angleDelta * game.gameCircle.radius / radius;
  }
}

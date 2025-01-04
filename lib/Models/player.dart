import 'package:circle_jump/Models/game.dart';
import 'package:circle_jump/Models/player_platform.dart';

class Player {
  double _velocityY = 0;
  bool _onGround = true;
  double playerY = 0;
  double playerAngle = 0;
  bool _canDoubleJump = false;
  int score = 0;
  final double radius = 20.0;
  final double _jumpPower = -12;
  final PlayerPlatform playerPlatform = PlayerPlatform();

  double get playerX {
    return game.screenSize.width / 2;
  }

  double get playerYAbsolutePosition {
    return (game.screenSize.height / 2) - playerY;
  }

  void update() {
    _incrementPlayerAngle();
    _updatePlayerY();
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

  void _updatePlayerY() {
    _onGround = false;
    double newY = playerY;

    _velocityY += game.gravity;
    newY -= _velocityY;

    final platformCollision = playerPlatform.isOnAnyPlatform(newY);
    if (platformCollision != null) {
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
    return game.circleAngleDelta * game.circleRadius / radius;
  }
}

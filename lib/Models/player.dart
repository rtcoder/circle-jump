import 'package:circle_jump/Models/game.dart';
import 'package:circle_jump/Models/player_platform.dart';
import 'package:circle_jump/Models/player_point.dart';

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
    _updatePlayerX();
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

  void _updatePlayerX() {
    _onGround = false;
    double newY = playerY;
    _velocityY += game.gravity;
    newY -= _velocityY;

    if (_velocityY >= 0) {
      final onAnyPlatform = playerPlatform.isOnAnyPlatform(newY);
      if (onAnyPlatform != null) {
        _velocityY = 0;
        newY = onAnyPlatform.height + radius;
        _onGround = true;
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

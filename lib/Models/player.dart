import 'package:circle_jump/Models/game.dart';
import 'package:circle_jump/Models/World/world.dart';

class PlayerPhysics {
  final double gravity;
  final double jumpPower;
  final double bounceJumpPower;
  final double ceilingBounceFactor;

  const PlayerPhysics({
    required this.gravity,
    required this.jumpPower,
    this.bounceJumpPower = -18,
    required this.ceilingBounceFactor,
  });

  static const standard = PlayerPhysics(
    gravity: 0.5,
    jumpPower: -12,
    ceilingBounceFactor: 0.5,
  );
}

class Player {
  double _velocityY = 0;
  bool _onGround = true;
  double playerY = 0;
  double playerAngle = 0;
  double speedMultiplier = 1;
  bool _canDoubleJump = false;
  int score = 0;
  final PlayerPhysics physics;
  final double radius = 20.0;

  Player({this.physics = PlayerPhysics.standard});

  double get velocityY {
    return _velocityY;
  }

  double get playerX {
    return game.world.playerScreenX(game.screenSize.width);
  }

  double get playerYAbsolutePosition {
    return game.world.terrainBaselineY(game.screenSize.height) - playerY;
  }

  void restart() {
    _velocityY = 0;
    _onGround = true;
    playerY = 0;
    playerAngle = 0;
    speedMultiplier = 1;
    _canDoubleJump = false;
    score = 0;
  }

  void update(double frameScale) {
    _incrementPlayerAngle();
    _updatePlayerY(frameScale);
  }

  void jump() {
    if (_onGround) {
      _velocityY = physics.jumpPower;
      _canDoubleJump = true;
    } else if (_canDoubleJump) {
      _velocityY = physics.jumpPower;
      _canDoubleJump = false;
    }
  }

  void _updatePlayerY(double frameScale) {
    _onGround = false;
    double newY = playerY;

    _velocityY += physics.gravity * frameScale;
    newY -= _velocityY * frameScale;

    final terrainHeight = game.world.terrainHeightUnderPlayer;
    if (newY <= terrainHeight) {
      _velocityY = 0;
      newY = terrainHeight;
      _onGround = true;
      speedMultiplier = 1;
    }

    playerY = newY;
  }

  void _incrementPlayerAngle() {
    playerAngle +=
        (game.gameCircle.movementDistanceDelta * World.pixelsPerMeter) / radius;
  }
}

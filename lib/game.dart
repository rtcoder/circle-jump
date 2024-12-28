import 'package:circle_jump/platform.dart';
import 'package:circle_jump/player.dart';

import 'Obstacles/obstacle.dart';
import 'Obstacles/obstacle_generator.dart';

class _Game {
  double distance = 0;
  final double baseCircleAngleDelta = 0.002;
  double circleAngleDelta = 0.002;
  double circleAngle = 0;
  final circleRadius = 1000.0;
  List<PlatformModel> platforms = generatePlatforms(10);
  List<Obstacle> obstacles = obstacleGenerator(10);
  Player player = Player();

  void update() {
    _updateDistance();
    _updatePlatforms();
    _incrementCircleAngle();
    _updateObstacles();
    player.update();
    _updateGameSpeed();
  }

  void _updateDistance() {
    distance += circleAngleDelta * player.playerRadius;
  }

  void _updateGameSpeed() {
    if (distance <= 100) {
      return;
    }
    double divisionResult = distance / 100;
    incrementCircleAngleDelta(divisionResult.floor());
  }

  void _incrementCircleAngle() {
    circleAngle += circleAngleDelta;
  }

  void incrementCircleAngleDelta(int value) {
    circleAngleDelta = baseCircleAngleDelta * ((value / 10) + 1) ;
  }

  void _updatePlatforms() {
    for (final platform in platforms) {
      platform.move(circleAngleDelta);
    }

    platforms.removeWhere((platform) => platform.angle < 0.1);

    if (platforms.length <= 2) {
      platforms.addAll(generatePlatforms(10));
    }
  }

  void _updateObstacles() {
    for (var obstacle in game.obstacles) {
      obstacle.move(circleAngleDelta);
    }
  }
}

final game = _Game();

import 'package:circle_jump/platform.dart';
import 'package:circle_jump/player.dart';

import 'Obstacles/obstacle.dart';
import 'Obstacles/obstacle_generator.dart';

class _Game {
  double distance = 0;
  double circleAngleDelta = 0.001;
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
  }

  void _updateDistance() {
    distance += circleAngleDelta * player.playerRadius;
  }

  void _incrementCircleAngle() {
    circleAngle += circleAngleDelta;
  }

  void incrementCircleAngleDelta() {
    circleAngleDelta += 0.001;
  }

  void _updatePlatforms() {
    for (final platform in platforms) {
      platform.move();
    }

    platforms.removeWhere((platform) => platform.angle < 0.1);

    if (platforms.length <= 2) {
      platforms.addAll(generatePlatforms(10));
    }
  }

  void _updateObstacles() {
    for (var obstacle in game.obstacles) {
      obstacle.updateAngle();
    }
  }
}

final game = _Game();

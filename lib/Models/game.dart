import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/movable.dart';
import 'package:circle_jump/Models/player.dart';
import 'package:circle_jump/Models/player_point.dart';
import 'package:circle_jump/Models/point.dart';
import 'package:flutter/material.dart';

import '../Generators/obstacle_generator.dart';
import '../Generators/platform_generator.dart';
import '../Generators/point_generator.dart';
import 'circle_center.dart';
import 'obstacle.dart';

class _Game {
  final double gravity = 0.5;
  double distance = 0;
  final double _baseCircleAngleDelta = 0.005;
  final double _maxCircleAngleDelta = 0.015;
  double circleAngleDelta = 0.001;
  double circleAngle = 0;
  final circleRadius = 1000.0;
  late List<PlatformModel> platforms;
  late List<Obstacle> obstacles;
  late List<Point> points;
  Player player = Player();
  late Size screenSize;
  late CircleCenter circleCenter;
  bool gameInitialized = false;

  String get distanceHuman {
    if (distance < 1000) {
      return '${distance.toInt()}m';
    }
    return '${(distance / 1000).toStringAsFixed(2)}km';
  }

  void updateScreenSize(Size newVal) {
    screenSize = newVal;
    circleCenter = CircleCenter.getCenterOfCircle(screenSize);
  }

  void init() {
    if (gameInitialized) {
      return;
    }

    platforms = generatePlatforms(10);
    obstacles = obstacleGenerator(10);
    points = generatePoints(10);
    gameInitialized = true;
  }

  void update() {
    _updateDistance();
    _moveElements();
    _incrementCircleAngle();
    player.update();
    _collectPoints();
    _updateGameSpeed();
  }
  void _collectPoints() {
    final List<Point> collectedPoints = [];

    for (final point in game.points) {
      if (PlayerPoint.isPointCollected(point, game.player)) {
        collectedPoints.add(point);
        game.player.score += 1;
      }
    }

    game.points.removeWhere((point) => collectedPoints.contains(point));
  }
  void _updateDistance() {
    distance += circleAngleDelta * player.radius;
  }

  void _updateGameSpeed() {
    if (distance > 10 && circleAngleDelta < _maxCircleAngleDelta) {
      // circleAngleDelta = _baseCircleAngleDelta * (1 + (distance / 1000) * 2);
    }
  }

  void _incrementCircleAngle() {
    circleAngle += circleAngleDelta;
  }

  void _moveElements() {
    final List<Movable> elements = [...platforms, ...obstacles, ...points];
    for (final element in elements) {
      element.move(circleAngleDelta);
    }
  }
}

final game = _Game();

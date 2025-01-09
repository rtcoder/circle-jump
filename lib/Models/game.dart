import 'package:circle_jump/Models/circle_center.dart';
import 'package:circle_jump/Models/movable.dart';
import 'package:circle_jump/Models/player.dart';
import 'package:circle_jump/Models/world.dart';
import 'package:circle_jump/Models/world_part.dart';
import 'package:circle_jump/utils.dart';
import 'package:flutter/material.dart';

class _Game {
  final double gravity = 0.5;
  double distance = 0;
  final double _baseCircleAngleDelta = 0.002;
  final double _maxCircleAngleDelta = 0.005;
  double circleAngleDelta = 0.002;
  double circleAngle = 0;
  double circleAngleDeg = 0;
  double lastWorldUpdateAngleDeg = 0;
  final circleRadius = 1000.0;
  Player player = Player();
  late Size screenSize;
  late CircleCenter circleCenter;
  bool gameInitialized = false;
  final CoinCollector coinCollector = CoinCollector();
  final PlatformCollector platformCollector = PlatformCollector();
  final ObstacleCollector obstacleCollector = ObstacleCollector();

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
    _updateWorld(-85, 90);
    gameInitialized = true;
  }

  void update() {
    _updateDistance();
    _moveElements();
    _incrementCircleAngle();
    player.update();
    _updateGameSpeed();
    _updateWorldCycle();
  }

  void _updateWorld([double startAngleDeg = 5, double endAngleDeg = 90]) {
    final worldPart = generateWorldPart(startAngleDeg, endAngleDeg);
    coinCollector.collectAll(worldPart.coins);
    platformCollector.collectAll(worldPart.platforms);
    obstacleCollector.collectAll(worldPart.obstacles);

    coinCollector.removeUnnecessaryItems();
    platformCollector.removeUnnecessaryItems();
    obstacleCollector.removeUnnecessaryItems();

    print(platformCollector.items.length);
  }

  void _updateWorldCycle() {
    if (circleAngleDeg - lastWorldUpdateAngleDeg > 90) {
      lastWorldUpdateAngleDeg = circleAngleDeg;
      _updateWorld();
    }
  }

  void _updateDistance() {
    distance += circleAngleDelta * player.radius;
  }

  void _updateGameSpeed() {
    if (distance > 10 && circleAngleDelta < _maxCircleAngleDelta) {
      circleAngleDelta = _baseCircleAngleDelta * (1 + (distance / 1000) * 2);
    }
  }

  void _incrementCircleAngle() {
    circleAngle += circleAngleDelta;
    circleAngleDeg = radiansToDegrees(circleAngle);
  }

  void _moveElements() {
    final List<Movable> elements = [
      ...platformCollector.items,
      ...obstacleCollector.items,
      ...coinCollector.items
    ];
    for (final element in elements) {
      element.move(circleAngleDelta);
    }
  }
}

final game = _Game();

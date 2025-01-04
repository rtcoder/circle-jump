import 'package:circle_jump/Generators/coin_generator.dart';
import 'package:circle_jump/Models/Coin/coin_collector.dart';
import 'package:circle_jump/Models/Obstacle/obstacle_collector.dart';
import 'package:circle_jump/Models/Platform/platform_collector.dart';
import 'package:circle_jump/Models/circle_center.dart';
import 'package:circle_jump/Models/movable.dart';
import 'package:circle_jump/Models/player.dart';
import 'package:flutter/material.dart';

class _Game {
  final double gravity = 0.5;
  double distance = 0;
  final double _baseCircleAngleDelta = 0.005;
  final double _maxCircleAngleDelta = 0.015;
  double circleAngleDelta = 0.001;
  double circleAngle = 0;
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

    coinCollector.collectAll(generateCoins(1, 100, 0, 360));
    gameInitialized = true;
  }

  void update() {
    _updateDistance();
    _moveElements();
    _incrementCircleAngle();
    player.update();
    _updateGameSpeed();
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

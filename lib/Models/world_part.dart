import 'dart:math';

import 'package:circle_jump/Models/Coin/coin.dart';
import 'package:circle_jump/Models/Coin/coin_collector.dart';
import 'package:circle_jump/Models/Obstacle/obstacle.dart';
import 'package:circle_jump/Models/Obstacle/obstacle_collector.dart';
import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/Platform/platform_collector.dart';

class WorldPart {
  final CoinCollector coinCollector = CoinCollector();
  final PlatformCollector platformCollector = PlatformCollector();
  final ObstacleCollector obstacleCollector = ObstacleCollector();

  WorldPart({
    List<PlatformModel> platforms = const [],
    List<Coin> coins = const [],
    List<Obstacle> obstacles = const [],
  }) {
    obstacleCollector.collectAll(obstacles);
    platformCollector.collectAll(platforms);
    coinCollector.collectAll(coins);
  }

  void add(WorldPart worldPart) {
    platformCollector.join(worldPart.platformCollector);
    coinCollector.join(worldPart.coinCollector);
    obstacleCollector.join(worldPart.obstacleCollector);
  }

  void removeUnnecessaryItems() {
    coinCollector.removeUnnecessaryItems();
    platformCollector.removeUnnecessaryItems();
    obstacleCollector.removeUnnecessaryItems();
  }

  double getLengthInDegrees() {
    double angleStart = getStartAngleDeg();
    double angleEnd = getEndAngleDeg();

    return angleEnd - angleStart;
  }

  double getStartAngleDeg() {
    double angleStart = double.infinity;

    final platformsList = platformCollector.items;
    final obstaclesList = obstacleCollector.items;
    final coinsList = coinCollector.items;

    final minStartAngle = [
      ...platformsList.map((p) => p.startAngleDeg),
      ...obstaclesList.map((p) => p.angleDeg),
      ...coinsList.map((p) => p.angleDeg),
    ].reduce(min);

    return minStartAngle;
  }

  double getEndAngleDeg() {
    final platformsList = platformCollector.items;
    final obstaclesList = obstacleCollector.items;
    final coinsList = coinCollector.items;

    final maxEndAngle = [
      ...platformsList.map((p) => p.endAngleDeg),
      ...obstaclesList.map((p) => p.angleDeg),
      ...coinsList.map((p) => p.angleDeg),
    ].reduce(max);

    return maxEndAngle;
  }
}

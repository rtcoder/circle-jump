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
    if (platformsList.isNotEmpty) {
      final firstPlatform = platformsList.first;
      if (firstPlatform.startAngleDeg < angleStart) {
        angleStart = firstPlatform.startAngleDeg;
      }
    }

    final obstaclesList = obstacleCollector.items;
    if (obstaclesList.isNotEmpty) {
      final firstObstacle = obstaclesList.first;
      if (firstObstacle.angleDeg < angleStart) {
        angleStart = firstObstacle.angleDeg;
      }
    }

    final coinsList = coinCollector.items;
    if (coinsList.isNotEmpty) {
      final firstCoin = coinsList.first;
      if (firstCoin.angleDeg < angleStart) {
        angleStart = firstCoin.angleDeg;
      }
    }
    return angleStart;
  }

  double getEndAngleDeg() {
    double angleEnd = -double.infinity;

    final platformsList = platformCollector.items;
    if (platformsList.isNotEmpty) {
      final lastPlatform = platformsList.last;
      if (lastPlatform.endAngleDeg > angleEnd) {
        angleEnd = lastPlatform.endAngleDeg;
      }
    }

    final obstaclesList = obstacleCollector.items;
    if (obstaclesList.isNotEmpty) {
      final lastObstacle = obstaclesList.last;
      if (lastObstacle.angleDeg > angleEnd) {
        angleEnd = lastObstacle.angleDeg;
      }
    }

    final coinsList = coinCollector.items;
    if (coinsList.isNotEmpty) {
      final lastCoin = coinsList.last;
      if (lastCoin.angleDeg > angleEnd) {
        angleEnd = lastCoin.angleDeg;
      }
    }

    return angleEnd;
  }
}

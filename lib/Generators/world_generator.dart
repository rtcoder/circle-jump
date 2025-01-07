import 'dart:math';

import 'package:circle_jump/Generators/coin_generator.dart';
import 'package:circle_jump/Generators/platform_generator.dart';
import 'package:circle_jump/Models/Coin/coin.dart';
import 'package:circle_jump/Models/world_part.dart';

final Map<String, WorldPart Function(double startAngleDeg, bool withCoins)>
    _worldParts = {
  'threePlatforms': threePlatforms,
  'platformAndRamp': platformAndRamp,
  'onlyCoins': onlyCoins,
};

WorldPart generateWorldPart(double startAngleDeg, double endAngleDeg) {
  final worldPart = WorldPart(
    platforms: [],
    coins: [],
    obstacles: [],
  );
  String lastWorldName = '';
  String worldName = '';
  double nextStartAngle = startAngleDeg;
  while (nextStartAngle + 6 < endAngleDeg) {
    while (worldName == lastWorldName) {
      worldName = _randomWorldPartKey();
    }
    final randWorldPart = randomWorldPart(nextStartAngle, worldName);
    nextStartAngle = _getWorldPartEndAngleDeg(randWorldPart) + 5;
    lastWorldName = worldName;
    if (nextStartAngle <= endAngleDeg) {
      worldPart.add(randWorldPart);
    }
  }
  return worldPart;
}

double _getWorldPartLengthInDegrees(WorldPart worldPart) {
  double angleStart = _getWorldPartStartAngleDeg(worldPart);
  double angleEnd = _getWorldPartEndAngleDeg(worldPart);

  return angleEnd - angleStart;
}

double _getWorldPartStartAngleDeg(WorldPart worldPart) {
  double angleStart = double.infinity;

  final obstacles = worldPart.obstacles;
  final platforms = worldPart.platforms;
  final coins = worldPart.coins;

  if (platforms.isNotEmpty) {
    final firstPlatform = platforms[0];
    if (firstPlatform.startAngleDeg < angleStart) {
      angleStart = firstPlatform.startAngleDeg;
    }
  }

  if (obstacles.isNotEmpty) {
    final firstObstacle = obstacles[0];
    if (firstObstacle.angleDeg < angleStart) {
      angleStart = firstObstacle.angleDeg;
    }
  }

  if (coins.isNotEmpty) {
    final firstCoin = coins[0];
    if (firstCoin.angleDeg < angleStart) {
      angleStart = firstCoin.angleDeg;
    }
  }
  return angleStart;
}

double _getWorldPartEndAngleDeg(WorldPart worldPart) {
  double angleEnd = -double.infinity;

  final obstacles = worldPart.obstacles;
  final platforms = worldPart.platforms;
  final coins = worldPart.coins;

  if (platforms.isNotEmpty) {
    final lastPlatform = platforms[platforms.length - 1];
    if (lastPlatform.endAngleDeg > angleEnd) {
      angleEnd = lastPlatform.endAngleDeg;
    }
  }

  if (obstacles.isNotEmpty) {
    final lastObstacle = obstacles[obstacles.length - 1];
    if (lastObstacle.angleDeg > angleEnd) {
      angleEnd = lastObstacle.angleDeg;
    }
  }

  if (coins.isNotEmpty) {
    final lastCoin = coins[coins.length - 1];
    if (lastCoin.angleDeg > angleEnd) {
      angleEnd = lastCoin.angleDeg;
    }
  }

  return angleEnd;
}

String _randomWorldPartKey() {
  final keys = _worldParts.keys.toList();
  final randomIndex = Random().nextInt(keys.length);
  final randomKey = keys[randomIndex];
  return randomKey;
}

WorldPart randomWorldPart(double startAngleDeg, String randomKey) {
  final bool withCoins = Random().nextInt(100) % 2 == 0;
  final fn = _worldParts[randomKey]!;
  final WorldPart randomWorldPart = fn(startAngleDeg, withCoins);
  return randomWorldPart;
}

WorldPart threePlatforms(double startAngleDeg, bool withCoins) {
  final platforms = [
    getCurvePlatform(startAngleDeg, 5, 50),
    getCurvePlatform(startAngleDeg + 5, 5, 100),
    getCurvePlatform(startAngleDeg + 10, 5, 150),
  ];

  final List<Coin> coins =
      withCoins ? generateCoinsForCurvePlatforms(platforms) : [];
  return WorldPart(platforms: platforms, coins: coins, obstacles: []);
}

WorldPart platformAndRamp(double startAngleDeg, bool withCoins) {
  final platforms = [
    getRampPlatform(startAngleDeg, 7, 30, 105),
    getCurvePlatform(startAngleDeg + 7, 15, 135),
  ];

  final List<Coin> coins =
      withCoins ? generateCoinsForCurvePlatforms(platforms) : [];
  return WorldPart(platforms: platforms, coins: coins, obstacles: []);
}

WorldPart onlyCoins(double startAngleDeg, bool withCoins) {
  final List<Coin> coins = [
    ...generateCoins(2, 5, startAngleDeg, 5),
    ...generateCoins(2, 60, startAngleDeg + 10, 5),
    ...generateCoins(2, 120, startAngleDeg + 20, 5),
    ...generateCoins(2, 150, startAngleDeg + 30, 5),
  ];
  return WorldPart(platforms: [], coins: coins, obstacles: []);
}

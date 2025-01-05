import 'dart:math';

import 'package:circle_jump/Generators/coin_generator.dart';
import 'package:circle_jump/Generators/platform_generator.dart';
import 'package:circle_jump/Models/world_part.dart';

WorldPart generateWorldPart(double startAngleDeg, double endAngleDeg) {
  final worldPart = WorldPart(
    platforms: [],
    coins: [],
    obstacles: [],
  );

  double nextStartAngle = startAngleDeg;
  while (nextStartAngle + 4 < endAngleDeg) {
    final randWorldPart = randomWorldPart(nextStartAngle);
    nextStartAngle = _getWorldPartEndAngleDeg(randWorldPart) + 3;
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

WorldPart randomWorldPart(double startAngleDeg) {
  final Map<String, WorldPart Function(double startAngleDeg)> worldParts = {
    // 'threePlatformsWithCoins': threePlatformsWithCoins,
    // 'threePlatforms': threePlatforms,
    'platformAndRamp': platformAndRamp,
  };
  final keys = worldParts.keys.toList();
  final randomIndex = Random().nextInt(keys.length);
  final randomKey = keys[randomIndex];
  final WorldPart randomWorldPart = worldParts[randomKey]!(startAngleDeg);
  return randomWorldPart;
}

WorldPart threePlatformsWithCoins(double startAngleDeg) {
  final platforms = [
    getCurvePlatform(startAngleDeg, 5, 50),
    getCurvePlatform(startAngleDeg + 5, 5, 100),
    getCurvePlatform(startAngleDeg + 10, 5, 150),
  ];
  final coins = [
    ...generateCoins(2, 80, startAngleDeg + 1, 3),
    ...generateCoins(2, 130, startAngleDeg + 6, 3),
    ...generateCoins(2, 180, startAngleDeg + 11, 3),
  ];

  return WorldPart(platforms: platforms, coins: coins, obstacles: []);
}

WorldPart threePlatforms(double startAngleDeg) {
  final platforms = [
    getCurvePlatform(startAngleDeg, 5, 50),
    getCurvePlatform(startAngleDeg + 5, 5, 100),
    getCurvePlatform(startAngleDeg + 10, 5, 150),
  ];

  return WorldPart(platforms: platforms, coins: [], obstacles: []);
}

WorldPart platformAndRamp(double startAngleDeg) {
  final platforms = [
    getRampPlatform(startAngleDeg, 7, 30, 105),
    getCurvePlatform(startAngleDeg + 7, 15, 135),
  ];

  return WorldPart(platforms: platforms, coins: [], obstacles: []);
}

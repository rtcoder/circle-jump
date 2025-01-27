import 'dart:math';

import 'package:circle_jump/Enums/danger_platform_type.dart';
import 'package:circle_jump/Enums/direction.dart';
import 'package:circle_jump/Generators/coin_generator.dart';
import 'package:circle_jump/Generators/platform_generator.dart';
import 'package:circle_jump/Models/Coin/coin.dart';
import 'package:circle_jump/Models/Platform/curve_platform.dart';
import 'package:circle_jump/Models/World/world_part.dart';

final Map<String, WorldPart Function(double startAngleDeg, bool withCoins)>
    _worldParts = {
  'threePlatforms': _threePlatforms,
  'platformAndRamp': _platformAndRamp,
  'onlyCoins': _onlyCoins,
  'zigZagPlatforms': _zigZagPlatforms,
  'multiLevelPlatforms': _multiLevelPlatforms,
  'manyFloors': _manyFloors,
};

WorldPart generateWorldPart(double startAngleDeg, double endAngleDeg) {
  final worldPart = WorldPart();
  String lastWorldName = '';
  String worldName = '';
  double nextStartAngle = startAngleDeg;
  while (nextStartAngle + 6 < endAngleDeg) {
    while (worldName == lastWorldName) {
      worldName = _randomWorldPartKey();
    }
    final randWorldPart = _randomWorldPart(nextStartAngle, worldName);
    double worldEndAngleDeg = randWorldPart.getEndAngleDeg();
    nextStartAngle = worldEndAngleDeg + 5;
    lastWorldName = worldName;
    if (nextStartAngle <= endAngleDeg) {
      worldPart.add(randWorldPart);
    }
  }
  return worldPart;
}

String _randomWorldPartKey() {
  final keys = _worldParts.keys.toList();
  final randomIndex = Random().nextInt(keys.length);
  final randomKey = keys[randomIndex];
  return randomKey;
}

WorldPart _randomWorldPart(double startAngleDeg, String randomKey) {
  final bool withCoins = Random().nextInt(100) % 2 == 0;
  final fn = _worldParts[randomKey]!;
  final WorldPart randWorldPart = fn(startAngleDeg, withCoins);
  return randWorldPart;
}

WorldPart _threePlatforms(double startAngleDeg, bool withCoins) {
  final platforms = [
    getCurvePlatform(startAngleDeg, 5, 50),
    getCurvePlatform(startAngleDeg + 5, 5, 100),
    getCurvePlatform(startAngleDeg + 10, 5, 150),
  ];
  final dangerPlatforms = [
    getCurvePlatform(startAngleDeg + 16, 5, 150, dangerPlatformType: DangerPlatformType.smallSpike),
    getCurvePlatform(startAngleDeg + 16, 5, 140, dangerPlatformType: DangerPlatformType.smallSpike, direction: Direction.rotate180),
  ];

  final List<Coin> coins =
      withCoins ? generateCoinsForCurvePlatforms(platforms) : [];
  return WorldPart(platforms: [...platforms,...dangerPlatforms], coins: coins);
}

WorldPart _platformAndRamp(double startAngleDeg, bool withCoins) {
  final platforms = [
    getRampPlatform(startAngleDeg, 7, 30, 105),
    getCurvePlatform(startAngleDeg + 7, 15, 135),
  ];

  final List<Coin> coins =
      withCoins ? generateCoinsForCurvePlatforms(platforms) : [];
  return WorldPart(platforms: platforms, coins: coins);
}

WorldPart _onlyCoins(double startAngleDeg, bool withCoins) {
  final List<Coin> coins = [
    ...generateCoins(2, 5, startAngleDeg, 5),
    ...generateCoins(2, 60, startAngleDeg + 10, 5),
    ...generateCoins(2, 120, startAngleDeg + 20, 5),
    ...generateCoins(2, 150, startAngleDeg + 30, 5),
  ];
  return WorldPart(coins: coins);
}

WorldPart _zigZagPlatforms(double startAngleDeg, bool withCoins) {
  final platforms = [
    getCurvePlatform(startAngleDeg, 15, 100),
    getRampPlatform(startAngleDeg + 14, 6, 100, 150),
    getCurvePlatform(startAngleDeg + 20, 10, 250),
    getCurvePlatform(startAngleDeg + 20, 15, 0,
        dangerPlatformType: DangerPlatformType.smallSpike),
    getRampPlatform(startAngleDeg + 29.5, 15, 247, -270),
  ];

  final List<Coin> coins =
      withCoins ? generateCoinsForCurvePlatforms(platforms) : [];
  return WorldPart(platforms: platforms, coins: coins);
}

WorldPart _multiLevelPlatforms(double startAngleDeg, bool withCoins) {
  CurvePlatform p3 = getCurvePlatform(startAngleDeg + 25, 10, 200);
  final platforms = [
    getCurvePlatform(startAngleDeg, 8, 50),
    getCurvePlatform(startAngleDeg + 10, 8, 100),
    getRampPlatform(startAngleDeg + 17, 8, 30, 164),
    p3,
  ];
  final List<Coin> coins =
      withCoins ? generateCoinsForCurvePlatforms([p3]) : [];
  return WorldPart(platforms: platforms, coins: coins);
}

WorldPart _manyFloors(double startAngleDeg, bool withCoins) {
  final CurvePlatform longPlatform1 = getCurvePlatform(startAngleDeg, 60, 50);
  final CurvePlatform longPlatform2 = getCurvePlatform(startAngleDeg, 60, 250);
  final CurvePlatform longPlatform2Danger = getCurvePlatform(startAngleDeg, 60, 265, dangerPlatformType: DangerPlatformType.longSpike);
  final platforms = [
    longPlatform1,
    longPlatform2,
    longPlatform2Danger,
    getCurvePlatform(startAngleDeg + 3, 5, 120),
    getCurvePlatform(startAngleDeg + 3, 5, 135, dangerPlatformType: DangerPlatformType.longSpike),
    getCurvePlatform(startAngleDeg + 10, 12, 165),
    getCurvePlatform(startAngleDeg + 10, 12, 150, dangerPlatformType: DangerPlatformType.longSpike,direction: Direction.rotate180),
    getCurvePlatform(startAngleDeg + 24, 5, 120),
    getCurvePlatform(startAngleDeg + 24, 5, 135, dangerPlatformType: DangerPlatformType.longSpike),
    getCurvePlatform(startAngleDeg + 31, 12, 165),
    getCurvePlatform(startAngleDeg + 31, 12, 150, dangerPlatformType: DangerPlatformType.longSpike,direction: Direction.rotate180),
    getCurvePlatform(startAngleDeg + 45, 5, 120),
    getCurvePlatform(startAngleDeg + 45, 5, 135, dangerPlatformType: DangerPlatformType.longSpike),
    getCurvePlatform(startAngleDeg + 52, 12, 165),
    getCurvePlatform(startAngleDeg + 52, 12, 150, dangerPlatformType: DangerPlatformType.longSpike,direction: Direction.rotate180),
  ];
  withCoins = true;
  final List<Coin> coins =
      withCoins ? generateCoinsForCurvePlatforms([longPlatform1]) : [];
  return WorldPart(platforms: platforms, coins: coins);
}

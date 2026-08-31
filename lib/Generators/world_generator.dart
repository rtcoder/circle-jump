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
  'stairClimb': _stairClimb,
  'rampWave': _rampWave,
  'coinArc': _coinArc,
  'lowSpikeHop': _lowSpikeHop,
  'splitFloors': _splitFloors,
  'ceilingTunnel': _ceilingTunnel,
};

List<String> get worldPartPatternNames {
  return List.unmodifiable(_worldParts.keys);
}

WorldPart generateWorldPart(
  double startAngleDeg,
  double endAngleDeg, {
  Random? random,
}) {
  final rand = random ?? Random();
  final worldPart = WorldPart();
  String lastWorldName = '';
  String worldName = '';
  double nextStartAngle = startAngleDeg;
  while (nextStartAngle + 6 < endAngleDeg) {
    while (worldName == lastWorldName) {
      worldName = _randomWorldPartKey(rand);
    }
    final randWorldPart = _randomWorldPart(nextStartAngle, worldName, rand);
    double worldEndAngleDeg = randWorldPart.getEndAngleDeg();
    nextStartAngle = worldEndAngleDeg + 5;
    lastWorldName = worldName;
    if (nextStartAngle <= endAngleDeg) {
      worldPart.add(randWorldPart);
    }
  }
  return worldPart;
}

String _randomWorldPartKey(Random random) {
  final keys = _worldParts.keys.toList();
  final randomIndex = random.nextInt(keys.length);
  final randomKey = keys[randomIndex];
  return randomKey;
}

WorldPart _randomWorldPart(
  double startAngleDeg,
  String randomKey,
  Random random,
) {
  final bool withCoins = random.nextBool();
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
    getCurvePlatform(startAngleDeg + 16, 5, 150,
        dangerPlatformType: DangerPlatformType.smallSpike),
    getCurvePlatform(startAngleDeg + 16, 5, 140,
        dangerPlatformType: DangerPlatformType.smallSpike,
        direction: Direction.rotate180),
  ];

  final List<Coin> coins =
      withCoins ? generateCoinsForCurvePlatforms(platforms) : [];
  return WorldPart(platforms: [...platforms, ...dangerPlatforms], coins: coins);
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
  final CurvePlatform longPlatform2Danger = getCurvePlatform(
      startAngleDeg, 60, 265,
      dangerPlatformType: DangerPlatformType.longSpike);
  final platforms = [
    longPlatform1,
    longPlatform2,
    longPlatform2Danger,
    getCurvePlatform(startAngleDeg + 3, 5, 120),
    getCurvePlatform(startAngleDeg + 3, 5, 135,
        dangerPlatformType: DangerPlatformType.longSpike),
    getCurvePlatform(startAngleDeg + 10, 12, 165),
    getCurvePlatform(startAngleDeg + 10, 12, 150,
        dangerPlatformType: DangerPlatformType.longSpike,
        direction: Direction.rotate180),
    getCurvePlatform(startAngleDeg + 24, 5, 120),
    getCurvePlatform(startAngleDeg + 24, 5, 135,
        dangerPlatformType: DangerPlatformType.longSpike),
    getCurvePlatform(startAngleDeg + 31, 12, 165),
    getCurvePlatform(startAngleDeg + 31, 12, 150,
        dangerPlatformType: DangerPlatformType.longSpike,
        direction: Direction.rotate180),
    getCurvePlatform(startAngleDeg + 45, 5, 120),
    getCurvePlatform(startAngleDeg + 45, 5, 135,
        dangerPlatformType: DangerPlatformType.longSpike),
    getCurvePlatform(startAngleDeg + 52, 12, 165),
    getCurvePlatform(startAngleDeg + 52, 12, 150,
        dangerPlatformType: DangerPlatformType.longSpike,
        direction: Direction.rotate180),
  ];
  final List<Coin> coins = generateCoinsForCurvePlatforms([longPlatform1]);
  return WorldPart(platforms: platforms, coins: coins);
}

WorldPart _stairClimb(double startAngleDeg, bool withCoins) {
  final platforms = [
    getCurvePlatform(startAngleDeg, 6, 40),
    getCurvePlatform(startAngleDeg + 8, 6, 85),
    getCurvePlatform(startAngleDeg + 16, 6, 130),
    getCurvePlatform(startAngleDeg + 24, 10, 175),
  ];
  final coins =
      withCoins ? generateCoinsForCurvePlatforms(platforms) : <Coin>[];
  return WorldPart(platforms: platforms, coins: coins);
}

WorldPart _rampWave(double startAngleDeg, bool withCoins) {
  final platforms = [
    getRampPlatform(startAngleDeg, 9, 20, 110),
    getRampPlatform(startAngleDeg + 11, 9, 130, -90),
    getRampPlatform(startAngleDeg + 22, 9, 35, 130),
    getCurvePlatform(startAngleDeg + 33, 12, 155),
  ];
  final coins =
      withCoins ? generateCoinsForCurvePlatforms(platforms) : <Coin>[];
  return WorldPart(platforms: platforms, coins: coins);
}

WorldPart _coinArc(double startAngleDeg, bool withCoins) {
  final platforms = [
    getCurvePlatform(startAngleDeg, 8, 40),
    getCurvePlatform(startAngleDeg + 34, 8, 40),
  ];
  final coins = [
    ...generateCoins(4, 80, startAngleDeg + 8, 10),
    ...generateCoins(4, 140, startAngleDeg + 18, 10),
  ];
  return WorldPart(platforms: platforms, coins: coins);
}

WorldPart _lowSpikeHop(double startAngleDeg, bool withCoins) {
  final safePlatforms = [
    getCurvePlatform(startAngleDeg, 12, 45),
    getCurvePlatform(startAngleDeg + 23, 12, 45),
  ];
  final dangerPlatforms = [
    getCurvePlatform(
      startAngleDeg + 14,
      7,
      45,
      dangerPlatformType: DangerPlatformType.smallSpike,
    ),
  ];
  final coins =
      withCoins ? generateCoins(3, 95, startAngleDeg + 23, 8) : <Coin>[];
  return WorldPart(
    platforms: [...safePlatforms, ...dangerPlatforms],
    coins: coins,
  );
}

WorldPart _splitFloors(double startAngleDeg, bool withCoins) {
  final lower = getCurvePlatform(startAngleDeg, 42, 55);
  final upper = getCurvePlatform(startAngleDeg + 8, 18, 190);
  final upperDanger = getCurvePlatform(
    startAngleDeg + 28,
    10,
    190,
    dangerPlatformType: DangerPlatformType.longSpike,
  );
  final platforms = [
    lower,
    upper,
    upperDanger,
    getRampPlatform(startAngleDeg + 42, 8, 55, 100),
  ];
  final coins = withCoins ? generateCoinsForCurvePlatforms([upper]) : <Coin>[];
  return WorldPart(platforms: platforms, coins: coins);
}

WorldPart _ceilingTunnel(double startAngleDeg, bool withCoins) {
  final floor = getCurvePlatform(startAngleDeg, 34, 60);
  final ceiling = getCurvePlatform(
    startAngleDeg + 4,
    26,
    175,
    dangerPlatformType: DangerPlatformType.longSpike,
    direction: Direction.rotate180,
  );
  final exit = getCurvePlatform(startAngleDeg + 37, 9, 95);
  final platforms = [floor, ceiling, exit];
  final coins =
      withCoins ? generateCoins(5, 105, startAngleDeg + 8, 18) : <Coin>[];
  return WorldPart(platforms: platforms, coins: coins);
}

import 'dart:math';

import 'package:circle_jump/Enums/danger_platform_type.dart';
import 'package:circle_jump/Enums/direction.dart';
import 'package:circle_jump/Generators/coin_generator.dart';
import 'package:circle_jump/Generators/platform_generator.dart';
import 'package:circle_jump/Models/Coin/coin.dart';
import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/World/world_part.dart';

typedef _WorldPartFactory = WorldPart Function(
  double startAngleDeg,
  bool withCoins,
);

final Map<String, _WorldPartFactory> _worldParts = {
  'rollingDunes': _rollingDunes,
  'iceSwitchbacks': _iceSwitchbacks,
  'volcanicPulse': _volcanicPulse,
  'ruinedStairfall': _ruinedStairfall,
  'springVaults': _springVaults,
  'crumblingSpine': _crumblingSpine,
  'lowTunnelRun': _lowTunnelRun,
  'coinCrescent': _coinCrescent,
  'stoneSerpentine': _stoneSerpentine,
  'splitDecision': _splitDecision,
  'hazardSqueeze': _hazardSqueeze,
  'skyBridge': _skyBridge,
  'bounceCanyon': _bounceCanyon,
  'brokenAqueduct': _brokenAqueduct,
  'slowClimb': _slowClimb,
};

const Map<TerrainTheme, List<String>> _terrainWorldParts = {
  TerrainTheme.summer: [
    'rollingDunes',
    'springVaults',
    'coinCrescent',
    'skyBridge',
    'bounceCanyon',
  ],
  TerrainTheme.winter: [
    'iceSwitchbacks',
    'slowClimb',
    'rollingDunes',
    'splitDecision',
    'coinCrescent',
  ],
  TerrainTheme.road: [
    'stoneSerpentine',
    'splitDecision',
    'lowTunnelRun',
    'skyBridge',
    'bounceCanyon',
  ],
  TerrainTheme.grass: [
    'rollingDunes',
    'springVaults',
    'coinCrescent',
    'skyBridge',
    'bounceCanyon',
  ],
  TerrainTheme.desert: [
    'rollingDunes',
    'hazardSqueeze',
    'bounceCanyon',
    'stoneSerpentine',
    'coinCrescent',
  ],
  TerrainTheme.stone: [
    'stoneSerpentine',
    'splitDecision',
    'lowTunnelRun',
    'brokenAqueduct',
    'skyBridge',
  ],
  TerrainTheme.ice: [
    'iceSwitchbacks',
    'slowClimb',
    'rollingDunes',
    'splitDecision',
    'coinCrescent',
  ],
  TerrainTheme.volcanic: [
    'volcanicPulse',
    'hazardSqueeze',
    'lowTunnelRun',
    'bounceCanyon',
    'stoneSerpentine',
  ],
  TerrainTheme.ruins: [
    'ruinedStairfall',
    'crumblingSpine',
    'brokenAqueduct',
    'hazardSqueeze',
    'splitDecision',
  ],
};

List<String> get worldPartPatternNames {
  return List.unmodifiable(_worldParts.keys);
}

List<String> worldPartPatternNamesForTerrain(TerrainTheme terrain) {
  return List.unmodifiable(_terrainWorldParts[terrain]!);
}

WorldPart generateWorldPart(
  double startAngleDeg,
  double endAngleDeg, {
  Random? random,
  TerrainTheme? terrain,
}) {
  final rand = random ?? Random();
  final selectedTerrain = terrain ?? _randomTerrain(rand);
  final worldPart = WorldPart();
  String lastWorldName = '';
  String worldName = '';
  double nextStartAngle = startAngleDeg;
  while (nextStartAngle + 6 < endAngleDeg) {
    while (worldName == lastWorldName) {
      worldName = _randomWorldPartKey(rand, selectedTerrain);
    }
    final randWorldPart = _randomWorldPart(nextStartAngle, worldName, rand)
      ..applyTerrain(selectedTerrain);
    _applySurfaceProfiles(randWorldPart, selectedTerrain);
    final worldEndAngleDeg = randWorldPart.getEndAngleDeg();
    nextStartAngle = worldEndAngleDeg + 5;
    lastWorldName = worldName;
    if (nextStartAngle <= endAngleDeg) {
      worldPart.add(randWorldPart);
    }
  }
  return worldPart;
}

void _applySurfaceProfiles(WorldPart worldPart, TerrainTheme terrain) {
  for (final platform in worldPart.platformCollector.items) {
    platform.surfaceProfile = _surfaceProfileFor(terrain, platform);
  }
}

SurfaceProfile _surfaceProfileFor(
  TerrainTheme terrain,
  PlatformModel platform,
) {
  final phase = platform.startAngleDeg / 18;
  switch (terrain) {
    case TerrainTheme.summer:
      return SurfaceProfile(amplitude: 4, frequency: 1.3, phase: phase);
    case TerrainTheme.winter:
      return SurfaceProfile(amplitude: 6, frequency: 1.6, phase: phase);
    case TerrainTheme.road:
      return SurfaceProfile(amplitude: 2, frequency: 2.2, phase: phase);
    case TerrainTheme.grass:
      return SurfaceProfile(amplitude: 7, frequency: 1.5, phase: phase);
    case TerrainTheme.desert:
      return SurfaceProfile(amplitude: 11, frequency: 0.9, phase: phase);
    case TerrainTheme.stone:
      return SurfaceProfile(amplitude: 8, frequency: 2.6, phase: phase);
    case TerrainTheme.ice:
      return SurfaceProfile(amplitude: 4, frequency: 1.1, phase: phase);
    case TerrainTheme.volcanic:
      return SurfaceProfile(amplitude: 12, frequency: 2.0, phase: phase);
    case TerrainTheme.ruins:
      return SurfaceProfile(amplitude: 10, frequency: 1.8, phase: phase);
  }
}

TerrainTheme _randomTerrain(Random random) {
  return TerrainTheme.values[random.nextInt(TerrainTheme.values.length)];
}

String _randomWorldPartKey(Random random, TerrainTheme terrain) {
  final keys = worldPartPatternNamesForTerrain(terrain);
  final randomIndex = random.nextInt(keys.length);
  return keys[randomIndex];
}

WorldPart _randomWorldPart(
  double startAngleDeg,
  String randomKey,
  Random random,
) {
  final withCoins = random.nextBool();
  final fn = _worldParts[randomKey]!;
  return fn(startAngleDeg, withCoins);
}

List<Coin> _coinsForPlatforms(
  List<PlatformModel> platforms,
  bool withCoins,
) {
  return withCoins ? generateCoinsForCurvePlatforms(platforms) : <Coin>[];
}

WorldPart _rollingDunes(double startAngleDeg, bool withCoins) {
  final platforms = [
    getRampPlatform(startAngleDeg, 10, 30, 85),
    getRampPlatform(startAngleDeg + 12, 9, 125, -70),
    getCurvePlatform(startAngleDeg + 23, 12, 62),
    getRampPlatform(startAngleDeg + 38, 11, 60, 95),
  ];
  final coins =
      withCoins ? generateCoins(6, 150, startAngleDeg + 10, 26) : <Coin>[];
  return WorldPart(platforms: platforms, coins: coins);
}

WorldPart _iceSwitchbacks(double startAngleDeg, bool withCoins) {
  final platforms = [
    getCurvePlatform(startAngleDeg, 10, 58, effect: PlatformEffect.slow),
    getRampPlatform(startAngleDeg + 12, 10, 75, 95),
    getCurvePlatform(startAngleDeg + 25, 9, 190, effect: PlatformEffect.slow),
    getRampPlatform(startAngleDeg + 36, 12, 180, -120),
    getCurvePlatform(startAngleDeg + 50, 8, 68),
  ];
  final coins = withCoins
      ? [
          ...generateCoins(3, 125, startAngleDeg + 12, 8),
          ...generateCoins(3, 235, startAngleDeg + 26, 8),
        ]
      : <Coin>[];
  return WorldPart(platforms: platforms, coins: coins);
}

WorldPart _volcanicPulse(double startAngleDeg, bool withCoins) {
  final safePlatforms = [
    getCurvePlatform(startAngleDeg, 11, 55),
    getCurvePlatform(startAngleDeg + 24, 11, 78),
    getCurvePlatform(startAngleDeg + 48, 12, 92),
  ];
  final dangerPlatforms = [
    getCurvePlatform(
      startAngleDeg + 13,
      7,
      56,
      dangerPlatformType: DangerPlatformType.smallSpike,
    ),
    getCurvePlatform(
      startAngleDeg + 37,
      7,
      80,
      dangerPlatformType: DangerPlatformType.smallSpike,
    ),
  ];
  final coins =
      withCoins ? generateCoins(4, 140, startAngleDeg + 23, 15) : <Coin>[];
  return WorldPart(
    platforms: [...safePlatforms, ...dangerPlatforms],
    coins: coins,
  );
}

WorldPart _ruinedStairfall(double startAngleDeg, bool withCoins) {
  final platforms = [
    getCurvePlatform(startAngleDeg, 8, 190),
    getCurvePlatform(startAngleDeg + 10, 8, 155),
    getCurvePlatform(startAngleDeg + 20, 8, 120),
    getCurvePlatform(
      startAngleDeg + 30,
      6,
      90,
      effect: PlatformEffect.crumble,
    ),
    getCurvePlatform(startAngleDeg + 40, 12, 60),
  ];
  final coins = _coinsForPlatforms(platforms.take(3).toList(), withCoins);
  return WorldPart(platforms: platforms, coins: coins);
}

WorldPart _springVaults(double startAngleDeg, bool withCoins) {
  final platforms = [
    getCurvePlatform(startAngleDeg, 7, 45),
    getCurvePlatform(
      startAngleDeg + 10,
      6,
      85,
      effect: PlatformEffect.bounce,
    ),
    getCurvePlatform(startAngleDeg + 23, 8, 205),
    getCurvePlatform(
      startAngleDeg + 36,
      6,
      235,
      effect: PlatformEffect.bounce,
    ),
    getCurvePlatform(startAngleDeg + 50, 10, 310),
  ];
  final coins =
      withCoins ? generateCoins(6, 165, startAngleDeg + 10, 30) : <Coin>[];
  return WorldPart(platforms: platforms, coins: coins);
}

WorldPart _crumblingSpine(double startAngleDeg, bool withCoins) {
  final platforms = [
    getCurvePlatform(startAngleDeg, 9, 55),
    getCurvePlatform(
      startAngleDeg + 12,
      5,
      75,
      effect: PlatformEffect.crumble,
    ),
    getCurvePlatform(
      startAngleDeg + 20,
      5,
      96,
      effect: PlatformEffect.crumble,
    ),
    getCurvePlatform(
      startAngleDeg + 28,
      5,
      118,
      effect: PlatformEffect.crumble,
    ),
    getCurvePlatform(startAngleDeg + 39, 13, 125),
  ];
  final coins =
      withCoins ? generateCoins(5, 160, startAngleDeg + 10, 24) : <Coin>[];
  return WorldPart(platforms: platforms, coins: coins);
}

WorldPart _lowTunnelRun(double startAngleDeg, bool withCoins) {
  final floor = getCurvePlatform(startAngleDeg, 44, 58);
  final ceiling = getCurvePlatform(
    startAngleDeg + 5,
    30,
    158,
    dangerPlatformType: DangerPlatformType.longSpike,
    direction: Direction.rotate180,
  );
  final exit = getRampPlatform(startAngleDeg + 46, 10, 60, 70);
  final coins =
      withCoins ? generateCoins(5, 103, startAngleDeg + 8, 20) : <Coin>[];
  return WorldPart(platforms: [floor, ceiling, exit], coins: coins);
}

WorldPart _coinCrescent(double startAngleDeg, bool withCoins) {
  final platforms = [
    getCurvePlatform(startAngleDeg, 8, 46),
    getCurvePlatform(startAngleDeg + 40, 10, 74),
  ];
  final coins = [
    ...generateCoins(4, 90, startAngleDeg + 7, 9),
    ...generateCoins(4, 140, startAngleDeg + 17, 9),
    ...generateCoins(4, 195, startAngleDeg + 27, 9),
  ];
  return WorldPart(platforms: platforms, coins: withCoins ? coins : <Coin>[]);
}

WorldPart _stoneSerpentine(double startAngleDeg, bool withCoins) {
  final platforms = [
    getCurvePlatform(startAngleDeg, 9, 70),
    getRampPlatform(startAngleDeg + 11, 9, 70, 80),
    getRampPlatform(startAngleDeg + 22, 9, 160, -90),
    getCurvePlatform(startAngleDeg + 35, 12, 84),
    getCurvePlatform(
      startAngleDeg + 50,
      8,
      84,
      dangerPlatformType: DangerPlatformType.smallSpike,
    ),
  ];
  final coins =
      withCoins ? generateCoins(4, 205, startAngleDeg + 20, 12) : <Coin>[];
  return WorldPart(platforms: platforms, coins: coins);
}

WorldPart _splitDecision(double startAngleDeg, bool withCoins) {
  final lower = getCurvePlatform(startAngleDeg, 42, 56);
  final upper = getCurvePlatform(startAngleDeg + 8, 19, 185);
  final upperExit = getRampPlatform(startAngleDeg + 29, 11, 185, -115);
  final lowerDanger = getCurvePlatform(
    startAngleDeg + 24,
    8,
    57,
    dangerPlatformType: DangerPlatformType.smallSpike,
  );
  final coins = withCoins ? generateCoinsForCurvePlatforms([upper]) : <Coin>[];
  return WorldPart(
    platforms: [lower, upper, upperExit, lowerDanger],
    coins: coins,
  );
}

WorldPart _hazardSqueeze(double startAngleDeg, bool withCoins) {
  final floor = getCurvePlatform(startAngleDeg, 14, 60);
  final mid = getCurvePlatform(startAngleDeg + 19, 11, 112);
  final exit = getCurvePlatform(startAngleDeg + 36, 14, 66);
  final dangers = [
    getCurvePlatform(
      startAngleDeg + 15,
      5,
      62,
      dangerPlatformType: DangerPlatformType.longSpike,
    ),
    getCurvePlatform(
      startAngleDeg + 20,
      9,
      190,
      dangerPlatformType: DangerPlatformType.longSpike,
      direction: Direction.rotate180,
    ),
    getCurvePlatform(
      startAngleDeg + 31,
      5,
      68,
      dangerPlatformType: DangerPlatformType.longSpike,
    ),
  ];
  final coins =
      withCoins ? generateCoins(3, 148, startAngleDeg + 20, 8) : <Coin>[];
  return WorldPart(platforms: [floor, mid, exit, ...dangers], coins: coins);
}

WorldPart _skyBridge(double startAngleDeg, bool withCoins) {
  final platforms = [
    getRampPlatform(startAngleDeg, 12, 40, 120),
    getCurvePlatform(startAngleDeg + 14, 16, 178),
    getRampPlatform(startAngleDeg + 33, 12, 178, -112),
    getCurvePlatform(startAngleDeg + 48, 12, 72),
  ];
  final coins = _coinsForPlatforms(platforms, withCoins);
  return WorldPart(platforms: platforms, coins: coins);
}

WorldPart _bounceCanyon(double startAngleDeg, bool withCoins) {
  final platforms = [
    getCurvePlatform(startAngleDeg, 8, 52),
    getCurvePlatform(
      startAngleDeg + 11,
      7,
      75,
      effect: PlatformEffect.bounce,
    ),
    getCurvePlatform(
      startAngleDeg + 27,
      7,
      78,
      effect: PlatformEffect.bounce,
    ),
    getCurvePlatform(startAngleDeg + 43, 11, 132),
  ];
  final dangers = [
    getCurvePlatform(
      startAngleDeg + 20,
      5,
      50,
      dangerPlatformType: DangerPlatformType.smallSpike,
    ),
    getCurvePlatform(
      startAngleDeg + 36,
      5,
      55,
      dangerPlatformType: DangerPlatformType.smallSpike,
    ),
  ];
  final coins =
      withCoins ? generateCoins(5, 190, startAngleDeg + 11, 22) : <Coin>[];
  return WorldPart(platforms: [...platforms, ...dangers], coins: coins);
}

WorldPart _brokenAqueduct(double startAngleDeg, bool withCoins) {
  final platforms = [
    getCurvePlatform(startAngleDeg, 13, 135),
    getCurvePlatform(
      startAngleDeg + 16,
      6,
      137,
      effect: PlatformEffect.crumble,
    ),
    getCurvePlatform(startAngleDeg + 26, 13, 138),
    getRampPlatform(startAngleDeg + 42, 10, 138, -72),
    getCurvePlatform(startAngleDeg + 55, 8, 70),
  ];
  final coins =
      withCoins ? generateCoins(5, 182, startAngleDeg + 5, 28) : <Coin>[];
  return WorldPart(platforms: platforms, coins: coins);
}

WorldPart _slowClimb(double startAngleDeg, bool withCoins) {
  final platforms = [
    getCurvePlatform(startAngleDeg, 10, 48),
    getRampPlatform(
      startAngleDeg + 13,
      10,
      55,
      92,
      effect: PlatformEffect.slow,
    ),
    getCurvePlatform(
      startAngleDeg + 26,
      10,
      150,
      effect: PlatformEffect.slow,
    ),
    getRampPlatform(startAngleDeg + 39, 10, 150, 70),
    getCurvePlatform(startAngleDeg + 52, 9, 230),
  ];
  final coins =
      withCoins ? generateCoins(6, 115, startAngleDeg + 12, 30) : <Coin>[];
  return WorldPart(platforms: platforms, coins: coins);
}

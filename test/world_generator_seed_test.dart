import 'dart:math';

import 'package:circle_jump/Generators/world_generator.dart';
import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('world generator exposes only the regenerated layout patterns', () {

    expect(worldPartPatternNames.length, greaterThanOrEqualTo(15));
    expect(
      worldPartPatternNames,
      containsAll(
        [
          'rollingDunes',
          'iceSwitchbacks',
          'volcanicPulse',
          'ruinedStairfall',
          'springVaults',
          'crumblingSpine',
          'lowTunnelRun',
          'coinCrescent',
          'stoneSerpentine',
          'splitDecision',
          'hazardSqueeze',
          'skyBridge',
          'bounceCanyon',
          'brokenAqueduct',
          'slowClimb',
        ],
      ),
    );
  });

  test('world generator applies the requested terrain to generated platforms',
      () {
    final worldPart = generateWorldPart(
      -80,
      180,
      random: Random(7),
      terrain: TerrainTheme.ice,
    );

    expect(worldPart.platformCollector.items, isNotEmpty);
    expect(
      worldPart.platformCollector.items.every(
        (platform) => platform.terrain == TerrainTheme.ice,
      ),
      isTrue,
    );
  });

  test('volcanic terrain favors danger-heavy layout patterns', () {
    final names = worldPartPatternNamesForTerrain(TerrainTheme.volcanic);

    expect(names, contains('volcanicPulse'));
    expect(names, contains('hazardSqueeze'));
    expect(names, isNot(contains('coinCrescent')));
  });

  test('world generator creates repeatable layouts from the same seed', () {
    final first = generateWorldPart(-80, 180, random: Random(7));
    final second = generateWorldPart(-80, 180, random: Random(7));

    expect(first.getLengthInDegrees(), second.getLengthInDegrees());
    expect(
      first.platformCollector.items.length,
      second.platformCollector.items.length,
    );
    expect(first.coinCollector.items.length, second.coinCollector.items.length);
  });
}

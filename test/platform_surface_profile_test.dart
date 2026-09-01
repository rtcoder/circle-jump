import 'dart:math';

import 'package:circle_jump/Generators/platform_generator.dart';
import 'package:circle_jump/Generators/world_generator.dart';
import 'package:circle_jump/Models/Platform/curve_platform.dart';
import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('surface profile creates real bumps and dips on curve platforms', () {
    final platform = getCurvePlatform(
      0,
      20,
      100,
      surfaceProfile: const SurfaceProfile(
        amplitude: 12,
        frequency: 0.5,
      ),
    );

    expect(platform.surfaceHeightAtProgress(0), closeTo(100, 0.0001));
    expect(platform.surfaceHeightAtProgress(0.5), closeTo(112, 0.0001));
    expect(platform.surfaceHeightAtProgress(1), closeTo(100, 0.0001));
  });

  test('world generator gives environment themes different surface profiles',
      () {
    final winterPart = generateWorldPart(
      -80,
      180,
      random: Random(7),
      terrain: TerrainTheme.winter,
    );
    final desertPart = generateWorldPart(
      -80,
      180,
      random: Random(7),
      terrain: TerrainTheme.desert,
    );
    final roadPart = generateWorldPart(
      -80,
      180,
      random: Random(7),
      terrain: TerrainTheme.road,
    );

    final winterPlatform =
        winterPart.platformCollector.items.whereType<CurvePlatform>().first;
    final desertPlatform =
        desertPart.platformCollector.items.whereType<CurvePlatform>().first;
    final roadPlatform =
        roadPart.platformCollector.items.whereType<CurvePlatform>().first;

    expect(winterPlatform.surfaceProfile.amplitude, greaterThan(0));
    expect(desertPlatform.surfaceProfile.amplitude,
        greaterThan(winterPlatform.surfaceProfile.amplitude));
    expect(roadPlatform.surfaceProfile.amplitude,
        lessThan(winterPlatform.surfaceProfile.amplitude));
  });
}

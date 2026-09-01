import 'dart:math';

import 'package:circle_jump/Models/Terrain/terrain_surface.dart';
import 'package:circle_jump/Models/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('terrain surface produces circular hills and dips', () {
    const surface = TerrainSurface(
      baseHeight: 0,
      amplitude: 12,
      frequency: 1,
      phase: 0,
    );

    expect(surface.heightAtAngle(0), closeTo(0, 0.0001));
    expect(surface.heightAtAngle(pi / 2), closeTo(12, 0.0001));
    expect(surface.heightAtAngle(3 * pi / 2), closeTo(-12, 0.0001));
  });

  test('player lands on terrain surface instead of the flat zero line', () {
    game.updateScreenSize(const Size(800, 600));
    game.restart();
    game.world.terrainSurface = const TerrainSurface(
      baseHeight: 24,
      amplitude: 0,
      frequency: 0,
    );
    game.player.playerY = 24.2;

    game.update(const Duration(milliseconds: 16));

    expect(game.player.playerY, closeTo(24, 0.0001));
  });
}

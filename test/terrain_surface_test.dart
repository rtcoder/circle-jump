import 'dart:math';

import 'package:circle_jump/Models/Terrain/terrain_surface.dart';
import 'package:circle_jump/Models/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('terrain surface interpolates heights along a straight distance axis',
      () {
    final surface = TerrainSurface(
      points: const [
        TerrainPoint(distance: 0, height: 0),
        TerrainPoint(distance: 10, height: 20),
        TerrainPoint(distance: 20, height: 0),
      ],
    );

    expect(surface.heightAtDistance(0), 0);
    expect(surface.heightAtDistance(5), 10);
    expect(surface.heightAtDistance(15), 10);
    expect(surface.heightAtDistance(30), 0);
  });

  test('terrain surface creates 200m on start and extends in 100m chunks', () {
    final surface = TerrainSurface.generateInitial(random: Random(1));

    expect(surface.generatedUntil, 200);

    surface.ensureGeneratedThrough(240, random: Random(2));

    expect(surface.generatedUntil, 300);
  });

  test('player lands on straight terrain under current world distance', () {
    game.updateScreenSize(const Size(800, 600));
    game.restart();
    game.world.terrainSurface = TerrainSurface(
      points: const [
        TerrainPoint(distance: 0, height: 24),
        TerrainPoint(distance: 200, height: 24),
      ],
    );
    game.player.playerY = 24.2;

    game.update(const Duration(milliseconds: 16));

    expect(game.player.playerY, closeTo(24, 0.0001));
  });
}

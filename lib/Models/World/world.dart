import 'dart:math';

import 'package:circle_jump/Models/Coin/coin.dart';
import 'package:circle_jump/Models/Coin/coin_oscillation.dart';
import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/Terrain/terrain_surface.dart';
import 'package:circle_jump/Models/World/world_part.dart';
import 'package:circle_jump/Models/movable.dart';

class World {
  static const double terrainLookAhead = 160;
  static const double pixelsPerMeter = 8;

  final WorldPart _worldPart = WorldPart();
  final int seed;
  late Random _random;
  double _distance = 0;
  TerrainSurface terrainSurface = TerrainSurface.generateInitial();
  final CoinOscillation coinOscillation = CoinOscillation();

  World({this.seed = 1}) {
    _random = Random(seed);
  }

  Iterable<PlatformModel> getPlatforms({onlyVisible = false}) {
    if (onlyVisible) {
      return _worldPart.platformCollector.visibleItems;
    }
    return _worldPart.platformCollector.items;
  }

  Iterable<Coin> getCoins({onlyVisible = false}) {
    if (onlyVisible) {
      return _worldPart.coinCollector.visibleItems;
    }
    return _worldPart.coinCollector.items;
  }

  void clear() {
    _distance = 0;
    _random = Random(seed);
    terrainSurface = TerrainSurface.generateInitial(random: _random);
    _worldPart.clear();
  }

  void update(double distanceDelta, double frameScale) {
    _distance += distanceDelta;
    terrainSurface.ensureGeneratedThrough(
      _distance + terrainLookAhead,
      random: _random,
    );
    _removeConsumedPlatforms();
    coinOscillation.updateOscillation(frameScale);
  }

  double get distance {
    return _distance;
  }

  double get terrainHeightUnderPlayer {
    return terrainSurface.heightAtDistance(_distance);
  }

  double terrainHeightAtWorldDistance(double distance) {
    return terrainSurface.heightAtDistance(distance);
  }

  double terrainBaselineY(double screenHeight) {
    return screenHeight * 0.72;
  }

  double playerScreenX(double screenWidth) {
    return screenWidth * 0.35;
  }

  double screenXToWorldDistance(double screenX, double screenWidth) {
    return _distance + (screenX - playerScreenX(screenWidth)) / pixelsPerMeter;
  }

  void initWorld() {
    terrainSurface.ensureGeneratedThrough(
      TerrainSurface.initialLength,
      random: _random,
    );
  }

  void removeCollectedCoins(List<Coin> collectedCoins) {
    _worldPart.coinCollector.removeMany(collectedCoins);
  }

  void moveWorldElements(double angleDelta) {
    final List<Movable> elements = [...getPlatforms(), ...getCoins()];
    for (final element in elements) {
      element.move(angleDelta);
    }
  }

  void _removeConsumedPlatforms() {
    _worldPart.platformCollector.items.removeWhere((platform) {
      return platform.isConsumed;
    });
  }
}

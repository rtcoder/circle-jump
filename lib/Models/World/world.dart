import 'dart:math';

import 'package:circle_jump/Generators/world_generator.dart';
import 'package:circle_jump/Models/Coin/coin.dart';
import 'package:circle_jump/Models/Coin/coin_oscillation.dart';
import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/Terrain/terrain_surface.dart';
import 'package:circle_jump/Models/World/world_part.dart';
import 'package:circle_jump/Models/movable.dart';
import 'package:circle_jump/utils.dart';

class World {
  static const double terrainSurfaceOffset = 17;

  final WorldPart _worldPart = WorldPart();
  final int seed;
  late Random _random;
  double _lastWorldUpdateAngleDeg = 0;
  double _terrainAngle = 0;
  TerrainSurface terrainSurface = const TerrainSurface();
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
    _lastWorldUpdateAngleDeg = 0;
    _terrainAngle = 0;
    _random = Random(seed);
    _worldPart.clear();
  }

  void update(double angleDelta, double frameScale) {
    _terrainAngle = (_terrainAngle + angleDelta) % (2 * pi);
    _moveWorldElements(angleDelta);
    _removeConsumedPlatforms();
    _updateWorldCycle(angleDelta);
    coinOscillation.updateOscillation(frameScale);
  }

  double get terrainAngle {
    return _terrainAngle;
  }

  double get terrainHeightUnderPlayer {
    return terrainSurfaceOffset + terrainHeightAtScreenAngle(-pi / 2);
  }

  double terrainHeightAtScreenAngle(double screenAngle) {
    return terrainSurface.heightAtAngle(screenAngle + _terrainAngle);
  }

  void initWorld() {
    final worldPart = generateWorldPart(-80, 180, random: _random);
    _worldPart.add(worldPart);
  }

  void removeCollectedCoins(List<Coin> collectedCoins) {
    _worldPart.coinCollector.removeMany(collectedCoins);
  }

  void _updateWorldData() {
    final double startAngleDeg = _worldPart.getEndAngleDeg();
    final worldPart = generateWorldPart(startAngleDeg, 180, random: _random);
    _worldPart.add(worldPart);
    _worldPart.removeUnnecessaryItems();
  }

  void _moveWorldElements(double angleDelta) {
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

  void _updateWorldCycle(double angleDelta) {
    _lastWorldUpdateAngleDeg += radiansToDegrees(angleDelta);
    if (_lastWorldUpdateAngleDeg > 90) {
      _lastWorldUpdateAngleDeg = 0;
      _updateWorldData();
    }
  }
}

import 'dart:math';

import 'package:circle_jump/Generators/world_generator.dart';
import 'package:circle_jump/Models/Coin/coin.dart';
import 'package:circle_jump/Models/Coin/coin_oscillation.dart';
import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/World/world_part.dart';
import 'package:circle_jump/Models/movable.dart';
import 'package:circle_jump/utils.dart';

class World {
  final WorldPart _worldPart = WorldPart();
  final int seed;
  late Random _random;
  double _lastWorldUpdateAngleDeg = 0;
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
    _random = Random(seed);
    _worldPart.clear();
  }

  void update(double angleDelta, double frameScale) {
    _moveWorldElements(angleDelta);
    _removeConsumedPlatforms();
    _updateWorldCycle(angleDelta);
    coinOscillation.updateOscillation(frameScale);
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

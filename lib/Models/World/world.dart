import 'package:circle_jump/Generators/world_generator.dart';
import 'package:circle_jump/Models/Coin/coin.dart';
import 'package:circle_jump/Models/Coin/coin_oscillation.dart';
import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/World/world_part.dart';
import 'package:circle_jump/Models/game_circle.dart';
import 'package:circle_jump/Models/movable.dart';

class World {
  final WorldPart _worldPart = WorldPart();
  double _lastWorldUpdateAngleDeg = 0;
  final CoinOscillation coinOscillation = CoinOscillation();

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
    _lastWorldUpdateAngleDeg=0;
    _worldPart.clear();
  }

  void update(GameCircle gameCircle) {
    _moveWorldElements(gameCircle.angleDelta);
    _updateWorldCycle(gameCircle.angleDeg);
    coinOscillation.updateOscillation();
  }

  void initWorld() {
    final worldPart = generateWorldPart(-80, 180);
    _worldPart.add(worldPart);
  }

  void removeCollectedCoins(List<Coin> collectedCoins) {
    _worldPart.coinCollector.removeMany(collectedCoins);
  }

  void _updateWorldData() {
    final double startAngleDeg = _worldPart.getEndAngleDeg();
    final worldPart = generateWorldPart(startAngleDeg, 180);
    _worldPart.add(worldPart);
    _worldPart.removeUnnecessaryItems();
  }

  void _moveWorldElements(double angleDelta) {
    final List<Movable> elements = [...getPlatforms(), ...getCoins()];
    for (final element in elements) {
      element.move(angleDelta);
    }
  }

  void _updateWorldCycle(double angleDeg) {
    if (angleDeg - _lastWorldUpdateAngleDeg > 90) {
      _lastWorldUpdateAngleDeg = angleDeg;
      _updateWorldData();
    }
  }
}

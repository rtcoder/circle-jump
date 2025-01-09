import 'package:circle_jump/Generators/world_generator.dart';
import 'package:circle_jump/Models/Coin/coin.dart';
import 'package:circle_jump/Models/Coin/coin_oscillation.dart';
import 'package:circle_jump/Models/Obstacle/obstacle.dart';
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

  Iterable<Obstacle> getObstacles({onlyVisible = false}) {
    if (onlyVisible) {
      return _worldPart.obstacleCollector.visibleItems;
    }
    return _worldPart.obstacleCollector.items;
  }

  Iterable<Coin> getCoins({onlyVisible = false}) {
    if (onlyVisible) {
      return _worldPart.coinCollector.visibleItems;
    }
    return _worldPart.coinCollector.items;
  }

  void update(GameCircle gameCircle) {
    _moveWorldElements(gameCircle.angleDelta);
    _updateWorldCycle(gameCircle.angleDeg);
    coinOscillation.updateOscillation();
  }

  void initWorld() {
    final worldPart = generateWorldPart(-85, 90);
    _worldPart.add(worldPart);
  }

  void removeCollectedCoins(List<Coin> collectedCoins) {
    _worldPart.coinCollector.removeMany(collectedCoins);
  }

  void _updateWorldData(double length) {
    final double startAngleDeg = _worldPart.getEndAngleDeg();
    final double endAngleDeg = startAngleDeg + length;
    final worldPart = generateWorldPart(startAngleDeg, endAngleDeg);
    _worldPart.add(worldPart);
    _worldPart.removeUnnecessaryItems();
  }

  void _moveWorldElements(double angleDelta) {
    final List<Movable> elements = [
      ...getPlatforms(),
      ...getObstacles(),
      ...getCoins()
    ];
    for (final element in elements) {
      element.move(angleDelta);
    }
  }

  void _updateWorldCycle(double angleDeg) {
    if (angleDeg - _lastWorldUpdateAngleDeg > 90) {
      _lastWorldUpdateAngleDeg = angleDeg;
      _updateWorldData(90);
    }
  }
}

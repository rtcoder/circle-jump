import 'package:circle_jump/Generators/world_generator.dart';
import 'package:circle_jump/Models/Coin/coin.dart';
import 'package:circle_jump/Models/Obstacle/obstacle.dart';
import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/world_part.dart';

class World {
  final WorldPart _worldPart = WorldPart();

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

  void initWorld(double startAngleDeg, double endAngleDeg) {
    final worldPart = generateWorldPart(startAngleDeg, endAngleDeg);
    _worldPart.add(worldPart);
  }

  void updateWorld(double length) {
    final double startAngleDeg = _worldPart.getEndAngleDeg();
    final double endAngleDeg = startAngleDeg + length;
    final worldPart = generateWorldPart(startAngleDeg, endAngleDeg);
    _worldPart.add(worldPart);
    _worldPart.removeUnnecessaryItems();
  }

  void removeCollectedCoins(List<Coin> collectedCoins) {
    _worldPart.coinCollector.removeMany(collectedCoins);
  }
}

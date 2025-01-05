import 'package:circle_jump/Models/Coin/coin.dart';
import 'package:circle_jump/Models/Obstacle/obstacle.dart';

import 'Platform/platform.dart';

class WorldPart {
  final List<PlatformModel> platforms;
  final List<Coin> coins;
  final List<Obstacle> obstacles;

  WorldPart({
    required this.platforms,
    required this.coins,
    required this.obstacles,
  });

  void add(WorldPart worldPart) {
    platforms.addAll(worldPart.platforms);
    coins.addAll(worldPart.coins);
    obstacles.addAll(worldPart.obstacles);
  }
}

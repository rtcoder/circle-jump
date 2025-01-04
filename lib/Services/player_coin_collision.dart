import 'dart:math';

import 'package:circle_jump/Models/Coin/coin.dart';
import 'package:circle_jump/Models/game.dart';
import 'package:circle_jump/Models/player.dart';

class PlayerCoinCollision {
  static List<Coin> collectCoins() {
    final List<Coin> collectedCoins = [];

    for (final coin in game.coinCollector.visibleItems) {
      if (PlayerCoinCollision.isCoinCollected(coin, game.player)) {
        collectedCoins.add(coin);
        game.player.score += 1;
      }
    }

    game.coinCollector.removeMany(collectedCoins);
    return collectedCoins;
  }

  static bool isCoinCollected(Coin coin, Player player) {
    final double dx = player.playerX - coin.x;
    final double dy = player.playerYAbsolutePosition - coin.y;
    final double distance = sqrt(dx * dx + dy * dy);

    return distance <= player.radius + coin.radius;
  }
}

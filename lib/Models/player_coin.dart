import 'dart:math';

import 'package:circle_jump/Models/player.dart';
import 'package:circle_jump/Models/coin.dart';

class PlayerCoin {
  static bool isCoinCollected(Coin coin, Player player) {
    final double dx = player.playerX - coin.x;
    final double dy = player.playerYAbsolutePosition - coin.y;
    final double distance = sqrt(dx * dx + dy * dy);

    return distance <= player.radius + coin.radius;
  }
}

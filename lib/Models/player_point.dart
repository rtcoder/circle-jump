import 'dart:math';

import 'package:circle_jump/Models/player.dart';
import 'package:circle_jump/Models/point.dart';

class PlayerPoint {
  static bool isPointCollected(Point point, Player player) {
    final double dx = player.playerX - point.x;
    final double dy = player.playerYAbsolutePosition - point.y;
    final double distance = sqrt(dx * dx + dy * dy);

    return distance <= player.radius + point.radius;
  }
}

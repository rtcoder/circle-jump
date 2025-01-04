import 'dart:math';

import '../Models/coin.dart';
import '../utils.dart';

List<Coin> generateCoins(int count, double height, double startAngle, double endAngle) {
  final rand = Random();
  final List<Coin> coins = [];
  for (int i = 0; i < count; i++) {
    final angle = -95.00;//rand.nextInt(360).toDouble();
    final startAngleRad = degreesToRadians(angle);
    final height = 100 + rand.nextDouble() * 50;
    coins.add(Coin(
      angle: startAngleRad,
      angleDeg: angle,
      airHeight: height,
    ));
  }
  return coins;
}

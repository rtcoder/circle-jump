import 'dart:math';

import '../Models/coin.dart';
import '../utils.dart';

List<Coin> generateCoins(int count) {
  final rand = Random();
  final List<Coin> coins = [];
  for (int i = 0; i < count; i++) {
    final startAngle = rand.nextInt(360);
    final startAngleRad = degreesToRadians(startAngle.toDouble());
    final height = 100 + rand.nextDouble() * 50;
    coins.add(Coin(
      angle: startAngleRad,
      airHeight: height,
    ));
  }
  for (int i = 0; i < count; i++) {
    final startAngle = rand.nextInt(360);
    final startAngleRad = degreesToRadians(startAngle.toDouble());
    coins.add(Coin(
      angle: startAngleRad,
      airHeight: 100,
    ));
  }
  return coins;
}

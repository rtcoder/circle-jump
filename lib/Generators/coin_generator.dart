import '../Models/Coin/coin.dart';
import '../utils.dart';

List<Coin> generateCoins(
    int count, double height, double startAngleDeg, double endAngleDeg) {
  final List<Coin> coins = [];
  final angleRange = endAngleDeg - startAngleDeg;
  final angleStep = angleRange / (count - 1);

  for (int i = 0; i < count; i++) {
    final angleDeg = startAngleDeg + i * angleStep;
    final angleRad = degreesToRadians(angleDeg);

    coins.add(
      Coin(
        angle: angleRad,
        angleDeg: angleDeg,
        airHeight: height,
      ),
    );
  }

  return coins;
}

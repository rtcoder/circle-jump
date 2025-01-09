import 'package:circle_jump/Models/Coin/coin.dart';
import 'package:circle_jump/Models/Platform/curve_platform.dart';
import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/utils.dart';

List<Coin> generateCoins(
    int count, double height, double startAngleDeg, double lengthDeg) {
  final List<Coin> coins = [];
  final angleStep = lengthDeg / (count - 1);

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

List<Coin> generateCoinsForCurvePlatform(CurvePlatform platform) {
  final double startAngleDeg = platform.startAngleDeg + 1;
  final double length = platform.endAngleDeg - platform.startAngleDeg - 2;
  final int count = (length / 1.5).floor();
  return generateCoins(count, platform.height + 30, startAngleDeg, length);
}

List<Coin> generateCoinsForCurvePlatforms(List<PlatformModel> platforms) {
  final List<Coin> coins = [];
  for (final platform in platforms) {
    if (platform is CurvePlatform) {
      coins.addAll(generateCoinsForCurvePlatform(platform));
    }
  }

  return coins;
}

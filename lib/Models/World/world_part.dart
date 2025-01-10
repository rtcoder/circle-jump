import 'dart:math';

import 'package:circle_jump/Models/Coin/coin.dart';
import 'package:circle_jump/Models/Coin/coin_collector.dart';
import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/Platform/platform_collector.dart';

class WorldPart {
  final CoinCollector coinCollector = CoinCollector();
  final PlatformCollector platformCollector = PlatformCollector();

  WorldPart({
    List<PlatformModel> platforms = const [],
    List<Coin> coins = const [],
  }) {
    platformCollector.collectAll(platforms);
    coinCollector.collectAll(coins);
  }

  void clear() {
    coinCollector.items.clear();
    platformCollector.items.clear();
  }

  bool isEmpty() {
    return platformCollector.items.isEmpty && coinCollector.items.isEmpty;
  }

  void add(WorldPart worldPart) {
    platformCollector.join(worldPart.platformCollector);
    coinCollector.join(worldPart.coinCollector);
  }

  void removeUnnecessaryItems() {
    coinCollector.removeUnnecessaryItems();
    platformCollector.removeUnnecessaryItems();
  }

  double getLengthInDegrees() {
    double angleStart = getStartAngleDeg();
    double angleEnd = getEndAngleDeg();

    return angleEnd - angleStart;
  }

  double getStartAngleDeg() {
    final platformsList = platformCollector.items;
    final coinsList = coinCollector.items;

    final minStartAngle = [
      ...platformsList.map((p) => p.startAngleDeg),
      ...coinsList.map((p) => p.angleDeg),
    ].reduce(min);

    return minStartAngle;
  }

  double getEndAngleDeg() {
    final platformsList = platformCollector.items;
    final coinsList = coinCollector.items;

    final maxEndAngle = [
      ...platformsList.map((p) => p.endAngleDeg),
      ...coinsList.map((p) => p.angleDeg),
    ].reduce(max);

    return maxEndAngle;
  }
}

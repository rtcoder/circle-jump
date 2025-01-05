import '../collector.dart';
import 'coin.dart';

class CoinCollector extends Collector<Coin> {
  @override
  Iterable<Coin> get visibleItems {
    return items.where((coin) {
      return coin.angleDeg <= 0 && coin.angleDeg >= -180;
    });
  }

  @override
  void removeUnnecessaryItems() {
    items.removeWhere((coin){
      return coin.angleDeg < -180;
    });
  }
}

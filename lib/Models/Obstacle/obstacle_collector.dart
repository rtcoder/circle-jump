import 'package:circle_jump/Models/Obstacle/obstacle.dart';
import '../collector.dart';

class ObstacleCollector extends Collector<Obstacle> {
  @override
  Iterable<Obstacle> get visibleItems {
    return items.where((coin) {
      return coin.angleDeg <= 0 && coin.angleDeg >= -180;
    });
  }
}

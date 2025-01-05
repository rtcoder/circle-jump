import 'package:circle_jump/Models/Obstacle/obstacle.dart';

import '../collector.dart';

class ObstacleCollector extends Collector<Obstacle> {
  @override
  Iterable<Obstacle> get visibleItems {
    return items.where((obstacle) {
      return obstacle.angleDeg <= 0 && obstacle.angleDeg >= -180;
    });
  }

  @override
  void removeUnnecessaryItems() {
    items.removeWhere((obstacle) {
      return obstacle.angleDeg < -180;
    });
  }
}

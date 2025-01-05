import 'dart:math';

import '../Enums/obstacle_type.dart';
import '../Models/Obstacle/obstacle.dart';

List<Obstacle> obstacleGenerator(int count) {
  return List.generate(count, (index) {
    final type = ObstacleType.values[index % ObstacleType.values.length];
    return Obstacle(
      angle: index * pi / 2.5,
      type: type,
      angleDeg: 3,
    );
  });
}

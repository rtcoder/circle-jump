import 'dart:math';

import '../Models/Obstacle/obstacle.dart';
import '../Enums/obstacle_type.dart';

List<Obstacle> obstacleGenerator(int count) {
  return List.generate(count, (index) {
    final type = ObstacleType.values[index % ObstacleType.values.length];
    return Obstacle(
      angle: index * pi / 2.5,
      type: type,
    );
  });
}

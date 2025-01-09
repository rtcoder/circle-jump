import 'dart:math';

import 'package:circle_jump/Enums/obstacle_type.dart';
import 'package:circle_jump/Models/Obstacle/obstacle.dart';

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

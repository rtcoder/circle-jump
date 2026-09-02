import 'dart:math';

import 'package:circle_jump/Background/Cloud/cloud.dart';

List<Cloud> cloudGenerator(int count) {
  final rand = Random();
  return List.generate(count, (index) {
    final size = 50 + rand.nextDouble() * 50;
    return Cloud(
      x: index * 170 + rand.nextDouble() * 120,
      y: 80 + rand.nextDouble() * 170,
      size: size,
      speed: 0.35 + rand.nextDouble() * 0.75,
      opacity: 0.4 + rand.nextDouble() * (1 - 0.4),
    );
  });
}

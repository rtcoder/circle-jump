import 'dart:math';
import 'package:circle_jump/Background/Cloud/cloud.dart';


List<Cloud> cloudGenerator(int count) {
  final rand = Random();
  return List.generate(count, (index) {
    return Cloud(
      angle: index * pi / 2.5,
      heightOverGround: 150 + rand.nextDouble() * 150, // Wysokość
      size: 50 + rand.nextDouble() * 50, // Rozmiar chmury
      speed: 0.001 + rand.nextDouble() * (0.003 - 0.001),
    );
  });
}

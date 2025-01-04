import 'dart:math';

import 'package:flutter/material.dart';

import '../Models/Platform/bumpy_platform.dart';
import '../Models/Platform/platform.dart';
import '../utils.dart';

List<PlatformModel> generatePlatforms(int groupCount, int platformsPerGroup) {
  final rand = Random();
  final List<PlatformModel> platforms = [];
  double lastEndAngle = 0; // Początkowy kąt

  for (int group = 0; group < groupCount; group++) {
    // Dodaj każdą grupę logicznie
    for (int i = 0; i < platformsPerGroup; i++) {
      // Generuj startowy kąt z przerwą od poprzedniej platformy
      final startAngle = lastEndAngle + rand.nextInt(30) + 20; // Przerwa min. 20°
      final startAngleRad = degreesToRadians(startAngle.toDouble());

      // Długość platformy
      final lengthInDegrees = rand.nextInt(15) + 5; // Długość platformy 5°-20°
      final endAngle = startAngle + lengthInDegrees;
      final endAngleRad = degreesToRadians(endAngle.toDouble());

      // Wysokość lub promień platformy
      final height = 100 + rand.nextDouble() * 50;

       if (i % 2 == 0) {
        // Rampy w co drugiej iteracji
        platforms.add(PlatformModel.ramp(
          startAngle: startAngleRad,
          endAngle: endAngleRad,
          startHeight: -20,
          endHeight: 100,
          color: Colors.green,
          strokeWidth: 15,
        ));
      } else {
        // Krzywizny w pozostałych
        platforms.add(PlatformModel.curved(
          startAngle: startAngleRad,
          endAngle: endAngleRad,
          height: height,
        ));
      }

      // Zaktualizuj `lastEndAngle` na przyszłe grupy
      lastEndAngle = endAngle;
    }

    // Przerwa między grupami
    lastEndAngle += rand.nextInt(40) + 20; // Przerwa min. 20°, max. 60°
  }

  return platforms;
}

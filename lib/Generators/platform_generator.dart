import 'dart:math';

import 'package:circle_jump/Models/Platform/curve_platform.dart';
import 'package:circle_jump/Models/Platform/ramp_platform.dart';
import 'package:flutter/material.dart';

import '../Models/Platform/platform.dart';
import '../utils.dart';

List<PlatformModel> generatePlatforms(int groupCount, int platformsPerGroup) {
  final rand = Random();
  final List<PlatformModel> platforms = [];
  double lastEndAngle = 0;

  for (int group = 0; group < groupCount; group++) {
    for (int i = 0; i < platformsPerGroup; i++) {
      final startAngle = lastEndAngle + rand.nextInt(30) + 20;
      final startAngleRad = degreesToRadians(startAngle.toDouble());

      final lengthInDegrees = rand.nextInt(15) + 5;
      final endAngle = startAngle + lengthInDegrees;
      final endAngleRad = degreesToRadians(endAngle.toDouble());

      final height = 100 + rand.nextDouble() * 50;

       if (i % 2 == 0) {
        platforms.add(RampPlatform(
          startAngle: startAngleRad,
          endAngle: endAngleRad,
          startHeight: -20,
          endHeight: 100,
          color: Colors.green,
        ));
      } else {
        platforms.add(CurvePlatform(
          startAngle: startAngleRad,
          endAngle: endAngleRad,
          height: height,
        ));
      }

      lastEndAngle = endAngle;
    }

    lastEndAngle += rand.nextInt(40) + 20;
  }

  return platforms;
}

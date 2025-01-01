import 'dart:math';

import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

List<PlatformModel> generatePlatforms(int count) {
  final rand = Random();
  final List<PlatformModel> platforms = [];
  for (int i = 0; i < count; i++) {
    final startAngle = rand.nextInt(360);
    final startAngleRad = degreesToRadians(startAngle.toDouble());
    final lengthInDegrees = rand.nextInt(10) + 5;
    final endAngle = startAngle + lengthInDegrees;
    final endAngleRad = degreesToRadians(endAngle.toDouble());
    final height = 100 + rand.nextDouble() * 50;
    platforms.add(PlatformModel.curved(
      startAngle: startAngleRad,
      endAngle: endAngleRad,
      height: height,
    ));
  }
  for (int i = 0; i < count; i++) {
    final startAngle = rand.nextInt(360);
    final startAngleRad = degreesToRadians(startAngle.toDouble());
    final lengthInDegrees = rand.nextInt(10) + 5;
    final endAngle = startAngle + lengthInDegrees;
    final endAngleRad = degreesToRadians(endAngle.toDouble());
    final height = 100 + rand.nextDouble() * 50; // Promień platformy
    platforms.add(PlatformModel.ramp(
      startAngle: startAngleRad,
      endAngle: endAngleRad,
      startHeight: 0,
      endHeight: 100,
      color: Colors.green,
      strokeWidth: 15,
    ));
  }
  return platforms;
}

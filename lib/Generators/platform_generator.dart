import 'dart:math';

import 'package:circle_jump/Models/Platform/curve_platform.dart';
import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/Platform/ramp_platform.dart';
import 'package:circle_jump/utils.dart';

List<PlatformModel> generatePlatforms(int groupCount, int platformsPerGroup) {
  final rand = Random();
  final List<PlatformModel> platforms = [];
  double lastEndAngle = 0;

  for (int group = 0; group < groupCount; group++) {
    for (int i = 0; i < platformsPerGroup; i++) {
      final startAngle = lastEndAngle + rand.nextInt(30) + 20;
      final startAngleRad = degreesToRadians(startAngle.toDouble());

      final lengthInDegrees = (rand.nextInt(15) + 5).toDouble();
      final endAngle = startAngle + lengthInDegrees;
      final endAngleRad = degreesToRadians(endAngle.toDouble());

      final height = 100 + rand.nextDouble() * 50;

      if (i % 2 == 0) {
        platforms.add(RampPlatform(
          startAngle: startAngleRad,
          startAngleDeg: startAngle,
          endAngle: endAngleRad,
          endAngleDeg: endAngle,
          startHeight: -20,
          endHeight: 100,
        ));
      } else {
        platforms.add(getCurvePlatform(startAngle, lengthInDegrees, height));
      }

      lastEndAngle = endAngle;
    }

    lastEndAngle += rand.nextInt(40) + 20;
  }

  return platforms;
}

CurvePlatform getCurvePlatform(
    double startAngleDeg, double lengthDeg, double height) {
  final startAngleRad = degreesToRadians(startAngleDeg);
  final endAngle = startAngleDeg + lengthDeg;
  final endAngleRad = degreesToRadians(endAngle.toDouble());

  return CurvePlatform(
    startAngle: startAngleRad,
    startAngleDeg: startAngleDeg,
    endAngle: endAngleRad,
    endAngleDeg: endAngle,
    height: height,
  );
}

RampPlatform getRampPlatform(
    double startAngleDeg, double lengthDeg, double airHeight, double height) {
  final startAngleRad = degreesToRadians(startAngleDeg);
  final endAngle = startAngleDeg + lengthDeg;
  final endAngleRad = degreesToRadians(endAngle.toDouble());

  return RampPlatform(
    startAngle: startAngleRad,
    startAngleDeg: startAngleDeg,
    endAngle: endAngleRad,
    endAngleDeg: endAngle,
    startHeight: airHeight,
    endHeight: height + airHeight,
  );
}

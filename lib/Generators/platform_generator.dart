import 'package:circle_jump/Enums/danger_platform_type.dart';
import 'package:circle_jump/Enums/direction.dart';
import 'package:circle_jump/Models/Platform/curve_platform.dart';
import 'package:circle_jump/Models/Platform/ramp_platform.dart';
import 'package:circle_jump/utils.dart';

CurvePlatform getCurvePlatform(
    double startAngleDeg, double lengthDeg, double height,
    {DangerPlatformType? dangerPlatformType,
    Direction? direction,
    double strokeWidth = 15}) {
  final startAngleRad = degreesToRadians(startAngleDeg);
  final endAngle = startAngleDeg + lengthDeg;
  final endAngleRad = degreesToRadians(endAngle.toDouble());

  return CurvePlatform(
    startAngle: startAngleRad,
    startAngleDeg: startAngleDeg,
    endAngle: endAngleRad,
    endAngleDeg: endAngle,
    height: height,
    isDanger: dangerPlatformType != null,
    dangerPlatformType: dangerPlatformType,
    imageDirection: direction,
    strokeWidth: strokeWidth,
  );
}

RampPlatform getRampPlatform(
    double startAngleDeg, double lengthDeg, double airHeight, double height,
    {DangerPlatformType? dangerPlatformType,
    Direction? direction,
    double strokeWidth = 15}) {
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
    isDanger: dangerPlatformType != null,
    dangerPlatformType: dangerPlatformType,
    imageDirection: direction,
    strokeWidth: strokeWidth,
  );
}

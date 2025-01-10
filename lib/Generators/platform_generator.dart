import 'package:circle_jump/Enums/danger_platform_type.dart';
import 'package:circle_jump/Enums/direction.dart';
import 'package:circle_jump/Models/Platform/curve_platform.dart';
import 'package:circle_jump/Models/Platform/ramp_platform.dart';
import 'package:circle_jump/utils.dart';

double getRotationAngle(Direction? direction) {
  switch (direction) {
    case null:
    case Direction.up:
      return 0;
    case Direction.down:
      return 180;
    case Direction.left:
      return 90;
    case Direction.right:
      return 270;
  }
}

CurvePlatform getCurvePlatform(
    double startAngleDeg, double lengthDeg, double height,
    {DangerPlatformType? dangerPlatformType, Direction? direction}) {
  final startAngleRad = degreesToRadians(startAngleDeg);
  final endAngle = startAngleDeg + lengthDeg;
  final endAngleRad = degreesToRadians(endAngle.toDouble());
  final double rotatePlatformImageAngle = getRotationAngle(direction);

  return CurvePlatform(
    startAngle: startAngleRad,
    startAngleDeg: startAngleDeg,
    endAngle: endAngleRad,
    endAngleDeg: endAngle,
    height: height,
    isDanger: dangerPlatformType != null,
    dangerPlatformType: dangerPlatformType,
    rotatePlatformImageAngle: degreesToRadians(rotatePlatformImageAngle),
  );
}

RampPlatform getRampPlatform(
    double startAngleDeg, double lengthDeg, double airHeight, double height,
    {DangerPlatformType? dangerPlatformType, Direction? direction}) {
  final startAngleRad = degreesToRadians(startAngleDeg);
  final endAngle = startAngleDeg + lengthDeg;
  final endAngleRad = degreesToRadians(endAngle.toDouble());
  final double rotatePlatformImageAngle = getRotationAngle(direction);

  return RampPlatform(
    startAngle: startAngleRad,
    startAngleDeg: startAngleDeg,
    endAngle: endAngleRad,
    endAngleDeg: endAngle,
    startHeight: airHeight,
    endHeight: height + airHeight,
    isDanger: dangerPlatformType != null,
    dangerPlatformType: dangerPlatformType,
    rotatePlatformImageAngle: degreesToRadians(rotatePlatformImageAngle),
  );
}

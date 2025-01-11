import 'package:circle_jump/Enums/danger_platform_type.dart';
import 'package:circle_jump/Enums/direction.dart';
import 'package:circle_jump/Models/movable.dart';
import 'package:flutter/material.dart';

abstract class PlatformModel extends Movable {
  double startAngle;
  double endAngle;
  double startAngleDeg;
  double endAngleDeg;
  Color color;
  double strokeWidth;
  final bool isDanger;
  final DangerPlatformType? dangerPlatformType;
  final Direction? imageDirection;

  get startX;

  get startY;

  get endX;

  get endY;

  PlatformModel({
    required this.startAngle,
    required this.endAngle,
    required this.startAngleDeg,
    required this.endAngleDeg,
    this.color = Colors.brown,
    this.strokeWidth = 20.0,
    this.isDanger = false,
    this.dangerPlatformType,
    this.imageDirection,
  }) : assert(
          !isDanger || dangerPlatformType != null,
          'dangerPlatformType must be provided when isDanger is true',
        );
}

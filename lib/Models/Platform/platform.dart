import 'package:circle_jump/Models/movable.dart';
import 'package:flutter/material.dart';

abstract class PlatformModel extends Movable {
  double startAngle;
  double endAngle;
  double startAngleDeg;
  double endAngleDeg;
  Color color;
  double strokeWidth;

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
    this.strokeWidth = 15.0,
  });
}

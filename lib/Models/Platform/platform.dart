import 'package:flutter/material.dart';

import '../movable.dart';

abstract class PlatformModel extends Movable {
  double startAngle;
  double endAngle;
  Color color;
  double strokeWidth;

  get startX;

  get startY;

  get endX;

  get endY;

  PlatformModel({
    required this.startAngle,
    required this.endAngle,
    this.color = Colors.brown,
    this.strokeWidth = 15.0,
  });
}

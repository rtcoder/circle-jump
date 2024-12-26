import 'dart:math';

import 'package:flutter/material.dart';

class CircleCenter {
  final double centerX;
  final double centerY;
  final double radius;

  CircleCenter(
      {required this.centerX, required this.centerY, required this.radius});
}

CircleCenter getCenterOfCircle(Size size) {
  final maxSize = max(size.width, size.height);
  final radius = maxSize;

  final centerX = size.width / 2;
  final centerY = size.height / 2 + radius;

  return CircleCenter(centerX: centerX, centerY: centerY, radius: radius);
}

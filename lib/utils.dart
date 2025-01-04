import 'dart:math';

import 'package:flutter/material.dart';

import 'Models/circle_center.dart';

Offset angleToPositionOnCircle(
    CircleCenter center, double angleDeg, double radiusOffset) {
  final angleRad = degreesToRadians(angleDeg);
  final radius = center.radius + radiusOffset;
  double x = getXPosOnCircle(center.centerX, radius, angleRad);
  double y = getYPosOnCircle(center.centerY, radius, angleRad);
  return Offset(x, y);
}

double degreesToRadians(double degrees) {
  return degrees * (pi / 180.0);
}

double radiansToDegrees(double radians) {
  return radians * (180.0 / pi);
}

double getXPosOnCircle(double centerX, double radius, double angle) {
  return centerX + radius * cos(angle);
}

double getYPosOnCircle(double centerY, double radius, double angle) {
  return centerY + radius * sin(angle);
}

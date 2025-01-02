import 'dart:math';

import 'package:flutter/material.dart';

import '../Models/point.dart' as point_model;
import '../utils.dart';

List<point_model.Point> generatePoints(int count) {
  final rand = Random();
  final List<point_model.Point> points = [];
  for (int i = 0; i < count; i++) {
    final startAngle = rand.nextInt(360);
    final startAngleRad = degreesToRadians(startAngle.toDouble());
    final height = 100 + rand.nextDouble() * 50;
    points.add(point_model.Point(
      angle: startAngleRad,
      airHeight: height,
    ));
  }
  for (int i = 0; i < count; i++) {
    final startAngle = rand.nextInt(360);
    final startAngleRad = degreesToRadians(startAngle.toDouble());
    points.add(point_model.Point(
      angle: startAngleRad,
      airHeight: 100,
    ));
  }
  return points;
}

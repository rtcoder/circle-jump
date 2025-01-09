import 'package:circle_jump/Models/game.dart';
import 'package:flutter/material.dart';

class CircleCenter {
  final double centerX;
  final double centerY;
  final double radius;

  CircleCenter(
      {required this.centerX, required this.centerY, required this.radius});

  static CircleCenter getCenterOfCircle(Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2 + game.gameCircle.radius;

    return CircleCenter(
        centerX: centerX, centerY: centerY, radius: game.gameCircle.radius);
  }
}

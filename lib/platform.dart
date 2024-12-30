import 'dart:math';
import 'dart:ui' as ui;

import 'package:circle_jump/game.dart';
import 'package:circle_jump/images.dart';
import 'package:circle_jump/utils.dart';
import 'package:flutter/material.dart';

class PlatformPositions {
  final double startX;
  final double startY;
  final double endX;
  final double endY;

  PlatformPositions({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
  });
}

class PlatformModel {
  double startAngle;
  double endAngle;
  final double height;
  final double strokeWidth = 15;
  Color color = Colors.brown;

  PlatformModel({
    required this.startAngle,
    required this.endAngle,
    required this.height,
  });

  void move(double delta) {
    startAngle = (startAngle - delta) % (2 * pi);
    if (startAngle < 0) {
      startAngle += 2 * pi;
    }

    endAngle = (endAngle - delta) % (2 * pi);
    if (endAngle < 0) {
      endAngle += 2 * pi;
    }
  }

  PlatformPositions getStartAndEndPosition() {
    final center = game.circleCenter;
    final startX = _calculateX(center.centerX, center.radius, startAngle);
    final startY = _calculateY(center.centerY, center.radius, startAngle);
    final endX = _calculateX(center.centerX, center.radius, endAngle);
    final endY = _calculateY(center.centerY, center.radius, endAngle);
    return PlatformPositions(
      startX: startX,
      startY: startY,
      endX: endX,
      endY: endY,
    );
  }

  double _calculateX(double centerX, double radius, double angle) {
    return centerX + (radius + height) * cos(angle);
  }

  double _calculateY(double centerY, double radius, double angle) {
    return centerY + (radius + height) * sin(angle);
  }
}

final h = [10, 12, 14, 16, 18, 20, 22, 24];

List<PlatformModel> generatePlatforms(int count) {
  final rand = Random();
  final List<PlatformModel> platforms = [];
  for (int i = 0; i < 8; i++) {
    final startAngle = i / 2;
    final startAngleRad = degreesToRadians(startAngle.toDouble());
    final lengthInDegrees = 3;
    final endAngle = startAngle + lengthInDegrees;
    final endAngleRad = degreesToRadians(endAngle.toDouble());
    final height = h[i];
    platforms.add(PlatformModel(
        startAngle: startAngleRad,
        endAngle: endAngleRad,
        height: height.toDouble(),
    ));
  }
  for (int i = 0; i < count; i++) {
    final startAngle = rand.nextInt(360);
    final startAngleRad = degreesToRadians(startAngle.toDouble());
    final lengthInDegrees = rand.nextInt(10) + 5;
    final endAngle = startAngle + lengthInDegrees;
    final endAngleRad = degreesToRadians(endAngle.toDouble());
    final height = 100 + rand.nextDouble() * 50; // Promień platformy
    platforms.add(PlatformModel(
        startAngle: startAngleRad,
        endAngle: endAngleRad,
        height: height,
    ));
  }
  return platforms;
}

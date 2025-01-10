import 'dart:math';

import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/game.dart';
import 'package:circle_jump/utils.dart';
import 'package:flutter/material.dart';

class CurvePlatform extends PlatformModel {
  final double height;

  get _heightRadius {
    final center = game.circleCenter;
    return center.radius + height;
  }

  get sweepAngle {
    double angle = (endAngle - startAngle) % (2 * pi);
    if (angle <= 0) {
      angle += 2 * pi;
    }
    return angle;
  }

  @override
  get startX {
    final center = game.circleCenter;
    return getXPosOnCircle(center.centerX, _heightRadius, startAngle);
  }

  @override
  get startY {
    final center = game.circleCenter;
    return getYPosOnCircle(center.centerY, _heightRadius, startAngle);
  }

  @override
  get endX {
    final center = game.circleCenter;
    return getXPosOnCircle(center.centerX, _heightRadius, endAngle);
  }

  @override
  get endY {
    final center = game.circleCenter;
    return getYPosOnCircle(center.centerY, _heightRadius, endAngle);
  }

  CurvePlatform({
    required this.height,
    required super.startAngle,
    required super.endAngle,
    required super.startAngleDeg,
    required super.endAngleDeg,
    super.color = Colors.green,
    super.strokeWidth,
    super.isDanger,
    super.dangerPlatformType,
    super.rotatePlatformImageAngle,
  });

  @override
  void move(double delta) {
    startAngle = updateAngle(startAngle, delta);
    endAngle = updateAngle(endAngle, delta);
    startAngleDeg = updateAngleDeg(startAngleDeg, delta);
    endAngleDeg = updateAngleDeg(endAngleDeg, delta);
  }
}

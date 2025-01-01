import 'dart:math';

import 'package:circle_jump/Enums/platform_type.dart';
import 'package:circle_jump/Models/game.dart';
import 'package:flutter/material.dart';

import '../../utils.dart';
import '../circle_center.dart';

class PlatformModel {
  PlatformType type;
  double startHeight;
  double endHeight;
  double startAngle;
  double endAngle;

  Color color;
  double strokeWidth;

  get _startHeightRadius {
    final center = game.circleCenter;
    return center.radius + startHeight;
  }

  get _endHeightRadius {
    final center = game.circleCenter;
    return center.radius + endHeight;
  }

  get sweepAngle {
    double angle = (endAngle - startAngle) % (2 * pi);
    if (angle <= 0) {
      angle += 2 * pi;
    }
    return angle;
  }

  get startX {
    final center = game.circleCenter;
    return getXPosOnCircle(center.centerX, _startHeightRadius, startAngle);
  }

  get startY {
    final center = game.circleCenter;
    return getYPosOnCircle(center.centerY, _startHeightRadius, startAngle);
  }

  get endX {
    final center = game.circleCenter;
    return getXPosOnCircle(center.centerX, _endHeightRadius, endAngle);
  }

  get endY {
    final center = game.circleCenter;
    return getYPosOnCircle(center.centerY, _endHeightRadius, endAngle);
  }

  PlatformModel.curved({
    required height,
    required this.startAngle,
    required this.endAngle,
    this.color = Colors.brown,
    this.strokeWidth = 15.0,
  })  : type = PlatformType.curved,
        startHeight = height,
        endHeight = height;

  PlatformModel.ramp({
    required this.startHeight,
    required this.endHeight,
    required this.startAngle,
    required this.endAngle,
    this.color = Colors.green,
    this.strokeWidth = 15.0,
  }) : type = PlatformType.ramp;

  void move(double delta) {
    startAngle = (startAngle - delta) % (2 * pi);
    endAngle = (endAngle - delta) % (2 * pi);

    if (startAngle < 0) {
      startAngle += 2 * pi;
    }
    if (endAngle < 0) {
      endAngle += 2 * pi;
    }
  }
}

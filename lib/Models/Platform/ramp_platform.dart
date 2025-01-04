import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/game.dart';
import 'package:flutter/material.dart';

import '../../utils.dart';

class RampPlatform extends PlatformModel {
  double startHeight;
  double endHeight;

  get _startHeightRadius {
    final center = game.circleCenter;
    return center.radius + startHeight;
  }

  get _endHeightRadius {
    final center = game.circleCenter;
    return center.radius + endHeight;
  }

  @override
  get startX {
    final center = game.circleCenter;
    return getXPosOnCircle(center.centerX, _startHeightRadius, startAngle);
  }

  @override
  get startY {
    final center = game.circleCenter;
    return getYPosOnCircle(center.centerY, _startHeightRadius, startAngle);
  }

  @override
  get endX {
    final center = game.circleCenter;
    return getXPosOnCircle(center.centerX, _endHeightRadius, endAngle);
  }

  @override
  get endY {
    final center = game.circleCenter;
    return getYPosOnCircle(center.centerY, _endHeightRadius, endAngle);
  }

  RampPlatform({
    required this.startHeight,
    required this.endHeight,
    required super.startAngle,
    required super.endAngle,
    required super.startAngleDeg,
    required super.endAngleDeg,
    super.color = Colors.green,
    super.strokeWidth,
  });

  @override
  void move(double delta) {
    startAngle = updateAngle(startAngle, delta);
    endAngle = updateAngle(endAngle, delta);
    startAngleDeg = updateAngleDeg(startAngleDeg, delta);
    endAngleDeg = updateAngleDeg(endAngleDeg, delta);
  }
}

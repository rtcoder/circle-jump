import 'dart:math';

import 'package:circle_jump/Enums/danger_platform_type.dart';
import 'package:circle_jump/Enums/direction.dart';
import 'package:circle_jump/Models/movable.dart';
import 'package:flutter/material.dart';

enum PlatformEffect {
  normal(1),
  bounce(1),
  crumble(1),
  slow(0.65);

  final double speedMultiplier;

  const PlatformEffect(this.speedMultiplier);
}

enum TerrainTheme {
  summer,
  winter,
  road,
  grass,
  desert,
  stone,
  ice,
  volcanic,
  ruins,
}

class SurfaceProfile {
  final double amplitude;
  final double frequency;
  final double phase;

  static const flat = SurfaceProfile();

  const SurfaceProfile({
    this.amplitude = 0,
    this.frequency = 0,
    this.phase = 0,
  });

  bool get isFlat {
    return amplitude == 0 || frequency == 0;
  }

  double offsetAt(double progress) {
    if (isFlat) {
      return 0;
    }
    final clampedProgress = progress.clamp(0, 1).toDouble();
    return sin(clampedProgress * frequency * 2 * pi + phase) * amplitude;
  }
}

abstract class PlatformModel extends Movable {
  double startAngle;
  double endAngle;
  double startAngleDeg;
  double endAngleDeg;
  Color color;
  double strokeWidth;
  final bool isDanger;
  final DangerPlatformType? dangerPlatformType;
  final Direction? imageDirection;
  final PlatformEffect effect;
  TerrainTheme terrain;
  SurfaceProfile surfaceProfile;
  bool isConsumed = false;

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
    this.strokeWidth = 20.0,
    this.isDanger = false,
    this.dangerPlatformType,
    this.imageDirection,
    this.effect = PlatformEffect.normal,
    this.terrain = TerrainTheme.grass,
    this.surfaceProfile = SurfaceProfile.flat,
  }) : assert(
          !isDanger || dangerPlatformType != null,
          'dangerPlatformType must be provided when isDanger is true',
        );

  void markConsumed() {
    isConsumed = true;
  }
}

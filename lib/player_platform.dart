import 'package:circle_jump/game.dart';
import 'package:circle_jump/platform.dart';
import 'package:flutter/material.dart';

class PlayerPlatform {
  PlatformModel? isOnAnyPlatform(double playerY) {
    final List<PlatformModel> platformsOn = [];
    for (final PlatformModel platform in game.platforms) {
      if (isOnPlatform(platform, playerY)) {
        platformsOn.add(platform);
      }
    }
    if (platformsOn.isEmpty) {
      return null;
    }

    return platformsOn.reduce((p, next) => p.height > next.height ? p : next);
  }

  bool isOnPlatform(PlatformModel platform, double playerY) {
    const double threshold = 20.0;
    final playerX = game.screenSize.width / 2;
    final bool isWithinHeight = (playerY - platform.height).abs() < threshold;
    final PlatformPositions pos = platform.getStartAndEndPosition();
    final bool isBetweenEdges = pos.startX <= playerX && playerX <= pos.endX;
    final bool result = isWithinHeight && isBetweenEdges;
    return result;
  }
}

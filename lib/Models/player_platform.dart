import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/game.dart';
import 'package:circle_jump/Models/height_on_platform.dart';

import '../Enums/platform_type.dart';

class PlayerPlatform {
  final double _heightThreshold = 20;

  HeightOnPlatform? isOnAnyPlatform(double playerX, double playerY) {
    HeightOnPlatform? highestPlatform;

    for (final PlatformModel platform in game.platforms) {
      final HeightOnPlatform? result = isOnPlatform(platform, playerY);
      if (result != null) {
        if (highestPlatform == null || result.height > highestPlatform.height) {
          highestPlatform = result;
        }
      }
    }

    return highestPlatform;
  }

  double getPlayerHeightOnPlatform(PlatformModel platform) {
    if (platform.type == PlatformType.curved) {
      return platform.startHeight;
    }

    final double totalWidth = platform.endX - platform.startX;
    if (totalWidth == 0) {
      return platform.startHeight;
    }

    final double playerPercentage =
        (game.player.playerX - platform.startX) / totalWidth;

    return platform.startHeight +
        (platform.endHeight - platform.startHeight) * playerPercentage;
  }

  HeightOnPlatform? isOnPlatform(PlatformModel platform, double playerY) {
    final bool isBetweenEdges = _isBetweenEdges(platform);
    if (!isBetweenEdges) {
      return null;
    }
    if (platform.type == PlatformType.ramp) {
      return isOnRamp(platform, playerY);
    } else {
      return isOnCurve(platform, playerY);
    }
  }

  HeightOnPlatform? isOnRamp(PlatformModel platform, double playerY) {
    final double expectedHeight = getPlayerHeightOnPlatform(platform);

    final bool withinHeight =
        (playerY - expectedHeight).abs() <= _heightThreshold;

    return withinHeight ? HeightOnPlatform(expectedHeight) : null;
  }

  HeightOnPlatform? isOnCurve(PlatformModel platform, double playerY) {
    final bool isWithinHeight =
        (playerY - platform.startHeight).abs() < _heightThreshold;
    return isWithinHeight ? HeightOnPlatform(platform.startHeight) : null;
  }

  bool _isBetweenEdges(PlatformModel platform) {
    final double playerX = game.player.playerX;
    return playerX >= platform.startX && playerX <= platform.endX;
  }

}

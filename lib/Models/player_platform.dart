import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/game.dart';
import 'package:circle_jump/Models/Platform/height_on_platform.dart';

import '../Enums/platform_type.dart';

class PlayerPlatform {
  final double _heightThreshold = 20;

  HeightOnPlatform? isOnAnyPlatform(double playerY) {
    HeightOnPlatform? closestPlatform;
    double closestDistance = double.infinity;

    for (final PlatformModel platform in game.platforms) {
      final HeightOnPlatform? result = _isOnPlatform(platform, playerY);

      if (result != null) {
        final double distance = (playerY - result.height).abs();

        if (distance < closestDistance) {
          closestPlatform = result;
          closestDistance = distance;
        }
      }
    }

    return closestPlatform;
  }

  double _getPlayerHeightOnPlatform(PlatformModel platform) {
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

  HeightOnPlatform? _isOnPlatform(PlatformModel platform, double playerY) {
    final bool isBetweenEdges = _isBetweenEdges(platform);
    if (!isBetweenEdges) {
      return null;
    }
    if (platform.type == PlatformType.ramp) {
      return _isOnRamp(platform, playerY);
    } else {
      return _isOnCurve(platform, playerY);
    }
  }

  HeightOnPlatform? _isOnRamp(PlatformModel platform, double playerY) {
    final double expectedHeight = _getPlayerHeightOnPlatform(platform);

    final bool withinHeight =
        (playerY - expectedHeight).abs() <= _heightThreshold;

    return withinHeight
        ? HeightOnPlatform(expectedHeight, platform.strokeWidth)
        : null;
  }

  HeightOnPlatform? _isOnCurve(PlatformModel platform, double playerY) {
    final bool isWithinHeight =
        (playerY - platform.startHeight).abs() < _heightThreshold;
    return isWithinHeight
        ? HeightOnPlatform(platform.startHeight, platform.strokeWidth)
        : null;
  }

  bool _isBetweenEdges(PlatformModel platform) {
    final double playerX = game.player.playerX;
    return playerX >= platform.startX && playerX <= platform.endX;
  }

}

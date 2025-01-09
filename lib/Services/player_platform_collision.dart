import 'package:circle_jump/Models/Platform/curve_platform.dart';
import 'package:circle_jump/Models/Platform/height_on_platform.dart';
import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/Platform/ramp_platform.dart';
import 'package:circle_jump/Models/game.dart';

class PlayerPlatformCollision {
  final double _heightThreshold = 20;

  HeightOnPlatform? isOnAnyPlatform(double playerY) {
    HeightOnPlatform? closestPlatform;
    double closestDistance = double.infinity;

    for (final PlatformModel platform
        in game.world.getPlatforms(onlyVisible: true)) {
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
    if (platform is CurvePlatform) {
      return _getPlayerHeightOnPlatformCurve(platform);
    }
    if (platform is RampPlatform) {
      return _getPlayerHeightOnPlatformRamp(platform);
    }
    return 0;
  }

  double _getPlayerHeightOnPlatformCurve(CurvePlatform platform) {
    return platform.height;
  }

  double _getPlayerHeightOnPlatformRamp(RampPlatform platform) {
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
    if (platform is RampPlatform) {
      return _isOnRamp(platform, playerY);
    }
    if (platform is CurvePlatform) {
      return _isOnCurve(platform, playerY);
    }
    return null;
  }

  HeightOnPlatform? _isOnRamp(RampPlatform platform, double playerY) {
    final double expectedHeight = _getPlayerHeightOnPlatform(platform);

    final bool withinHeight =
        (playerY - expectedHeight).abs() <= _heightThreshold;

    return withinHeight
        ? HeightOnPlatform(expectedHeight, platform.strokeWidth)
        : null;
  }

  HeightOnPlatform? _isOnCurve(CurvePlatform platform, double playerY) {
    final bool isWithinHeight =
        (playerY - platform.height).abs() < _heightThreshold;
    return isWithinHeight
        ? HeightOnPlatform(platform.height, platform.strokeWidth)
        : null;
  }

  bool _isBetweenEdges(PlatformModel platform) {
    final double playerX = game.player.playerX;
    return playerX >= platform.startX && playerX <= platform.endX;
  }
}

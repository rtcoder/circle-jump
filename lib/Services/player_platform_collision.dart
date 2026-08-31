import 'package:circle_jump/Models/Platform/curve_platform.dart';
import 'package:circle_jump/Models/Platform/height_on_platform.dart';
import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/Platform/ramp_platform.dart';
import 'package:circle_jump/Models/game.dart';

enum PlayerPlatformCollisionType { none, landed, hitCeiling, hitDanger }

class PlayerPlatformCollisionResult {
  final PlayerPlatformCollisionType type;
  final double height;
  final double strokeWidth;
  final PlatformEffect effect;
  final TerrainTheme terrain;
  final PlatformModel? platform;

  const PlayerPlatformCollisionResult({
    required this.type,
    this.height = 0,
    this.strokeWidth = 0,
    this.effect = PlatformEffect.normal,
    this.terrain = TerrainTheme.grass,
    this.platform,
  });

  factory PlayerPlatformCollisionResult.fromContact(
    HeightOnPlatform? contact, {
    required double previousPlayerY,
    required double velocityY,
  }) {
    if (contact == null) {
      return const PlayerPlatformCollisionResult(
        type: PlayerPlatformCollisionType.none,
      );
    }
    if (contact.isDanger) {
      return PlayerPlatformCollisionResult(
        type: PlayerPlatformCollisionType.hitDanger,
        height: contact.height,
        strokeWidth: contact.strokeWidth,
        effect: contact.effect,
        terrain: contact.terrain,
        platform: contact.platform,
      );
    }
    if (velocityY >= 0 && previousPlayerY > contact.height) {
      return PlayerPlatformCollisionResult(
        type: PlayerPlatformCollisionType.landed,
        height: contact.height,
        strokeWidth: contact.strokeWidth,
        effect: contact.effect,
        terrain: contact.terrain,
        platform: contact.platform,
      );
    }
    if (velocityY < 0 && previousPlayerY < contact.height) {
      return PlayerPlatformCollisionResult(
        type: PlayerPlatformCollisionType.hitCeiling,
        height: contact.height,
        strokeWidth: contact.strokeWidth,
        effect: contact.effect,
        terrain: contact.terrain,
        platform: contact.platform,
      );
    }
    return PlayerPlatformCollisionResult(
      type: PlayerPlatformCollisionType.none,
      height: contact.height,
      strokeWidth: contact.strokeWidth,
      effect: contact.effect,
      terrain: contact.terrain,
      platform: contact.platform,
    );
  }
}

class PlayerPlatformCollision {
  final double _heightThreshold = 20;

  PlayerPlatformCollisionResult resolve({
    required double previousPlayerY,
    required double nextPlayerY,
    required double velocityY,
  }) {
    return PlayerPlatformCollisionResult.fromContact(
      isOnAnyPlatform(nextPlayerY),
      previousPlayerY: previousPlayerY,
      velocityY: velocityY,
    );
  }

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
        ? HeightOnPlatform(
            expectedHeight,
            platform.strokeWidth,
            platform.isDanger,
            effect: platform.effect,
            terrain: platform.terrain,
            platform: platform,
          )
        : null;
  }

  HeightOnPlatform? _isOnCurve(CurvePlatform platform, double playerY) {
    final bool isWithinHeight =
        (playerY - platform.height).abs() < _heightThreshold ||
            (playerY <= platform.height &&
                playerY >= platform.height - platform.strokeWidth);
    return isWithinHeight
        ? HeightOnPlatform(
            platform.height,
            platform.strokeWidth,
            platform.isDanger,
            effect: platform.effect,
            terrain: platform.terrain,
            platform: platform,
          )
        : null;
  }

  bool _isBetweenEdges(PlatformModel platform) {
    final double playerX = game.player.playerX;
    return playerX >= platform.startX && playerX <= platform.endX;
  }
}

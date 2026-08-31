import 'package:circle_jump/Generators/platform_generator.dart';
import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/World/world.dart';
import 'package:circle_jump/Models/game_circle.dart';
import 'package:circle_jump/Models/player.dart';
import 'package:circle_jump/Services/player_platform_collision.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('bounce landing launches the player upward', () {
    final player = Player();
    final platform = getCurvePlatform(0, 8, 100, effect: PlatformEffect.bounce);
    final collision = PlayerPlatformCollisionResult(
      type: PlayerPlatformCollisionType.landed,
      height: 100,
      strokeWidth: 15,
      effect: platform.effect,
      platform: platform,
    );

    player.applyPlatformCollision(collision);

    expect(player.velocityY, PlayerPhysics.standard.bounceJumpPower);
    expect(platform.isConsumed, isFalse);
  });

  test('crumble landing marks the platform as consumed', () {
    final player = Player();
    final platform =
        getCurvePlatform(0, 8, 100, effect: PlatformEffect.crumble);
    final collision = PlayerPlatformCollisionResult(
      type: PlayerPlatformCollisionType.landed,
      height: 100,
      strokeWidth: 15,
      effect: platform.effect,
      platform: platform,
    );

    player.applyPlatformCollision(collision);

    expect(platform.isConsumed, isTrue);
    expect(player.velocityY, 0);
  });

  test('slow landing applies the platform slow multiplier', () {
    final player = Player();
    final platform = getCurvePlatform(0, 8, 100, effect: PlatformEffect.slow);
    final collision = PlayerPlatformCollisionResult(
      type: PlayerPlatformCollisionType.landed,
      height: 100,
      strokeWidth: 15,
      effect: platform.effect,
      platform: platform,
    );

    player.applyPlatformCollision(collision);

    expect(player.speedMultiplier, PlatformEffect.slow.speedMultiplier);
  });

  test('world removes consumed crumble platforms during update', () {
    final world = World(seed: 1)..initWorld();
    final platform = world.getPlatforms().first;
    final countBefore = world.getPlatforms().length;

    platform.markConsumed();
    world.update(0, 1);

    expect(world.getPlatforms().length, countBefore - 1);
  });

  test('slow multiplier reduces movement angle delta', () {
    final circle = GameCircle();
    final player = Player();

    circle.update(
      player,
      const Duration(milliseconds: 16),
      PlatformEffect.slow.speedMultiplier,
    );

    expect(
      circle.movementAngleDelta,
      closeTo(circle.frameAngleDelta * PlatformEffect.slow.speedMultiplier,
          0.000001),
    );
  });
}

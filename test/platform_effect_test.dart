import 'package:circle_jump/Generators/platform_generator.dart';
import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/World/world.dart';
import 'package:circle_jump/Models/game_circle.dart';
import 'package:circle_jump/Models/player.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('bounce platform keeps the stronger jump multiplier for future hazards',
      () {
    final platform = getCurvePlatform(0, 8, 100, effect: PlatformEffect.bounce);

    expect(platform.effect, PlatformEffect.bounce);
    expect(platform.isConsumed, isFalse);
  });

  test('crumble platforms can still be consumed by future obstacle logic', () {
    final platform =
        getCurvePlatform(0, 8, 100, effect: PlatformEffect.crumble);

    platform.markConsumed();

    expect(platform.isConsumed, isTrue);
  });

  test('slow platform effect still exposes its speed multiplier', () {
    final platform = getCurvePlatform(0, 8, 100, effect: PlatformEffect.slow);

    expect(platform.effect.speedMultiplier, 0.65);
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

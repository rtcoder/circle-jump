import 'package:circle_jump/Generators/platform_generator.dart';
import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/game_circle.dart';
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

  test('slow multiplier reduces movement distance delta', () {
    final circle = GameCircle();

    circle.update(
      const Duration(milliseconds: 16),
      PlatformEffect.slow.speedMultiplier,
    );

    expect(
      circle.movementDistanceDelta,
      closeTo(circle.frameDistanceDelta * PlatformEffect.slow.speedMultiplier,
          0.000001),
    );
  });
}

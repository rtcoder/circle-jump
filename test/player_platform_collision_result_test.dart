import 'package:circle_jump/Models/Platform/height_on_platform.dart';
import 'package:circle_jump/Services/player_platform_collision.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('resolves a dangerous contact as hitDanger', () {
    final result = PlayerPlatformCollisionResult.fromContact(
      HeightOnPlatform(100, 15, true),
      previousPlayerY: 130,
      velocityY: 4,
    );

    expect(result.type, PlayerPlatformCollisionType.hitDanger);
  });

  test('resolves a downward safe contact as landed', () {
    final result = PlayerPlatformCollisionResult.fromContact(
      HeightOnPlatform(100, 15, false),
      previousPlayerY: 130,
      velocityY: 4,
    );

    expect(result.type, PlayerPlatformCollisionType.landed);
    expect(result.height, 100);
  });

  test('resolves an upward safe contact as hitCeiling', () {
    final result = PlayerPlatformCollisionResult.fromContact(
      HeightOnPlatform(100, 15, false),
      previousPlayerY: 80,
      velocityY: -4,
    );

    expect(result.type, PlayerPlatformCollisionType.hitCeiling);
  });
}

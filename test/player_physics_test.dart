import 'package:circle_jump/Models/World/world.dart';
import 'package:circle_jump/Models/game.dart';
import 'package:circle_jump/Models/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('player jump uses configured physics', () {
    final player = Player(
      physics: const PlayerPhysics(
        gravity: 0.5,
        jumpPower: -20,
        ceilingBounceFactor: 0.5,
      ),
    );

    player.jump();

    expect(player.velocityY, -20);
  });

  test('player rolls by the on-screen distance traveled', () {
    game.updateScreenSize(const Size(800, 600));
    game.restart();
    game.gameCircle.movementDistanceDelta = 1;

    game.player.update(0);

    expect(
      game.player.playerAngle,
      closeTo(World.pixelsPerMeter / game.player.radius, 0.000001),
    );
  });
}

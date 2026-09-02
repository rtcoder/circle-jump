import 'package:circle_jump/Models/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const frame = Duration(milliseconds: 16);

  test('game model updates without a widget BuildContext', () {
    game.updateScreenSize(const Size(800, 600));
    game.restart();

    game.update(frame);

    expect(game.isGameOver, isFalse);
  });

  test('restart puts the game in the playing state', () {
    game.updateScreenSize(const Size(800, 600));
    game.restart();

    expect(game.state, GameState.playing);
  });

  test('paused game does not advance', () {
    game.updateScreenSize(const Size(800, 600));
    game.restart();
    game.pause();
    final startDistance = game.world.distance;

    game.update(frame);

    expect(game.state, GameState.paused);
    expect(game.world.distance, startDistance);
  });

  test('paused game can resume updates', () {
    game.updateScreenSize(const Size(800, 600));
    game.restart();
    game.pause();
    game.resume();

    game.update(frame);

    expect(game.state, GameState.playing);
    expect(game.world.distance, greaterThan(0));
  });

  test('game update advances by the provided frame duration', () {
    game.updateScreenSize(const Size(800, 600));
    game.restart();

    game.update(frame);

    expect(game.gameCircle.lastFrameDuration, frame);
  });

  test('world distance is scaled by the provided frame duration', () {
    const longFrame = Duration(milliseconds: 32);
    game.updateScreenSize(const Size(800, 600));
    game.restart();

    game.update(longFrame);

    expect(
      game.world.distance,
      closeTo(
        game.gameCircle.speedMetersPerFrame * game.gameCircle.frameScale,
        0.000001,
      ),
    );
  });

  test('world generates more straight terrain ahead as distance advances', () {
    game.updateScreenSize(const Size(800, 600));
    game.restart();
    final generatedBefore = game.world.terrainSurface.generatedUntil;

    for (int i = 0; i < 500; i++) {
      game.update(frame);
    }

    expect(game.world.distance, greaterThan(40));
    expect(
        game.world.terrainSurface.generatedUntil, greaterThan(generatedBefore));
  });
}

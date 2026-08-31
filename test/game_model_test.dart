import 'dart:math';

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
    final startAngle = game.gameCircle.angle;

    game.update(frame);

    expect(game.state, GameState.paused);
    expect(game.gameCircle.angle, startAngle);
  });

  test('paused game can resume updates', () {
    game.updateScreenSize(const Size(800, 600));
    game.restart();
    game.pause();
    game.resume();

    game.update(frame);

    expect(game.state, GameState.playing);
    expect(game.gameCircle.angle, isNot(0));
  });

  test('game update advances by the provided frame duration', () {
    game.updateScreenSize(const Size(800, 600));
    game.restart();

    game.update(frame);

    expect(game.gameCircle.lastFrameDuration, frame);
  });

  test('world movement is scaled by the provided frame duration', () {
    const longFrame = Duration(milliseconds: 32);
    game.updateScreenSize(const Size(800, 600));
    game.restart();
    final platform = game.world.getPlatforms().first;
    final startAngleDeg = platform.startAngleDeg;

    game.update(longFrame);

    expect(
      platform.startAngleDeg,
      closeTo(
        startAngleDeg -
            game.gameCircle.angleDelta *
                game.gameCircle.frameScale *
                180 /
                pi,
        0.000001,
      ),
    );
  });
}

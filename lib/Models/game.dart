import 'package:circle_jump/Models/World/world.dart';
import 'package:circle_jump/Models/circle_center.dart';
import 'package:circle_jump/Models/game_circle.dart';
import 'package:circle_jump/Models/player.dart';
import 'package:flutter/material.dart';

enum GameState { playing, paused, gameOver }

class _Game {
  GameState state = GameState.playing;
  Player player = Player();
  late Size screenSize;
  late CircleCenter circleCenter;
  bool gameInitialized = false;
  final World world = World();
  final GameCircle gameCircle = GameCircle();

  bool get isGameOver {
    return state == GameState.gameOver;
  }

  String get distanceHuman {
    return gameCircle.distanceHuman;
  }

  void endGame() {
    state = GameState.gameOver;
  }

  void pause() {
    if (state == GameState.playing) {
      state = GameState.paused;
    }
  }

  void resume() {
    if (state == GameState.paused) {
      state = GameState.playing;
    }
  }

  void updateScreenSize(Size newVal) {
    screenSize = newVal;
    circleCenter = CircleCenter.getCenterOfCircle(screenSize);
  }

  void init() {
    if (gameInitialized) {
      return;
    }
    world.initWorld();
    gameInitialized = true;
  }

  void restart() {
    gameInitialized = false;
    gameCircle.clear();
    world.clear();
    player.restart();
    init();
    state = GameState.playing;
  }

  void update(Duration frameDuration) {
    if (state != GameState.playing) {
      return;
    }
    gameCircle.update(frameDuration, player.speedMultiplier);
    world.update(gameCircle.movementDistanceDelta, gameCircle.frameScale);
    player.update(gameCircle.frameScale);
  }
}

final game = _Game();

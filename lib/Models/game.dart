import 'package:circle_jump/Models/World/world.dart';
import 'package:circle_jump/Models/circle_center.dart';
import 'package:circle_jump/Models/game_circle.dart';
import 'package:circle_jump/Models/player.dart';
import 'package:flutter/material.dart';

class _Game {
  bool isGameOver = false;
  final double gravity = 0.5;
  Player player = Player();
  late Size screenSize;
  late CircleCenter circleCenter;
  bool gameInitialized = false;
  final World world = World();
  final GameCircle gameCircle = GameCircle();

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
    isGameOver = false;
  }

  void update(BuildContext context) {
    if (isGameOver) {
      return;
    }
    gameCircle.update(player);
    world.update(gameCircle);
    player.update(context);
  }
}

final game = _Game();

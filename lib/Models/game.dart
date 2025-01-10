import 'package:circle_jump/Models/World/world.dart';
import 'package:circle_jump/Models/circle_center.dart';
import 'package:circle_jump/Models/game_circle.dart';
import 'package:circle_jump/Models/player.dart';
import 'package:flutter/material.dart';

class _Game {
  final double gravity = 0.5;
  double distance = 0;
  double lastWorldUpdateAngleDeg = 0;
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

  void update(BuildContext context) {
    gameCircle.update(player);
    world.update(gameCircle);
    player.update(context);
  }
}

final game = _Game();

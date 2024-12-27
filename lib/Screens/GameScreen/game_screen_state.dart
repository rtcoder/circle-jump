import 'package:circle_jump/game.dart';
import 'package:circle_jump/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Background/animated_background.dart';
import '../../Obstacles/obstacle.dart';
import '../../Obstacles/obstacle_generator.dart';
import '../../Painters/obstacle_painter.dart';
import '../../Painters/player_painter.dart';
import 'VisualComponents/distance_text.dart';
import 'game_screen.dart';
import '../../images.dart';

class GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  double playerY = 0;
  bool isJumping = false;
  double jumpSize = 200;
  final jumpDurationMs = 500;
  late AnimationController _controller;
  List<Obstacle> obstacles = []; // Lista przeszkód

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: jumpDurationMs),
      vsync: this,
    )..addListener(() {
        setState(() {
          player.playerY = player.jumpSize * (_controller.value);
        });
      });

    loadImages(context);

    // Inicjalizacja przeszkód
    obstacles = obstacleGenerator(10);

    // Timer do aktualizacji przeszkód
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 16));
      setState(() {
        game.updateDistance();
        for (var obstacle in obstacles) {
          obstacle.updateAngle();
        }
      });
      return true;
    });
  }

  void _jump() {
    if (player.isJumping) {
      return;
    }
    setState(() {
      player.isJumping = true;
    });
    _controller.forward(from: 0.0);
    Future.delayed(Duration(milliseconds: jumpDurationMs), () {
      setState(() {
        player.isJumping = false;
      });
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!imagesInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final size = MediaQuery.of(context).size;

    return Focus(
      autofocus: true,
      onKeyEvent: (FocusNode node, KeyEvent event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
          _jump();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTapDown: (_) => _jump(),
        child: Stack(
          children: [
            const AnimatedBackground(),
            CustomPaint(
              size: size,
              foregroundPainter: ObstaclePainter(
                obstacles: obstacles,
              ),
            ),
            CustomPaint(
              size: size,
              foregroundPainter: PlayerPainter(),
            ),
            distanceText(game.distance),
          ],
        ),
      ),
    );

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';

import 'Background/animated_background.dart';
import 'Obstacles/obstacle.dart';
import 'Obstacles/obstacle_generator.dart';
import 'Painters/circle_painter.dart';
import 'Painters/obstacle_painter.dart';
import 'Painters/player_painter.dart';
import 'Screens/game_screen.dart';

class GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  double playerY = 0;
  bool isJumping = false;
  double jumpSize = 200;
  final jumpDurationMs = 200;
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
          playerY = jumpSize * (_controller.value);
        });
      });

    // Inicjalizacja przeszkód
    obstacles = obstacleGenerator(10);

    // Timer do aktualizacji przeszkód
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 16));
      setState(() {
        for (var obstacle in obstacles) {
          obstacle.updateAngle();
        }
      });
      return true;
    });
  }

  void _jump() {
    if (isJumping) {
      return;
    }
    setState(() {
      isJumping = true;
    });
    _controller.forward(from: 0.0);
    Future.delayed(Duration(milliseconds: jumpDurationMs), () {
      setState(() {
        isJumping = false;
      });
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: _jump,
      child: Stack(
        children: [
          const AnimatedBackground(),
          CustomPaint(
            size: Size(size.width, size.height),
            painter: CirclePainter(),
            foregroundPainter: ObstaclePainter(
              obstacles: obstacles,
            ),
          ),
          CustomPaint(
            size: Size(size.width, size.height),
            foregroundPainter: PlayerPainter(
              playerY: (size.height / 2) - playerY,
              isJumping: isJumping,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

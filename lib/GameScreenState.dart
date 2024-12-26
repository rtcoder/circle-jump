import 'dart:math';

import 'package:flutter/material.dart';
import 'Painters/CirclePainter.dart';
import 'GameScreen.dart';
import 'Obstacle.dart';
import 'Painters/ObstaclePainter.dart';
import 'Painters/PlayerPainter.dart';

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
    obstacles = List.generate(
      5,
      (index) => Obstacle(
        angle: index * pi / 2.5,
        speed: 0.02,
        clockwise: index % 2 == 0,
      ),
    );

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
      child: CustomPaint(
        size: Size(size.width, size.height),
        painter: CirclePainter(),
        foregroundPainter: ObstaclePainter(
          obstacles: obstacles,
        ),
        child: CustomPaint(
          foregroundPainter: PlayerPainter(
            playerY: (size.height / 2) - playerY,
            isJumping: isJumping,
          ),
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

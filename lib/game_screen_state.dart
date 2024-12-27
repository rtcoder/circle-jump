import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'Background/animated_background.dart';
import 'Obstacles/obstacle.dart';
import 'Obstacles/obstacle_generator.dart';
import 'Painters/obstacle_painter.dart';
import 'Painters/player_painter.dart';
import 'Screens/game_screen.dart';
import 'utils.dart';

class ImagesList {
  static const String circle = 'assets/images/circle.png';
  static const String cloud = 'assets/images/cloud.png';
  static const String ball = 'assets/images/ball.png';
}
class Images {
  ui.Image? cloudImage;
  ui.Image? circleImage;
  ui.Image? ballImage;
}

class GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  double playerY = 0;
  bool isJumping = false;
  double jumpSize = 200;
  final jumpDurationMs = 500;
  late AnimationController _controller;
  List<Obstacle> obstacles = []; // Lista przeszkód
  bool _imagesInitialized = false;
  final Images _images = Images();
   double _playerAngle = 0;

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

    _loadImages();

    // Inicjalizacja przeszkód
    obstacles = obstacleGenerator(10);

    // Timer do aktualizacji przeszkód
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 16));
      setState(() {
        _playerAngle += calculatePlayerAngleDelta();
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

  Future<ui.Image> _loadImage(String path) async {
    final data = await DefaultAssetBundle.of(context).load(path);
    final bytes = data.buffer.asUint8List();
    final image = await decodeImageFromList(bytes);
    return image;
  }

  Future<void> _loadImages() async {
    final cloudImage = await _loadImage(ImagesList.cloud);
    final circleImage = await _loadImage(ImagesList.circle);
    final ballImage = await _loadImage(ImagesList.ball);

    setState(() {
      _images.cloudImage = cloudImage;
      _images.circleImage = circleImage;
      _images.ballImage = ballImage;
      _imagesInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_imagesInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTapDown: (_) => _jump(),
      child: Stack(
        children: [
          AnimatedBackground(images: _images,),
          CustomPaint(
            size: Size(size.width, size.height),
            foregroundPainter: ObstaclePainter(
              obstacles: obstacles,
            ),
          ),
          CustomPaint(
            size: Size(size.width, size.height),
            foregroundPainter: PlayerPainter(
              playerY: (size.height / 2) - playerY,
              isJumping: isJumping,
              playerImage: _images.ballImage!,
              playerAngle: _playerAngle,
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

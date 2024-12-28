import 'package:circle_jump/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Background/animated_background.dart';
import '../../Painters/obstacle_painter.dart';
import '../../Painters/platform_painter.dart';
import '../../Painters/player_painter.dart';
import '../../images.dart';
import 'VisualComponents/distance_text.dart';
import 'game_screen.dart';

class GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: game.player.jumpDurationMs),
      vsync: this,
    )..addListener(() {
        setState(() {
          game.player.playerY = game.player.jumpSize * (_controller.value);
        });
      });

    loadImages(context);

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 16));
      setState(() {
        game.update();
      });
      return true;
    });
  }

  void _jump() {
    if (game.player.isJumping) {
      return;
    }
    setState(() {
      game.player.isJumping = true;
    });
    _controller.forward(from: 0.0);
    Future.delayed(Duration(milliseconds: game.player.jumpDurationMs), () {
      setState(() {
        game.player.isJumping = false;
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
      onKeyEvent: (FocusNode node, KeyEvent ev) {
        if (ev is KeyDownEvent && ev.logicalKey == LogicalKeyboardKey.space) {
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
              foregroundPainter: ObstaclePainter(),
            ),
            CustomPaint(
              size: size,
              foregroundPainter: PlayerPainter(),
            ),
            CustomPaint(
              painter: PlatformPainter(),
              child: Container(),
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

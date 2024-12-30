import 'package:circle_jump/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Background/animated_background.dart';
import '../../Painters/obstacle_painter.dart';
import '../../Painters/platform_painter.dart';
import '../../Painters/player_painter.dart';
import '../../images.dart';
import 'game_screen.dart';

class GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

    loadImages(context);

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 16));
      setState(() {
        game.update();
      });
      return true;
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
          game.player.jump();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTapDown: (_) => game.player.jump(),
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
            // distanceText(game.distanceHuman),
          ],
        ),
      ),
    );
  }
}

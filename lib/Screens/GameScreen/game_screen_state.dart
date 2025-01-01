import 'package:circle_jump/Models/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Background/animated_background.dart';
import '../../Painters/obstacle_painter.dart';
import '../../Painters/platform_painter.dart';
import '../../Painters/player_painter.dart';
import 'game_screen.dart';

class GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    if (mounted) {
      setState(() {
        game.init();
      });
    }
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 16));
      if (mounted) {
        setState(() {
          final size = MediaQuery.of(context).size;
          game.updateScreenSize(size);
          game.update();
        });
      }
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              painter: PlatformPainter(),
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

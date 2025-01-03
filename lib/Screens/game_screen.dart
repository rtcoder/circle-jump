import 'package:circle_jump/Painters/point_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Background/animated_background.dart';
import '../Models/game.dart';
import '../Models/point.dart';
import '../Painters/obstacle_painter.dart';
import '../Painters/platform_painter.dart';
import '../Painters/player_painter.dart';
import '../Widgets/collected_point.dart';
import '../Widgets/points_counter.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  int points = 0;
  final List<Widget> animatedPoints = [];

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
          game.update();
          handlePointCollection();
        });
      }
      return true;
    });
  }

  void onPointCollected(Offset startPosition) {
    final UniqueKey key = UniqueKey();

    setState(() {
      animatedPoints.add(
        CollectedPoint(
          key: key,
          startPosition: startPosition,
          onAnimationEnd: () {
            setState(() {
              animatedPoints.removeWhere((widget) => widget.key == key);
              points++; // Zwiększenie licznika punktów
            });
          },
        ),
      );
    });
  }



  void handlePointCollection() {
    final List<Point> collectedPoints = game.collectPoints();

    for (final point in collectedPoints) {
      final Offset startPosition = Offset(point.x, point.y);
      onPointCollected(startPosition);
    }
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
              painter: PointPainter(),
            ),
            CustomPaint(
              size: size,
              foregroundPainter: PlayerPainter(),
            ),
            ...animatedPoints,
            PointsCounter(
              points: game.player.score,
            ),
            // distanceText(game.distanceHuman),
          ],
        ),
      ),
    );
  }
}

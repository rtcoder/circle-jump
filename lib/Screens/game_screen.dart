import 'package:circle_jump/Painters/coins_painter.dart';
import 'package:circle_jump/Services/player_coin_collision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Background/animated_background.dart';
import '../Models/game.dart';
import '../Models/Coin/coin.dart';
import '../Painters/obstacle_painter.dart';
import '../Painters/platform_painter.dart';
import '../Painters/player_painter.dart';
import '../Widgets/collected_coin.dart';
import '../Widgets/coins_counter.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  int coins = 0;
  final List<Widget> animatedCoins = [];

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
          handleCoinCollection();
        });
      }
      return true;
    });
  }

  void onCoinCollected(Offset startPosition) {
    final UniqueKey key = UniqueKey();

    setState(() {
      animatedCoins.add(
        CollectedCoin(
          key: key,
          startPosition: startPosition,
          onAnimationEnd: () {
            setState(() {
              animatedCoins.removeWhere((widget) => widget.key == key);
              coins++; // Zwiększenie licznika punktów
            });
          },
        ),
      );
    });
  }

  void handleCoinCollection() {
    final List<Coin> collectedCoins = PlayerCoinCollision.collectCoins();

    for (final coin in collectedCoins) {
      final Offset startPosition = Offset(coin.x, coin.y);
      onCoinCollected(startPosition);
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
              painter: CoinsPainter(),
            ),
            CustomPaint(
              size: size,
              foregroundPainter: PlayerPainter(),
            ),
            ...animatedCoins,
            CoinsCounter(
              coins: game.player.score,
            ),
            // distanceText(game.distanceHuman),
          ],
        ),
      ),
    );
  }
}

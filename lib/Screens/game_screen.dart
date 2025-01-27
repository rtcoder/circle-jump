import 'package:circle_jump/Background/animated_background.dart';
import 'package:circle_jump/Models/Coin/coin.dart';
import 'package:circle_jump/Models/game.dart';
import 'package:circle_jump/Painters/coins_painter.dart';
import 'package:circle_jump/Painters/platform_painter.dart';
import 'package:circle_jump/Painters/player_painter.dart';
import 'package:circle_jump/Services/player_coin_collision.dart';
import 'package:circle_jump/Widgets/coins_counter.dart';
import 'package:circle_jump/Widgets/collected_coin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        game.restart();
      });
    }
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 16));
      if (mounted) {
        setState(() {
          game.update(context);
          handleCoinCollection();
        });
        if(game.isGameOver){
          return false;
        }
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

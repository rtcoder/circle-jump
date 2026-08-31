import 'package:circle_jump/Background/animated_background.dart';
import 'package:circle_jump/Models/Coin/coin.dart';
import 'package:circle_jump/Models/game.dart';
import 'package:circle_jump/Painters/coins_painter.dart';
import 'package:circle_jump/Painters/platform_painter.dart';
import 'package:circle_jump/Painters/player_painter.dart';
import 'package:circle_jump/Screens/game_over_screen.dart';
import 'package:circle_jump/Services/player_coin_collision.dart';
import 'package:circle_jump/Services/high_score_store.dart' as scores;
import 'package:circle_jump/Widgets/coins_counter.dart';
import 'package:circle_jump/Widgets/collected_coin.dart';
import 'package:circle_jump/Widgets/distance_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class GameScreen extends StatefulWidget {
  final scores.HighScoreStore highScoreStore;

  GameScreen({
    super.key,
    scores.HighScoreStore? highScoreStore,
  }) : highScoreStore = highScoreStore ?? scores.highScoreStore;

  @override
  State<GameScreen> createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  final List<Widget> animatedCoins = [];
  late final Ticker _gameTicker;
  Duration _lastTick = Duration.zero;
  bool _didNavigateToGameOver = false;

  @override
  void initState() {
    super.initState();

    game.restart();
    _gameTicker = createTicker((elapsed) {
      if (!mounted) {
        _gameTicker.stop();
        return;
      }
      if (game.isGameOver) {
        _handleGameOver();
        return;
      }

      final frameDuration =
          _lastTick == Duration.zero ? Duration.zero : elapsed - _lastTick;
      _lastTick = elapsed;

      setState(() {
        game.update(frameDuration);
        handleCoinCollection();
      });

      if (game.isGameOver && !_didNavigateToGameOver) {
        _handleGameOver();
      }
    });
    _gameTicker.start();
  }

  @override
  void dispose() {
    _gameTicker.dispose();
    super.dispose();
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

  void _togglePause() {
    setState(() {
      if (game.state == GameState.paused) {
        game.resume();
        _lastTick = Duration.zero;
      } else if (game.state == GameState.playing) {
        game.pause();
      }
    });
  }

  void _restartGame() {
    setState(() {
      game.restart();
      _lastTick = Duration.zero;
      _didNavigateToGameOver = false;
      _gameTicker.start();
    });
  }

  void _handleGameOver() {
    if (_didNavigateToGameOver) {
      return;
    }
    _didNavigateToGameOver = true;
    _gameTicker.stop();
    widget.highScoreStore.recordScore(game.player.score);
    Navigator.pushNamed(
      context,
      '/game-over',
      arguments: GameOverResult(
        score: game.player.score,
        distance: game.distanceHuman,
        highScore: widget.highScoreStore.bestScore,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Focus(
      autofocus: true,
      onKeyEvent: (FocusNode node, KeyEvent ev) {
        if (ev is KeyDownEvent && ev.logicalKey == LogicalKeyboardKey.escape) {
          _togglePause();
          return KeyEventResult.handled;
        }
        if (ev is KeyDownEvent && ev.logicalKey == LogicalKeyboardKey.space) {
          if (game.state == GameState.playing) {
            game.player.jump();
          }
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTapDown: (_) {
          if (game.state == GameState.playing) {
            game.player.jump();
          }
        },
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
            DistanceTextWidget(distance: game.distanceHuman),
            if (game.state == GameState.paused)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.55),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Paused',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: _togglePause,
                              child: const Text('Resume'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: _restartGame,
                              child: const Text('Restart'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

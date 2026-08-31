import 'package:circle_jump/Widgets/button_widget.dart';
import 'package:circle_jump/Widgets/score_widget.dart';
import 'package:circle_jump/Widgets/title_widget.dart';
import 'package:flutter/material.dart';

class GameOverResult {
  final int score;
  final String distance;
  final int highScore;

  const GameOverResult({
    required this.score,
    required this.distance,
    required this.highScore,
  });
}

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final result = args is GameOverResult
        ? args
        : GameOverResult(
            score: args is int ? args : 0,
            distance: '0m',
            highScore: args is int ? args : 0,
          );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TitleWidget('Game Over', color: Colors.red),
            const SizedBox(height: 20),
            ScoreWidget(score: result.score),
            const SizedBox(height: 12),
            Text(
              'Distance: ${result.distance}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Best: ${result.highScore}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ButtonWidget('Play Again', onPressed: () {
              Navigator.pushReplacementNamed(context, '/game');
            }),
          ],
        ),
      ),
    );
  }
}

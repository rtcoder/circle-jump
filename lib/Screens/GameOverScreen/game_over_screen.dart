import 'package:circle_jump/Widgets/score_widget.dart';
import 'package:flutter/material.dart';

import 'VisualComponents/game_over_text.dart';
import 'VisualComponents/play_again_btn.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final score = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            gameOverText,
            const SizedBox(height: 20),
            ScoreWidget(score: score),
            const SizedBox(height: 20),
            playAgainBtn(context),
          ],
        ),
      ),
    );
  }
}

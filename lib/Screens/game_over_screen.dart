import 'package:circle_jump/Widgets/button_widget.dart';
import 'package:circle_jump/Widgets/score_widget.dart';
import 'package:circle_jump/Widgets/title_widget.dart';
import 'package:flutter/material.dart';

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
            const TitleWidget('Game Over', color: Colors.red),
            const SizedBox(height: 20),
            ScoreWidget(score: score),
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

import 'package:circle_jump/Widgets/button_widget.dart';
import 'package:circle_jump/Widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StartScreen extends StatelessWidget {
  final int highScore;

  const StartScreen({super.key, this.highScore = 0});

  @override
  Widget build(BuildContext context) {
    return Focus(
        autofocus: true,
        onKeyEvent: (FocusNode node, KeyEvent event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            Navigator.pushNamed(context, '/game');
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TitleWidget('Circle Jump'),
                const SizedBox(height: 12),
                Text(
                  'Best: $highScore',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ButtonWidget('Start Game', onPressed: () {
                  Navigator.pushNamed(context, '/game');
                }),
              ],
            ),
          ),
        ));
  }
}

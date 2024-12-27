import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'VisualComponents/start_game_btn.dart';
import 'VisualComponents/title_text.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (FocusNode node, KeyEvent event) {
        if (event is KeyDownEvent
            && event.logicalKey == LogicalKeyboardKey.enter) {
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
              titleText,
              const SizedBox(height: 20),
              startGameBtn(context),
            ],
          ),
        ),
      )
    );
  }
}

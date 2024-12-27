import 'package:flutter/material.dart';

import 'Screens/game_over_screen.dart';
import 'Screens/GameScreen/game_screen.dart';
import 'Screens/start_screen.dart';

class CircleJump extends StatelessWidget {
  const CircleJump({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circle Jump',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const StartScreen(),
        '/game': (context) => const GameScreen(),
        '/game-over': (context) => const GameOverScreen(),
      },
    );
  }
}

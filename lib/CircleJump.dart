import 'package:flutter/material.dart';

import 'GameOverScreen.dart';
import 'GameScreen.dart';
import 'StartScreen.dart';

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

import 'package:flutter/material.dart';

class ScoreWidget extends StatelessWidget {
  final String score;

  const ScoreWidget({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Score: $score',
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

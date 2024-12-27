import 'package:flutter/material.dart';

ElevatedButton playAgainBtn(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      Navigator.pushReplacementNamed(context, '/game');
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
    ),
    child: const Text('Play Again'),
  );
}
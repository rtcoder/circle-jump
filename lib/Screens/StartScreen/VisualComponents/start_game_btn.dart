import 'package:flutter/material.dart';

ElevatedButton startGameBtn(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      Navigator.pushNamed(context, '/game');
    },
    style: ElevatedButton.styleFrom(
      padding:
      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      backgroundColor: Colors.blue,
    ),
    child: const Text(
      'Start Game',
      style: TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
    ),
  );
}
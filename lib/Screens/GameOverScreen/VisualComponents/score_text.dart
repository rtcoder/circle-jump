import 'package:flutter/material.dart';

Text scoreText(String score) {
  return  Text(
    'Score: $score',
    style: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  );
}
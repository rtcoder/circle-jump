import 'package:flutter/material.dart';

class ObstaclePainter extends CustomPainter {
  final List<Offset> obstaclePositions; // Lista pozycji przeszkód

  ObstaclePainter({required this.obstaclePositions});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    for (final position in obstaclePositions) {
      canvas.drawCircle(
          position, 10, paint); // Rysowanie przeszkód jako zielonych kółek
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Zawsze przerysowuj, gdy zmienia się pozycja przeszkód
  }
}

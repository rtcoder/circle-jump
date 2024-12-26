import 'dart:math';

import 'package:flutter/material.dart';

import '../utils.dart';

class SunMoonPainter extends CustomPainter {
  final double time; // Czas w cyklu dnia (0.0 - 1.0)

  SunMoonPainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    var center = getCenterOfCircle(size);
    final centerX = center.centerX;
    final centerY = center.centerY;
    final radius = center.radius + 250;

    final timeShift = (time <= 0.5 ? 0 : 0.5) + 0.1;

    // Pozycja na łuku w zależności od czasu
    final angle = -pi * (time - timeShift); // Od 0 do pi (wschód -> zachód)
    final x = centerX + radius * cos(angle - pi / 2);
    final y = centerY + radius * sin(angle - pi / 2);

    // Rysowanie słońca/księżyca
    if (time <= 0.5) {
      // Dzień
      paint.color = Colors.yellow; // Słońce
      canvas.drawCircle(Offset(x, y), 30, paint);
    } else {
      // Noc
      paint.color = Colors.grey; // Księżyc
      canvas.drawCircle(Offset(x, y), 30, paint);

      // Rysowanie kraterów na księżycu
      paint.color = Color(0x1701011E); // Kolor tła, aby krater był widoczny na tle księżyca
      canvas.drawCircle(Offset(x - 10, y - 10), 5, paint);
      canvas.drawCircle(Offset(x + 8, y + 12), 4, paint);
      canvas.drawCircle(Offset(x + 15, y - 5), 6, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

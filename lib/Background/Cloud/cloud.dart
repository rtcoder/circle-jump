import 'dart:math';

class Cloud {
  double heightOverGround; // Pozycja Y chmury
  double size; // Rozmiar chmury
  double speed; // Szybkość przesuwania
  double angle; // Szybkość przesuwania
  double opacity; // Szybkość przesuwania

  Cloud({
    required this.heightOverGround,
    required this.size,
    required this.speed,
    required this.angle,
    required this.opacity,
  });

  double _calculateRadius(double radius) {
    return radius + heightOverGround;
  }

  double calculateX(double centerX, double radius) {
    return centerX + _calculateRadius(radius) * cos(angle);
  }

  double calculateY(double centerY, double radius) {
    return centerY + _calculateRadius(radius) * sin(angle);
  }
}

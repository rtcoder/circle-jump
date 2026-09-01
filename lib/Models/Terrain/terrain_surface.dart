import 'dart:math';

class TerrainSurface {
  final double baseHeight;
  final double amplitude;
  final double frequency;
  final double phase;

  static const plain = TerrainSurface();

  const TerrainSurface({
    this.baseHeight = 0,
    this.amplitude = 26,
    this.frequency = 5,
    this.phase = 0,
  });

  double heightAtAngle(double angle) {
    return baseHeight + sin(angle * frequency + phase) * amplitude;
  }
}

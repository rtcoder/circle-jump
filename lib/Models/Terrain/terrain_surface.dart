import 'dart:math';

class TerrainPoint {
  final double distance;
  final double height;

  const TerrainPoint({
    required this.distance,
    required this.height,
  });
}

class TerrainSurface {
  static const double initialLength = 200;
  static const double chunkLength = 100;
  static const double pointSpacing = 10;
  static const double minHeight = -28;
  static const double maxHeight = 42;

  final List<TerrainPoint> points;

  TerrainSurface({
    List<TerrainPoint> points = const [
      TerrainPoint(distance: 0, height: 0),
      TerrainPoint(distance: initialLength, height: 0),
    ],
  }) : points = List.of(points)
          ..sort((a, b) => a.distance.compareTo(b.distance));

  factory TerrainSurface.generateInitial({Random? random}) {
    final surface = TerrainSurface(points: const [
      TerrainPoint(distance: 0, height: 0),
    ]);
    surface.ensureGeneratedThrough(initialLength, random: random);
    return surface;
  }

  double get generatedUntil {
    return points.last.distance;
  }

  double heightAtDistance(double distance) {
    if (points.isEmpty) {
      return 0;
    }
    if (distance <= points.first.distance) {
      return points.first.height;
    }
    if (distance >= points.last.distance) {
      return points.last.height;
    }

    for (int i = 0; i < points.length - 1; i++) {
      final start = points[i];
      final end = points[i + 1];
      if (distance >= start.distance && distance <= end.distance) {
        final progress =
            (distance - start.distance) / (end.distance - start.distance);
        return start.height + (end.height - start.height) * progress;
      }
    }

    return points.last.height;
  }

  void ensureGeneratedThrough(double distance, {Random? random}) {
    final rand = random ?? Random();
    while (generatedUntil < distance) {
      _appendChunk(rand);
    }
  }

  void _appendChunk(Random random) {
    final targetDistance = generatedUntil + chunkLength;
    double nextDistance = generatedUntil + pointSpacing;
    double lastHeight = points.last.height;

    while (nextDistance <= targetDistance) {
      final slope = (random.nextDouble() * 28) - 14;
      lastHeight = (lastHeight + slope).clamp(minHeight, maxHeight).toDouble();
      points.add(TerrainPoint(distance: nextDistance, height: lastHeight));
      nextDistance += pointSpacing;
    }
  }
}

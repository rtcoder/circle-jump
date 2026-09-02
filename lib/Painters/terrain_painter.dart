import 'package:circle_jump/Models/game.dart';
import 'package:flutter/material.dart';

class TerrainPainter extends CustomPainter {
  static const double pixelsPerMeter = 8;
  static const double _grassStrokeWidth = 7;

  final Color earthColor;
  final Color grassColor;

  const TerrainPainter({
    this.earthColor = const Color(0xFF7A4A24),
    this.grassColor = const Color(0xFF49B83F),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final grassPath = Path();
    final fillPath = Path();
    final baselineY = game.world.terrainBaselineY(size.height);

    for (int x = 0; x <= size.width.ceil(); x++) {
      final distance = game.world.screenXToWorldDistance(
        x.toDouble(),
        size.width,
      );
      final terrainY =
          baselineY - game.world.terrainHeightAtWorldDistance(distance);

      if (x == 0) {
        grassPath.moveTo(x.toDouble(), terrainY);
        fillPath.moveTo(x.toDouble(), terrainY);
      } else {
        grassPath.lineTo(x.toDouble(), terrainY);
        fillPath.lineTo(x.toDouble(), terrainY);
      }
    }

    fillPath
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final earthPaint = Paint()
      ..color = earthColor
      ..style = PaintingStyle.fill;
    final grassPaint = Paint()
      ..color = grassColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = _grassStrokeWidth;

    canvas.drawPath(fillPath, earthPaint);
    canvas.drawPath(grassPath, grassPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

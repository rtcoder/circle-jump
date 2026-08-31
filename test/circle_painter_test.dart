import 'package:circle_jump/Painters/circle_painter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CirclePainter repaints when a new painter is provided', () {
    final painter = CirclePainter();

    expect(painter.shouldRepaint(CirclePainter()), isTrue);
  });
}

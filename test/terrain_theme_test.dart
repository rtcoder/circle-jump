import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Painters/platform_painter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('platform painter uses different tints for different terrain themes',
      () {
    final painter = PlatformPainter();

    expect(
      painter.colorFilterFor(PlatformEffect.normal, TerrainTheme.grass),
      isNot(painter.colorFilterFor(PlatformEffect.normal, TerrainTheme.ice)),
    );
  });
}

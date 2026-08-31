import 'dart:math';

import 'package:circle_jump/Generators/world_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('world generator exposes an expanded set of layout patterns', () {
    expect(worldPartPatternNames.length, greaterThanOrEqualTo(12));
  });

  test('world generator creates repeatable layouts from the same seed', () {
    final first = generateWorldPart(-80, 180, random: Random(7));
    final second = generateWorldPart(-80, 180, random: Random(7));

    expect(first.getLengthInDegrees(), second.getLengthInDegrees());
    expect(
      first.platformCollector.items.length,
      second.platformCollector.items.length,
    );
    expect(first.coinCollector.items.length, second.coinCollector.items.length);
  });
}

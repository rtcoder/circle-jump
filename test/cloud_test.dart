import 'package:circle_jump/Background/Cloud/cloud.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('cloud movement scales with frame duration', () {
    final cloud = Cloud(
      x: 900,
      y: 120,
      size: 50,
      speed: 2,
      opacity: 0.5,
    );

    cloud.move(2);

    expect(cloud.x, closeTo(896, 0.000001));
    expect(cloud.y, 120);
  });

  test('cloud wraps from left edge back to the right side', () {
    final cloud = Cloud(
      x: -160,
      y: 90,
      size: 50,
      speed: 2,
      opacity: 0.5,
    );

    cloud.move(1, screenWidth: 800);

    expect(cloud.x, 850);
  });
}

import 'package:circle_jump/Background/Cloud/cloud.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('cloud movement scales with frame duration', () {
    final cloud = Cloud(
      heightOverGround: 150,
      size: 50,
      speed: 0.001,
      angle: 1,
      opacity: 0.5,
    );

    cloud.move(2);

    expect(cloud.angle, closeTo(0.998, 0.000001));
  });
}

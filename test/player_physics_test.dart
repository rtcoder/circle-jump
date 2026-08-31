import 'package:circle_jump/Models/player.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('player jump uses configured physics', () {
    final player = Player(
      physics: const PlayerPhysics(
        gravity: 0.5,
        jumpPower: -20,
        ceilingBounceFactor: 0.5,
      ),
    );

    player.jump();

    expect(player.velocityY, -20);
  });
}

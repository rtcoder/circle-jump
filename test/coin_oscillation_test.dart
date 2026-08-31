import 'package:circle_jump/Models/Coin/coin_oscillation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    CoinOscillation.oscillationOffset = 0;
  });

  test('coin oscillation scales with frame duration', () {
    final oscillation = CoinOscillation();

    oscillation.updateOscillation(2);

    expect(CoinOscillation.oscillationOffset, 1);
  });
}

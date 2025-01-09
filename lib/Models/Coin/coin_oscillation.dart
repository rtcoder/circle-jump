class CoinOscillation {
  double _oscillationDirection = 1;
  static double oscillationOffset = 0;

  void updateOscillation() {
    oscillationOffset += _oscillationDirection * 0.5;
    if (oscillationOffset > 5 || oscillationOffset < -5) {
      _oscillationDirection *= -1;
    }
  }
}

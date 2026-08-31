class CoinOscillation {
  double _oscillationDirection = 1;
  static double oscillationOffset = 0;

  void updateOscillation(double frameScale) {
    oscillationOffset += _oscillationDirection * 0.5 * frameScale;
    if (oscillationOffset > 5 || oscillationOffset < -5) {
      _oscillationDirection *= -1;
    }
  }
}

class Cloud {
  double x;
  double y;
  double size;
  double speed;
  double opacity;

  Cloud({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });

  void move(double frameScale, {double? screenWidth}) {
    x -= speed * frameScale;

    if (screenWidth != null && x < -size * 3) {
      x = screenWidth + size;
    }
  }
}

import 'dart:math';

class PlatformModel {
  double angle;
  double radius;
  double arcLength;
  double thickness;

  PlatformModel({
    required this.angle,
    required this.radius,
    required this.arcLength,
    required this.thickness,
  });

  void move(double delta) {
    angle -= delta;
    if (angle < 0) {
      angle += 2 * pi;
    }
  }
}

List<PlatformModel> generatePlatforms(int count) {
  final rand = Random();
  const double minRadius = 100;
  const double maxRadius = 180;
  return List.generate(count, (index) {
    return PlatformModel(
      angle: rand.nextDouble() * 2 * pi,
      radius: minRadius + rand.nextDouble() * (maxRadius - minRadius),
      arcLength: pi / 8 + rand.nextDouble() * pi / 6,
      thickness: 10 + rand.nextDouble() * 10,
    );
  });
}

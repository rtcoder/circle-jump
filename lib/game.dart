import 'package:circle_jump/player.dart';

class _Game {
  double distance = 0;
  double circleAngleDelta = 0.001;
  double circleAngle = 0;
  final circleRadius = 1000.0;

  void updateDistance() {
    distance += circleAngleDelta * player.playerRadius;
  }

  void incrementCircleAngle() {
    circleAngle += circleAngleDelta;
  }

  void incrementCircleAngleDelta() {
    circleAngleDelta += 0.001;
  }
}

final game = _Game();

import 'package:circle_jump/Models/player.dart';
import 'package:circle_jump/utils.dart';

class GameCircle {
  final double _baseAngleDelta = 0.002;
  final double _maxAngleDelta = 0.005;
  double _distance = 0;
  double angleDelta = 0.002;
  double angle = 0;
  double angleDeg = 0;
  final radius = 1000.0;

  String get distanceHuman {
    if (_distance < 1000) {
      return '${_distance.toInt()}m';
    }
    return '${(_distance / 1000).toStringAsFixed(2)}km';
  }

  void update(Player player) {
    _updateDistance(player.radius);
    _updateAngleDelta();
    _incrementCircleAngle();
  }

  void _incrementCircleAngle() {
    angle += angleDelta;
    angleDeg = radiansToDegrees(angle);
  }

  void _updateAngleDelta() {
    if (_distance > 10 && angleDelta < _maxAngleDelta) {
      angleDelta = _baseAngleDelta * (1 + (_distance / 1000) * 2);
    }
  }

  void _updateDistance(double playerRadius) {
    _distance += angleDelta * playerRadius;
  }
}

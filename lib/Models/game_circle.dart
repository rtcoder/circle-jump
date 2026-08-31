import 'package:circle_jump/Models/player.dart';
import 'package:circle_jump/utils.dart';

class GameCircle {
  final double _baseAngleDelta = 0.002;
  final double _maxAngleDelta = 0.005;
  double _distance = 0;
  double angleDelta = 0.002;
  double angle = 0;
  double angleDeg = 0;
  Duration lastFrameDuration = Duration.zero;
  final radius = 1000.0;
  static const double _targetFrameMs = 1000 / 60;

  String get distanceHuman {
    if (_distance < 1000) {
      return '${_distance.toInt()}m';
    }
    return '${(_distance / 1000).toStringAsFixed(2)}km';
  }

  void clear() {
    _distance = 0;
    angleDelta = 0.002;
    angle = 0;
    angleDeg = 0;
    lastFrameDuration = Duration.zero;
  }

  double get frameScale {
    if (lastFrameDuration == Duration.zero) {
      return 1;
    }
    return lastFrameDuration.inMicroseconds / (_targetFrameMs * 1000);
  }

  double get frameAngleDelta {
    return angleDelta * frameScale;
  }

  void update(Player player, Duration frameDuration) {
    lastFrameDuration = frameDuration;
    _updateDistance(player.radius);
    _updateAngleDelta();
    _incrementCircleAngle();
  }

  void _incrementCircleAngle() {
    angle += frameAngleDelta;
    angleDeg = radiansToDegrees(angle);
  }

  void _updateAngleDelta() {
    if (_distance > 10 && angleDelta < _maxAngleDelta) {
      angleDelta = _baseAngleDelta * (1 + (_distance / 1000) * 2);
    }
  }

  void _updateDistance(double playerRadius) {
    _distance += frameAngleDelta * playerRadius;
  }
}

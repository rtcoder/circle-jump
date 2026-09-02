class GameCircle {
  static const double _targetFrameMs = 1000 / 60;
  static const double _baseSpeedMetersPerFrame = 0.12;
  static const double _maxSpeedMetersPerFrame = 0.34;

  double _distance = 0;
  double speedMetersPerFrame = _baseSpeedMetersPerFrame;
  double movementDistanceDelta = _baseSpeedMetersPerFrame;
  double angle = 0;
  double angleDeg = 0;
  final radius = 1000.0;
  Duration lastFrameDuration = Duration.zero;

  String get distanceHuman {
    if (_distance < 1000) {
      return '${_distance.toInt()}m';
    }
    return '${(_distance / 1000).toStringAsFixed(2)}km';
  }

  void clear() {
    _distance = 0;
    speedMetersPerFrame = _baseSpeedMetersPerFrame;
    movementDistanceDelta = _baseSpeedMetersPerFrame;
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

  double get frameDistanceDelta {
    return speedMetersPerFrame * frameScale;
  }

  void update(
    Duration frameDuration, [
    double speedMultiplier = 1,
  ]) {
    lastFrameDuration = frameDuration;
    movementDistanceDelta = frameDistanceDelta * speedMultiplier;
    _updateDistance();
    _updateSpeed();
  }

  void _updateSpeed() {
    if (_distance > 10 && speedMetersPerFrame < _maxSpeedMetersPerFrame) {
      speedMetersPerFrame = _baseSpeedMetersPerFrame * (1 + _distance / 900);
    }
  }

  void _updateDistance() {
    _distance += movementDistanceDelta;
  }
}

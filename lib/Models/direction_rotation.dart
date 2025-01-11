import 'package:circle_jump/Enums/direction.dart';
import 'package:circle_jump/utils.dart';

class DirectionRotation {
  static const double none = 0;
  static final double rotate90 = degreesToRadians(90);
  static final double rotate180 = degreesToRadians(180);
  static final double rotate270 = degreesToRadians(270);

  static double getRotationAngle(Direction? direction) {
    switch (direction) {
      case null:
      case Direction.none:
        return DirectionRotation.none;
      case Direction.rotate90:
        return DirectionRotation.rotate90;
      case Direction.rotate180:
        return DirectionRotation.rotate180;
      case Direction.rotate270:
        return DirectionRotation.rotate270;
    }
  }
}

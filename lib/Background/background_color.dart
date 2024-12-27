import 'dart:ui';

final lightBlue = Color(0xFF0093D9);
final darkBlue = Color(0xFF000064);
final darkBlue2 = Color(0xFF01012F);
final darkBlue3 = Color(0xFF010117);
final blue = Color(0xFF0000A8);

Color getBackgroundColor(double time) {
  if (time <= 0.125) {
    return Color.lerp(darkBlue, lightBlue, time * 8)!;
  }
  if (time > 0.125 && time <= 0.25) {
    return lightBlue;
  }
  if (time > 0.25 && time <= 0.375) {
    return Color.lerp(lightBlue, blue, (time - 0.25) * 8)!;
  }
  if (time > 0.375 && time <= 0.5) {
    return Color.lerp(blue, darkBlue, (time - 0.375) * 8)!;
  }
  if (time > 0.5 && time <= 0.625) {
    return Color.lerp(darkBlue, darkBlue2, (time - 0.5) * 8)!;
  }
  if (time > 0.625 && time <= 0.75) {
    return darkBlue2;
  }
  if (time > 0.75 && time <= 0.875) {
    return Color.lerp(darkBlue3, darkBlue, (time - 0.75) * 8)!;
  }

  return darkBlue;
}

import 'package:circle_jump/Models/Platform/platform.dart';

class HeightOnPlatform {
  final double height;
  final double strokeWidth;
  final bool isDanger;
  final PlatformEffect effect;
  final TerrainTheme terrain;
  final PlatformModel? platform;

  HeightOnPlatform(
    this.height,
    this.strokeWidth,
    this.isDanger, {
    this.effect = PlatformEffect.normal,
    this.terrain = TerrainTheme.grass,
    this.platform,
  });
}

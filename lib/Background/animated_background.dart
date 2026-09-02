import 'package:circle_jump/Background/Cloud/cloud.dart';
import 'package:circle_jump/Background/Cloud/cloud_generator.dart';
import 'package:circle_jump/Background/background_color.dart';
import 'package:circle_jump/Painters/cloud_painter.dart';
import 'package:circle_jump/Painters/sun_moon_painter.dart';
import 'package:circle_jump/Painters/terrain_painter.dart';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  static const double _targetFrameMs = 1000 / 60;
  late AnimationController _controller;
  Duration _lastElapsed = Duration.zero;
  final List<Cloud> _clouds = cloudGenerator(15);

  @override
  void initState() {
    super.initState();
    initializeBackgroundColors(1000);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateClouds(double timeDelta, double screenWidth) {
    final frameScale = timeDelta / _targetFrameMs;
    for (int i = 0; i < _clouds.length; i++) {
      final cloud = _clouds[i];
      cloud.move(frameScale, screenWidth: screenWidth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final time = _controller.value;
        final elapsed = _controller.lastElapsedDuration ?? Duration.zero;
        final timeDelta = _lastElapsed == Duration.zero
            ? _targetFrameMs
            : (elapsed - _lastElapsed).inMicroseconds / 1000;
        _lastElapsed = elapsed;

        final backgroundColor = getBackgroundColor(time);

        final size = MediaQuery.of(context).size;
        _updateClouds(timeDelta, size.width);

        return Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              color: backgroundColor,
            ),
            CustomPaint(
              size: Size(size.width, size.height),
              foregroundPainter: SunMoonPainter(time: time),
            ),
            CustomPaint(
              size: Size(size.width, size.height),
              painter: const TerrainPainter(),
            ),
            CustomPaint(
              size: Size(size.width, size.height),
              foregroundPainter: CloudPainter(
                clouds: _clouds,
              ),
            ),
          ],
        );
      },
    );
  }
}

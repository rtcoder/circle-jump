import 'package:circle_jump/Background/Cloud/cloud.dart';
import 'package:circle_jump/Background/Cloud/cloud_generator.dart';
import 'package:circle_jump/Background/background_color.dart';
import 'package:circle_jump/Painters/circle_painter.dart';
import 'package:circle_jump/Painters/cloud_painter.dart';
import 'package:circle_jump/Painters/sun_moon_painter.dart';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
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

  void _updateClouds(double timeDelta) {
    for (int i = 0; i < _clouds.length; i++) {
      final cloud = _clouds[i];
      cloud.angle -= cloud.speed; // * timeDelta; // Ruch w lewo
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final time = _controller.value;
        final timeDelta = _controller.lastElapsedDuration?.inMilliseconds ?? 16;

        _updateClouds(timeDelta / 1000.0);

        final backgroundColor = getBackgroundColor(time);

        final size = MediaQuery.of(context).size;

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
              painter: CirclePainter(),
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

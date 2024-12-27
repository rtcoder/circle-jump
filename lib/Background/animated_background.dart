import 'dart:ui' as ui;

import 'package:circle_jump/Background/Cloud/cloud_generator.dart';
import 'package:flutter/material.dart';

import '../Painters/circle_painter.dart';
import '../Painters/cloud_painter.dart';
import '../Painters/sun_moon_painter.dart';
import '../game_screen_state.dart';
import '../utils.dart';
import 'Cloud/cloud.dart';
import 'background_color.dart';

class AnimatedBackground extends StatefulWidget {
  final Images images;
  const AnimatedBackground({super.key, required this.images});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState(images: images);
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Cloud> _clouds = [];
  bool _cloudsInitialized = false;
  final Images images;
  double _angle = 0;

  _AnimatedBackgroundState({required this.images});

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 16));
      setState(() {
        _angle += circleAngleDelta;
      });
      return true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Inicjalizacja chmur w odpowiednim momencie cyklu życia widgetu
    if (!_cloudsInitialized) {
      _clouds.addAll(cloudGenerator(5));
      _cloudsInitialized = true;
    }
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
              painter: CirclePainter(
                  circleImage: images.circleImage!, angle: _angle),
            ),
            CustomPaint(
              size: Size(size.width, size.height),
              foregroundPainter: CloudPainter(
                clouds: _clouds, // Generacja chmur
                cloudImage: images.cloudImage!,
              ),
            ),
          ],
        );
      },
    );
  }
}

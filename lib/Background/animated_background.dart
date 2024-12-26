import 'package:circle_jump/Background/Cloud/cloud_generator.dart';
import 'package:flutter/material.dart';

import '../Painters/cloud_painter.dart';
import '../Painters/sun_moon_painter.dart';
import 'Cloud/cloud.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Cloud> _clouds = [];
  bool _cloudsInitialized = false;

  @override
  void initState() {
    super.initState();

    // Animacja kontrolera
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 5),
    )..repeat(); // Powtarzanie cyklu
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

  // Aktualizowanie pozycji chmur
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

        // Aktualizacja pozycji chmur
        _updateClouds(timeDelta / 1000.0); // Przeliczenie na sekundy

        final backgroundColor = Color.lerp(
          Color(0xFF0093D9),
          Color(0xFF010117),
          time <= 0.5 ? time * 2 : (1 - time) * 2,
        );

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
              foregroundPainter: CloudPainter(clouds: _clouds),
            ),
          ],
        );
      },
    );
  }
}

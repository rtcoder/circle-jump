import 'package:flutter/material.dart';

import '../Painters/sun_moon_painter.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Animacja kontrolera - 5 minut na dzień i noc
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 1),
    )..repeat(); // Powtarzanie cyklu
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final time = _controller.value;

        final backgroundColor = Color.lerp(
          Color(0xFF0093D9),
          Color(0xFF010117),
          time <= 0.5 ? time * 2 : (1 - time) * 2,
        );

        return CustomPaint(
          foregroundPainter: SunMoonPainter(time: time),
          child: Container(
            color: backgroundColor,
          ),
        );
      },
    );
  }
}

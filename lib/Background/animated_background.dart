import 'dart:ui' as ui;

import 'package:circle_jump/Background/Cloud/cloud_generator.dart';
import 'package:flutter/material.dart';

import '../Painters/cloud_painter.dart';
import '../Painters/sun_moon_painter.dart';
import 'Cloud/cloud.dart';
import 'background_color.dart';

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
  ui.Image? _cloudImage;

  @override
  void initState() {
    super.initState();

    // Animacja kontrolera
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 5),
    )..repeat(); // Powtarzanie cyklu

    _loadCloudImage();
  }

  Future<void> _loadCloudImage() async {
    // Ładowanie obrazka z assetów
    final data =
        await DefaultAssetBundle.of(context).load('assets/images/cloud.png');
    final bytes = data.buffer.asUint8List();
    final image = await decodeImageFromList(bytes);
    setState(() {
      _cloudImage = image;
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

  // Aktualizowanie pozycji chmur
  void _updateClouds(double timeDelta) {
    for (int i = 0; i < _clouds.length; i++) {
      final cloud = _clouds[i];
      cloud.angle -= cloud.speed; // * timeDelta; // Ruch w lewo
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cloudImage == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final time = _controller.value;
        final timeDelta = _controller.lastElapsedDuration?.inMilliseconds ?? 16;

        // Aktualizacja pozycji chmur
        _updateClouds(timeDelta / 1000.0); // Przeliczenie na sekundy

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
              foregroundPainter: CloudPainter(
                clouds: _clouds, // Generacja chmur
                cloudImage: _cloudImage!,
              ),
            ),
          ],
        );
      },
    );
  }
}

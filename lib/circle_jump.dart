import 'package:circle_jump/Widgets/loading_screen.dart';
import 'package:flutter/material.dart';

import 'Models/game.dart';
import 'Screens/game_over_screen.dart';
import 'Screens/game_screen.dart';
import 'Screens/start_screen.dart';
import 'images.dart';

class CircleJump extends StatefulWidget {
  const CircleJump({super.key});

  @override
  State<CircleJump> createState() => _CircleJumpState();
}

class _CircleJumpState extends State<CircleJump> {
  bool isLoading = true;
  double loadingProgress = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (mounted) {
      setState(() {
        final size = MediaQuery.of(context).size;
        game.updateScreenSize(size);
      });
    }
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    if (imagesInitialized || !isLoading) {
      return;
    }
    try {
      final loader = ImageLoader(context);
      final List<Future<void>> loadTasks = [
        loader.loadImage(ImagesList.cloud).then((image) {
          Images.cloudImage = image;
          _updateProgress(20);
        }),
        loader.loadImage(ImagesList.circle).then((image) {
          Images.circleImage = image;
          _updateProgress(20);
        }),
        loader.loadImage(ImagesList.ball).then((image) {
          Images.ballImage = image;
          _updateProgress(20);
        }),
        loader.loadImage(ImagesList.block).then((image) {
          Images.blockImage = image;
          _updateProgress(20);
        }),
        loader.loadImage(ImagesList.coin).then((image) {
          Images.coinImage = image;
          _updateProgress(20);
        }),
      ];

      await Future.wait(loadTasks);

      setState(() {
        imagesInitialized = true;
        isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('Error during image loading: $e');
      debugPrint(stackTrace.toString());
      setState(() {
        isLoading = false;
        imagesInitialized = false;
      });
    }
  }

  void _updateProgress(double progress) {
    setState(() {
      loadingProgress += progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circle Jump',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: isLoading
          ? LoadingScreen(loadingProgress: loadingProgress)
          : const StartScreen(),
      routes: {
        '/game': (context) => const GameScreen(),
        '/game-over': (context) => const GameOverScreen(),
      },
    );
  }
}

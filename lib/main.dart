import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const CircleJump());
}

class CircleJump extends StatelessWidget {
  const CircleJump({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circle Jump',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const StartScreen(),
        '/game': (context) => const GameScreen(),
        '/game-over': (context) => const GameOverScreen(),
      },
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Circle Jump',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/game');
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Start Game',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  double playerY = 0; // Początkowa pozycja Y gracza
  bool isJumping = false; // Zmienna informująca, czy gracz skacze
  double jumpSize = 200;
  final jumpDurationMs = 200;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: jumpDurationMs),
      vsync: this,
    )..addListener(() {
        setState(() {
          playerY = jumpSize * (_controller.value);
        });
      });
  }

  void _jump() {
    if (isJumping) {
      return;
    }
    setState(() {
      isJumping = true;
    });
    _controller.forward(from: 0.0); // Uruchom animację skoku
    Future.delayed(Duration(milliseconds: jumpDurationMs), () {
      setState(() {
        isJumping = false; // Po zakończeniu skoku
      });
      _controller.reverse(); // Wracanie do pierwotnej pozycji po skoku
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: _jump,
      child: CustomPaint(
        size: Size(size.width, size.height),
        painter: CirclePainter(),
        foregroundPainter: PlayerPainter(
          playerY: (size.height / 2) - playerY,
          isJumping: isJumping,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Obstacle {
  double angle;
  final double speed;
  final bool clockwise;

  Obstacle({required this.angle, required this.speed, required this.clockwise});

  void updateAngle() {
    if (clockwise) {
      angle += speed;
    } else {
      angle -= speed;
    }

    // Utrzymanie kąta w zakresie 0-2π
    angle %= 2 * pi;
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final maxSize = max(size.width, size.height);
    final radius = maxSize; // Promień okręgu = wysokość ekranu

    // Środek okręgu
    final centerX = size.width / 2;
    final centerY = size.height / 2 + radius;

    // Rysowanie pełnego okręgu o promieniu = wysokość ekranu
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final score = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Game Over',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Score: $score',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/game');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text('Play Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerPainter extends CustomPainter {
  final double playerY; // Zmienna do przechowywania pozycji Y gracza
  final bool isJumping; // Zmienna informująca, czy gracz skacze

  // Konstruktor przyjmujący stan skoku i pozycję Y
  PlayerPainter({required this.playerY, required this.isJumping});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    // Pozycja gracza na osi X zawsze w centrum ekranu
    final playerX = size.width / 2;

    // Rysowanie gracza (np. czerwone kółko) na dynamicznej pozycji Y
    canvas.drawCircle(Offset(playerX, playerY), 20, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Zawsze przerysowuj, gdy zmienia się pozycja
  }
}

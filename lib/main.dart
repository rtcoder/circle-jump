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
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double playerDistance = 100.0; // Odległość gracza od środka okręgu
  bool isJumping = false;
  int _score = 0; // Licznik punktów

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
  }

  void _jump() {
    if (!isJumping) {
      setState(() {
        isJumping = true;
        _score++; // Zwiększamy liczbę punktów przy każdym skoku
      });

      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          playerDistance += 50;
        });
      }).then((_) {
        Future.delayed(const Duration(milliseconds: 200), () {
          setState(() {
            playerDistance -= 50;
            isJumping = false;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _jump,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final centerX = MediaQuery.of(context).size.width / 2;
            final centerY = MediaQuery.of(context).size.height / 2;

            final x = centerX + playerDistance * cos(_animation.value);
            final y = centerY + playerDistance * sin(_animation.value);

            return Stack(
              children: [
                // Okrąg
                CustomPaint(
                  size: Size.infinite,
                  painter: CirclePainter(),
                ),
                // Gracz (czerwona kropka)
                Positioned(
                  left: x - 10,
                  top: y - 10,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Wyświetlanie punktów
                Positioned(
                  top: 50,
                  right: 20,
                  child: Text(
                    'Score: $_score',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            );
          },
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

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      100,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final double loadingProgress;

  const LoadingScreen({super.key, required this.loadingProgress});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              'Loading: ${(loadingProgress).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

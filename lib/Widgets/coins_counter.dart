import 'package:flutter/material.dart';

import '../Painters/collected_coin_painter.dart';

class CoinsCounter extends StatelessWidget {
  final int coins;

  const CoinsCounter({
    super.key,
    required this.coins,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 20,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomPaint(
              size: const Size(20, 20),
              painter: CollectedCoinPainter(),
            ),
            const SizedBox(width: 8),
            Text(
              coins.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

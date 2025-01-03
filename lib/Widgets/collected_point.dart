import 'package:flutter/material.dart';

import '../Painters/coin_painter.dart';

class CollectedPoint extends StatefulWidget {
  final Offset startPosition;
  final VoidCallback onAnimationEnd;

  const CollectedPoint({
    super.key,
    required this.startPosition,
    required this.onAnimationEnd,
  });

  @override
  State<CollectedPoint> createState() => _CollectedPointState();
}

class _CollectedPointState extends State<CollectedPoint> {
  late Offset currentPosition;

  @override
  void initState() {
    super.initState();
    currentPosition = widget.startPosition;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        currentPosition = const Offset(20, 20);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      left: currentPosition.dx,
      top: currentPosition.dy,
      onEnd: widget.onAnimationEnd,
      child: CustomPaint(
        size: const Size(30, 30),
        painter: CoinPainter(),
      ),
    );
  }
}

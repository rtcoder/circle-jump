import 'package:circle_jump/Painters/collected_coin_painter.dart';
import 'package:flutter/material.dart';

class CollectedCoin extends StatefulWidget {
  final Offset startPosition;
  final VoidCallback onAnimationEnd;

  const CollectedCoin({
    super.key,
    required this.startPosition,
    required this.onAnimationEnd,
  });

  @override
  State<CollectedCoin> createState() => _CollectedCoinState();
}

class _CollectedCoinState extends State<CollectedCoin> {
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
        painter: CollectedCoinPainter(),
      ),
    );
  }
}

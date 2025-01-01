import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String text;
  final Color color;

  const TitleWidget(this.text, {super.key, this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}

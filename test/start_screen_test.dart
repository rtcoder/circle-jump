import 'package:circle_jump/Screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('start screen shows the best score', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: StartScreen(highScore: 9),
      ),
    );

    expect(find.text('Best: 9'), findsOneWidget);
  });
}

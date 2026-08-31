import 'package:circle_jump/Models/game.dart';
import 'package:circle_jump/Screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('game screen shows the current distance', (tester) async {
    game.updateScreenSize(const Size(800, 600));

    await tester.pumpWidget(
      const MaterialApp(
        home: GameScreen(),
      ),
    );

    expect(find.text('Distance: 0m'), findsOneWidget);
  });

  testWidgets('escape pauses the game and shows pause actions', (tester) async {
    game.updateScreenSize(const Size(800, 600));

    await tester.pumpWidget(
      const MaterialApp(
        home: GameScreen(),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();

    expect(game.state, GameState.paused);
    expect(find.text('Paused'), findsOneWidget);
    expect(find.text('Resume'), findsOneWidget);
    expect(find.text('Restart'), findsOneWidget);
  });
}

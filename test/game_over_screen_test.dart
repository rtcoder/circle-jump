import 'package:circle_jump/Screens/game_over_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('game over screen shows score and distance', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        initialRoute: '/game-over',
        onGenerateRoute: _buildGameOverRoute,
      ),
    );

    expect(find.text('Score: 12'), findsOneWidget);
    expect(find.text('Distance: 345m'), findsOneWidget);
  });
}

Route<dynamic> _buildGameOverRoute(RouteSettings settings) {
  return MaterialPageRoute<void>(
    settings: RouteSettings(
      name: settings.name,
      arguments: const GameOverResult(score: 12, distance: '345m'),
    ),
    builder: (_) => const GameOverScreen(),
  );
}

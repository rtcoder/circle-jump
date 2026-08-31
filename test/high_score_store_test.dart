import 'dart:io';

import 'package:circle_jump/Services/high_score_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('circle_jump_score_test');
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  test('high score starts at zero when no save exists', () {
    final store = HighScoreStore(filePath: '${tempDir.path}/score.txt');

    store.load();

    expect(store.bestScore, 0);
  });

  test('high score records only better scores and persists them', () {
    final path = '${tempDir.path}/score.txt';
    final store = HighScoreStore(filePath: path);

    expect(store.recordScore(12), isTrue);
    expect(store.recordScore(8), isFalse);

    final reloaded = HighScoreStore(filePath: path)..load();
    expect(reloaded.bestScore, 12);
  });
}

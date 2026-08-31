import 'dart:io';

class HighScoreStore {
  final File? _file;
  int bestScore = 0;

  HighScoreStore({String? filePath}) : _file = File(filePath ?? _defaultPath());

  HighScoreStore.memory() : _file = null;

  void load() {
    final file = _file;
    if (file == null || !file.existsSync()) {
      bestScore = 0;
      return;
    }

    bestScore = int.tryParse(file.readAsStringSync().trim()) ?? 0;
  }

  bool recordScore(int score) {
    if (score <= bestScore) {
      return false;
    }
    bestScore = score;
    _save();
    return true;
  }

  void _save() {
    final file = _file;
    if (file == null) {
      return;
    }
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(bestScore.toString());
  }

  static String _defaultPath() {
    final home = Platform.environment['HOME'];
    if (home == null || home.isEmpty) {
      return '${Directory.systemTemp.path}/circle_jump/high_score.txt';
    }
    return '$home/.circle_jump/high_score.txt';
  }
}

final highScoreStore = HighScoreStore();

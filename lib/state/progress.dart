import 'package:flutter/foundation.dart';

import '../data/progress_store.dart';

String dayKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// XP, accuracy, daily streak and in-session combo.
class Progress extends ChangeNotifier {
  Progress(this._store, {DateTime Function()? clock})
    : _now = clock ?? DateTime.now;

  final ProgressStore _store;
  final DateTime Function() _now;

  int xp = 0, correct = 0, answered = 0, dayStreak = 0, combo = 0;
  String _lastDay = '';

  double get accuracy => answered == 0 ? 0 : correct / answered;

  Future<void> load() async {
    final d = await _store.load();
    xp = d['xp'] as int;
    correct = d['correct'] as int;
    answered = d['answered'] as int;
    dayStreak = d['streak'] as int;
    _lastDay = d['lastDay'] as String;
    // Streak breaks if more than one day has passed.
    final today = _now();
    if (_lastDay != dayKey(today) &&
        _lastDay != dayKey(today.subtract(const Duration(days: 1)))) {
      dayStreak = 0;
    }
    notifyListeners();
  }

  /// Records an answer; returns XP earned.
  int record({required bool isCorrect}) {
    final today = _now();
    final key = dayKey(today);
    if (_lastDay != key) {
      final continues =
          _lastDay == dayKey(today.subtract(const Duration(days: 1)));
      dayStreak = continues ? dayStreak + 1 : 1;
      _lastDay = key;
    }
    answered++;
    var gained = 0;
    if (isCorrect) {
      correct++;
      combo++;
      gained = 10 + (combo > 1 ? (combo - 1).clamp(0, 5) * 2 : 0);
      xp += gained;
    } else {
      combo = 0;
    }
    notifyListeners();
    _store.save({
      'xp': xp,
      'correct': correct,
      'answered': answered,
      'streak': dayStreak,
      'lastDay': _lastDay,
    });
    return gained;
  }
}

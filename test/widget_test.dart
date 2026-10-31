import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unigram/data/progress_store.dart';
import 'package:unigram/data/question_repository.dart';
import 'package:unigram/main.dart';
import 'package:unigram/state/progress.dart';

class MemStore implements ProgressStore {
  Map<String, Object> d = {
    'xp': 0,
    'correct': 0,
    'answered': 0,
    'streak': 0,
    'lastDay': '',
  };
  @override
  Future<Map<String, Object>> load() async => Map.of(d);
  @override
  Future<void> save(Map<String, Object> data) async => d = data;
}

void main() {
  test('streak increments daily and combo adds bonus XP', () {
    var now = DateTime(2026, 1, 1);
    final p = Progress(MemStore(), clock: () => now);
    expect(p.record(isCorrect: true), 10);
    expect(p.record(isCorrect: true), 12);
    expect(p.dayStreak, 1);
    now = DateTime(2026, 1, 2);
    p.record(isCorrect: false);
    expect(p.dayStreak, 2);
    expect(p.combo, 0);
    now = DateTime(2026, 1, 5);
    p.record(isCorrect: true);
    expect(p.dayStreak, 1);
  });

  testWidgets('answering a question shows feedback', (t) async {
    final p = Progress(MemStore());
    await t.pumpWidget(
      UnigramApp(repository: MockQuestionRepository(), progress: p),
    );
    await t.pumpAndSettle();
    await t.tap(find.byType(InkWell).last);
    await t.pumpAndSettle();
    expect(p.answered, 1);
    expect(find.textContaining('Swipe up for the next one'), findsOneWidget);
  });
}

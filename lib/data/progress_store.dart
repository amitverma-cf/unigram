import 'package:shared_preferences/shared_preferences.dart';

/// Persists user progress. Replace with a backend-backed store for sync.
abstract class ProgressStore {
  Future<Map<String, Object>> load();
  Future<void> save(Map<String, Object> data);
}

class LocalProgressStore implements ProgressStore {
  @override
  Future<Map<String, Object>> load() async {
    final p = await SharedPreferences.getInstance();
    return {
      'xp': p.getInt('xp') ?? 0,
      'correct': p.getInt('correct') ?? 0,
      'answered': p.getInt('answered') ?? 0,
      'streak': p.getInt('streak') ?? 0,
      'lastDay': p.getString('lastDay') ?? '',
    };
  }

  @override
  Future<void> save(Map<String, Object> d) async {
    final p = await SharedPreferences.getInstance();
    for (final e in d.entries) {
      final v = e.value;
      if (v is int) await p.setInt(e.key, v);
      if (v is String) await p.setString(e.key, v);
    }
  }
}

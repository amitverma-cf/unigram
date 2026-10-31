import '../models/question.dart';
import 'mock_questions.dart';

/// Source of quiz questions. Implement this for a backend (e.g. Supabase)
/// and swap it in `main.dart`; the UI only depends on this interface.
abstract class QuestionRepository {
  Future<List<Question>> fetchFeed({int limit = 50});
}

class MockQuestionRepository implements QuestionRepository {
  @override
  Future<List<Question>> fetchFeed({int limit = 50}) async {
    final list = List<Question>.of(mockQuestions)..shuffle();
    return list.take(limit).toList();
  }
}

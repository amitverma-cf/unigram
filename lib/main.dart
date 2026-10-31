import 'package:flutter/material.dart';

import 'data/progress_store.dart';
import 'data/question_repository.dart';
import 'screens/feed_screen.dart';
import 'state/progress.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final progress = Progress(LocalProgressStore());
  await progress.load();
  // Swap MockQuestionRepository for a backend-backed one here.
  runApp(UnigramApp(repository: MockQuestionRepository(), progress: progress));
}

class UnigramApp extends StatelessWidget {
  const UnigramApp({
    super.key,
    required this.repository,
    required this.progress,
  });
  final QuestionRepository repository;
  final Progress progress;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Unigram',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true).copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF7C4DFF),
        brightness: Brightness.dark,
      ),
    ),
    home: FeedScreen(repository: repository, progress: progress),
  );
}

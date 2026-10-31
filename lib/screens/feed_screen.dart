import 'package:flutter/material.dart';

import '../data/question_repository.dart';
import '../models/question.dart';
import '../state/progress.dart';
import '../widgets/question_card.dart';
import '../widgets/stats_bar.dart';

/// Vertical swipe feed: one question per page.
class FeedScreen extends StatefulWidget {
  const FeedScreen({
    super.key,
    required this.repository,
    required this.progress,
  });
  final QuestionRepository repository;
  final Progress progress;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _questions = <Question>[];
  bool _loading = true, _fetching = false;

  @override
  void initState() {
    super.initState();
    _more();
  }

  Future<void> _more() async {
    if (_fetching) return;
    _fetching = true;
    final next = await widget.repository.fetchFeed();
    if (!mounted) return;
    setState(() {
      _questions.addAll(next);
      _loading = false;
    });
    _fetching = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _questions.length,
            onPageChanged: (i) {
              if (i >= _questions.length - 3) {
              _more();
            }
            },
            itemBuilder: (_, i) => QuestionCard(
              key: ValueKey('$i-${_questions[i].id}'),
              question: _questions[i],
              progress: widget.progress,
            ),
          ),
          SafeArea(child: StatsBar(progress: widget.progress)),
        ],
      ),
    );
  }
}

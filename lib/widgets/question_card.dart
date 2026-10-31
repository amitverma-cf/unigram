import 'package:flutter/material.dart';

import '../models/question.dart';
import '../state/progress.dart';

const _gradients = [
  [Color(0xFF1A237E), Color(0xFF4A148C)],
  [Color(0xFF004D40), Color(0xFF01579B)],
  [Color(0xFF880E4F), Color(0xFF311B92)],
  [Color(0xFFBF360C), Color(0xFF4A148C)],
];

class QuestionCard extends StatefulWidget {
  const QuestionCard({
    super.key,
    required this.question,
    required this.progress,
  });
  final Question question;
  final Progress progress;

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  int? _picked;
  int _gained = 0;

  void _pick(int i) {
    if (_picked != null) return;
    final ok = i == widget.question.answerIndex;
    setState(() {
      _picked = i;
      _gained = widget.progress.record(isCorrect: ok);
    });
  }

  Color _optionColor(int i) {
    if (_picked == null) return Colors.white12;
    if (i == widget.question.answerIndex) return Colors.green.shade700;
    if (i == _picked) return Colors.red.shade700;
    return Colors.white10;
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    final g = _gradients[q.id.hashCode.abs() % _gradients.length];
    final correct = _picked == q.answerIndex;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: g,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 90, 24, 40),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Chip(label: Text('#${q.topic}')),
              const SizedBox(height: 24),
              Text(
                q.prompt,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 24),
              for (var i = 0; i < q.options.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    color: _optionColor(i),
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => _pick(i),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            q.options[i],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                child: _picked == null
                    ? const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Pick an answer, then swipe up ↑',
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${correct ? 'Correct! +$_gained XP' : 'Not quite.'} ${q.explanation}\nSwipe up for the next one ↑',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

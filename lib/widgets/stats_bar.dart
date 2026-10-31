import 'package:flutter/material.dart';

import '../state/progress.dart';

class StatsBar extends StatelessWidget {
  const StatsBar({super.key, required this.progress});
  final Progress progress;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: progress,
    builder: (_, _) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _chip('🔥 ${progress.dayStreak}', 'day streak'),
          _chip('⚡ ${progress.combo}', 'combo'),
          _chip('⭐ ${progress.xp}', 'XP'),
          _chip('${(progress.accuracy * 100).round()}%', 'accuracy'),
        ],
      ),
    ),
  );

  Widget _chip(String v, String label) => Tooltip(
    message: label,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(v, style: const TextStyle(fontWeight: FontWeight.w600)),
    ),
  );
}

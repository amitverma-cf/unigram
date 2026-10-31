class Question {
  const Question({
    required this.id,
    required this.topic,
    required this.prompt,
    required this.options,
    required this.answerIndex,
    required this.explanation,
  });

  final String id;
  final String topic;
  final String prompt;
  final List<String> options;
  final int answerIndex;
  final String explanation;

  factory Question.fromJson(Map<String, dynamic> j) => Question(
    id: j['id'] as String,
    topic: j['topic'] as String,
    prompt: j['prompt'] as String,
    options: List<String>.from(j['options'] as List),
    answerIndex: j['answer_index'] as int,
    explanation: j['explanation'] as String? ?? '',
  );
}

// Marking a multiple-choice quiz, and the WAEC grade bands students know.
import 'dart:convert';

class const QuizQuestion({
  required final String prompt,
  required final List<String> options,

  /// The index in [options] of the right answer.
  required final int answer,
  final String explanation = '',
});

/// One question as the student answered it.
class const ReviewedAnswer({required final QuizQuestion question, required final int? chosen}) {
  bool get isRight => chosen == question.answer;
}

class const QuizResult({required final int correct, required final int total, required final List<ReviewedAnswer> review}) {
  int get percent => total == 0 ? 0 : (correct * 100 / total).round();
}

/// Marks [chosen] (one entry per question; null when skipped) against [questions].
QuizResult markQuiz(List<QuizQuestion> questions, List<int?> chosen) {
  final List<ReviewedAnswer> review = <ReviewedAnswer>[
    for (int index = 0; index < questions.length; index++)
      ReviewedAnswer(question: questions[index], chosen: index < chosen.length ? chosen[index] : null),
  ];
  return QuizResult(correct: review.where((ReviewedAnswer answer) => answer.isRight).length, total: questions.length, review: review);
}

/// The WAEC/NECO grade for a percentage.
String waecGrade(int percent) {
  if (percent >= 75) return 'A1';
  if (percent >= 70) return 'B2';
  if (percent >= 65) return 'B3';
  if (percent >= 60) return 'C4';
  if (percent >= 55) return 'C5';
  if (percent >= 50) return 'C6';
  if (percent >= 45) return 'D7';
  if (percent >= 40) return 'E8';
  return 'F9';
}

/// What is wrong with [question], or null when it can be saved.
String? questionProblem(QuizQuestion question) {
  if (question.prompt.trim().isEmpty) return 'Write the question.';
  final List<String> filled = question.options.where((String option) => option.trim().isNotEmpty).toList();
  if (filled.length < 2) return 'Give at least two options.';
  if (question.options.length > 6) return 'Keep it to six options or fewer.';
  if (question.answer < 0 || question.answer >= question.options.length || question.options[question.answer].trim().isEmpty) {
    return 'Mark which option is right.';
  }
  return null;
}

/// A quiz's questions as stored text (a model field holds a string).
String encodeQuiz(List<QuizQuestion> questions) => jsonEncode(<Map<String, Object?>>[
      for (final QuizQuestion question in questions)
        <String, Object?>{'prompt': question.prompt, 'options': question.options, 'answer': question.answer, 'explanation': question.explanation},
    ]);

/// The questions in [text], or none when it is not a stored quiz.
List<QuizQuestion> decodeQuiz(String text) {
  try {
    final Object? decoded = jsonDecode(text);
    if (decoded is! List) return const <QuizQuestion>[];
    return <QuizQuestion>[
      for (final Object? item in decoded)
        if (item is Map)
          QuizQuestion(
            prompt: '${item['prompt'] ?? ''}',
            options: <String>[for (final Object? option in (item['options'] as List? ?? const <Object?>[])) '$option'],
            answer: item['answer'] is int ? item['answer'] as int : -1,
            explanation: '${item['explanation'] ?? ''}',
          ),
    ];
  } on FormatException {
    return const <QuizQuestion>[];
  }
}

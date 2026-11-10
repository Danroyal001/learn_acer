// Exam practice: a quiz is marked the same way every time, and explains itself.
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_acer/services/quiz_rules.dart';

const List<QuizQuestion> _quiz = <QuizQuestion>[
  QuizQuestion(prompt: 'Symbol for sodium?', options: ['S', 'Na', 'So', 'N'], answer: 1, explanation: 'From the Latin natrium.'),
  QuizQuestion(prompt: '7 × 8?', options: ['54', '56', '58', '64'], answer: 1),
  QuizQuestion(prompt: 'Capital of Nigeria?', options: ['Lagos', 'Abuja', 'Kano', 'Uyo'], answer: 1),
];

void main() {
  test('score counts right answers and leaves skipped ones wrong', () {
    final QuizResult result = markQuiz(_quiz, <int?>[1, 0, null]);
    expect(result.correct, 1);
    expect(result.total, 3);
    expect(result.percent, 33);
    expect(result.review[1].chosen, 0);
    expect(result.review[2].chosen, isNull);
  });

  test('a grade band a Nigerian student recognises', () {
    expect(waecGrade(75), 'A1');
    expect(waecGrade(70), 'B2');
    expect(waecGrade(50), 'C6');
    expect(waecGrade(45), 'D7');
    expect(waecGrade(39), 'F9');
  });

  test('a question must have 2 to 6 options and one right answer', () {
    expect(questionProblem(const QuizQuestion(prompt: 'Q', options: ['A'], answer: 0)), isNotNull);
    expect(questionProblem(const QuizQuestion(prompt: 'Q', options: ['A', 'B'], answer: 2)), isNotNull);
    expect(questionProblem(const QuizQuestion(prompt: '', options: ['A', 'B'], answer: 0)), isNotNull);
    expect(questionProblem(const QuizQuestion(prompt: 'Q', options: ['A', 'B'], answer: 1)), isNull);
  });

  test('a quiz is stored as text and read back the same', () {
    expect(decodeQuiz(encodeQuiz(_quiz)).first.explanation, 'From the Latin natrium.');
    expect(decodeQuiz(encodeQuiz(_quiz)).length, 3);
    expect(decodeQuiz('not json'), isEmpty);
  });
}

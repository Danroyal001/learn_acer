import 'package:flutter/material.dart';

import '../../components/quiz_runner.dart';
import '../../components/ui.dart';
import '../../dartvel_client/dartvel_client.dart';

/// Taking a class quiz. The questions arrive without their answers, and the
/// server marks the attempt, so the answers are never in the page beforehand.
@DVPage(
  title: 'Quiz – Learn Acer',
  description: 'A class quiz on Learn Acer, marked at once with a WAEC grade and the right answers.',
)
Widget _quizPage(BuildContext context) => QuizScreen(id: context.dvParams['id'] ?? '');

class QuizScreen extends StatefulWidget {
  const QuizScreen({required this.id});

  final String id;

  @override
  State<QuizScreen> createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen> {
  Map<String, Object?>? _quiz;
  String? _problem;

  @override
  void initState() {
    super.initState();
    quizForTaking(quizId: widget.id).then((Map<String, Object?> found) {
      if (mounted) setState(() => _quiz = found);
    }, onError: (Object error) {
      if (mounted) setState(() => _problem = problemText(error));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_problem != null) {
      return PageColumn(children: <Widget>[
        const PageTitle('This quiz could not be opened'),
        Notice(_problem!),
        RouteLink('Back to your classes', to: DVRoutes.classes, tooltip: 'All the classes you are in'),
      ]);
    }
    if (_quiz == null) return const PageColumn(children: <Widget>[LinearProgressIndicator()]);
    final List<Map<String, Object?>> questions = <Map<String, Object?>>[
      for (final Object? item in (_quiz!['questions'] as List? ?? const <Object?>[])) if (item is Map) item.cast<String, Object?>(),
    ];
    return PageColumn(
      maxWidth: 760,
      children: <Widget>[
        RouteLink('← ${_quiz!['className']}', to: DVRoutes.classesId(id: '${_quiz!['classId']}'), tooltip: 'Back to the class', size: 15),
        const SizedBox(height: Space.md),
        PageTitle('${_quiz!['title']}'),
        QuizRunner(
          prompts: <String>[for (final Map<String, Object?> question in questions) '${question['prompt']}'],
          options: <List<String>>[
            for (final Map<String, Object?> question in questions) <String>[for (final Object? option in (question['options'] as List? ?? const <Object?>[])) '$option'],
          ],
          mark: (List<int?> chosen) async {
            final Map<String, Object?> result = await submitAttempt(quizId: widget.id, answers: <String>[for (final int? pick in chosen) pick?.toString() ?? '-'].join(','));
            final List<Map<String, Object?>> review = <Map<String, Object?>>[
              for (final Object? item in (result['review'] as List? ?? const <Object?>[])) if (item is Map) item.cast<String, Object?>(),
            ];
            return QuizMark(
              correct: result['correct'] as int? ?? 0,
              total: result['total'] as int? ?? questions.length,
              grade: '${result['grade']}',
              answers: <int>[for (final Map<String, Object?> row in review) row['answer'] as int? ?? -1],
              explanations: <String>[for (final Map<String, Object?> row in review) '${row['explanation'] ?? ''}'],
              note: result['recorded'] == true ? 'Your score is saved; your teacher can see it.' : 'Only students’ scores are saved.',
            );
          },
        ),
      ],
    );
  }
}

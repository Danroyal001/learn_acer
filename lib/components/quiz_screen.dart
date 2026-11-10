import 'package:flutter/widgets.dart';

import 'quiz_runner.dart';
import 'ui.dart';
import '../dartvel_client/dartvel_client.dart';

/// Taking a class quiz. The questions arrive without their answers, and the
/// server marks the attempt, so the answers are never in the page beforehand.

List<Map<String, Object?>> mapsIn(Object? value) => <Map<String, Object?>>[
      for (final Object? item in (value as List? ?? const <Object?>[])) if (item is Map) item.cast<String, Object?>(),
    ];

@DVFunctionalWidget()
Widget _quizScreen(BuildContext context, {required String id}) {
  final DVSignal<bool> started = context.signal(false);
  final DVSignal<Map<String, Object?>?> quiz = context.signal<Map<String, Object?>?>(null);
  final DVSignal<String> problem = context.signal('');
  onFirstFrame(context, started, () async {
    try {
      quiz.value = await quizForTaking(quizId: id);
    } on Object catch (error) {
      problem.value = problemText(error);
    }
  });
  if (problem.value.isNotEmpty) {
    return PageColumn(children: <Widget>[
      const PageTitle(title: 'This quiz could not be opened'),
      Notice(text: problem.value),
      RouteLink(label: 'Back to your classes', to: DVRoutes.classes, tooltip: 'All the classes you are in'),
    ]);
  }
  final Map<String, Object?>? loaded = quiz.value;
  if (loaded == null) return const PageColumn(children: <Widget>[LoadingLine()]);
  final List<Map<String, Object?>> questions = mapsIn(loaded['questions']);
  return PageColumn(
    maxWidth: 760,
    children: <Widget>[
      RouteLink(label: '← ${loaded['className']}', to: DVRoutes.classesId(id: '${loaded['classId']}'), tooltip: 'Back to the class', size: 15),
      PageTitle(title: '${loaded['title']}'),
      QuizRunner(
        prompts: <String>[for (final Map<String, Object?> question in questions) '${question['prompt']}'],
        options: <List<String>>[
          for (final Map<String, Object?> question in questions) <String>[for (final Object? option in (question['options'] as List? ?? const <Object?>[])) '$option'],
        ],
        mark: (List<int?> chosen) async {
          final Map<String, Object?> result = await submitAttempt(quizId: id, answers: <String>[for (final int? pick in chosen) pick?.toString() ?? '-'].join(','));
          final List<Map<String, Object?>> review = mapsIn(result['review']);
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

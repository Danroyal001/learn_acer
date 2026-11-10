import 'package:flutter/widgets.dart';

import 'quiz_runner.dart';
import 'ui.dart';
import '../dartvel_client/dartvel_client.dart';
import '../services/practice.dart';
import '../services/quiz_rules.dart';

/// Exam practice: quick sets marked at once with a WAEC grade, open to
/// everyone; class quizzes are on each class's page.

@DVFunctionalWidget()
Widget _examPrepScreen(BuildContext context) {
  final DVSignal<PracticeTopic?> topic = context.signal<PracticeTopic?>(null);
  final DVSignal<List<QuizQuestion>> questions = context.signal(const <QuizQuestion>[]);
  final DVSignal<int> round = context.signal(0);

  void start(PracticeTopic chosen) {
    topic.value = chosen;
    questions.value = practiceSet(chosen);
    round.value = round.read() + 1;
  }

  final PracticeTopic? current = topic.value;
  if (current != null) {
    final List<QuizQuestion> set = questions.value;
    return PageColumn(
      maxWidth: 760,
      children: <Widget>[
        QuietButton(label: '← All practice sets', tooltip: 'Choose another topic', onTap: () => topic.value = null),
        PageTitle(title: practiceTitle(current)),
        KeyedSubtree(
          key: ValueKey<int>(round.value),
          child: QuizRunner(
            prompts: <String>[for (final QuizQuestion question in set) question.prompt],
            options: <List<String>>[for (final QuizQuestion question in set) question.options],
            mark: (List<int?> chosen) async {
              final QuizResult result = markQuiz(set, chosen);
              return QuizMark(
                correct: result.correct,
                total: result.total,
                grade: waecGrade(result.percent),
                answers: <int>[for (final QuizQuestion question in set) question.answer],
                explanations: <String>[for (final QuizQuestion question in set) question.explanation],
                note: 'Practice scores are not saved.',
              );
            },
            onAgain: () => start(current),
          ),
        ),
      ],
    );
  }
  return PageColumn(
    children: <Widget>[
      const PageTitle(title: 'Exam practice', lead: 'Ten questions at a time, marked at once, with a WAEC grade and the right answers. Your teacher’s quizzes are on your class page.'),
      DVBox.list(<Widget>[
        for (final PracticeTopic each in PracticeTopic.values)
          Panel(
            spacing: Space.sm,
            children: <Widget>[
              SectionTitle(title: practiceTitle(each), level: 2, size: 21),
              BodyText(text: practiceBlurb(each), size: 15, muted: true),
              DVBox.row(<Widget>[PrimaryButton(label: 'Start ${practiceTitle(each).toLowerCase()}', tooltip: 'Ten questions', onTap: () => start(each))], spacing: 0),
            ],
          ),
      ], spacing: Space.md),
      DVBox(RouteLink(label: 'Your class quizzes', to: DVRoutes.classes, tooltip: 'Quizzes your teacher set are on each class page'), const DVModifier().paddingOnly(top: Space.lg)),
    ],
  );
}

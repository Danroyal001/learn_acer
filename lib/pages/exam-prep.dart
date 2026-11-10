import 'package:flutter/material.dart';

import '../components/quiz_runner.dart';
import '../components/ui.dart';
import '../dartvel_client/dartvel_client.dart';
import '../services/practice.dart';
import '../services/quiz_rules.dart';

/// Exam practice: quick sets marked at once with a WAEC grade, open to
/// everyone; class quizzes are on each class's page.
@DVPage(
  title: 'Exam practice – Learn Acer',
  description: 'Free exam practice for students: element symbols, times tables and mental maths, ten questions at a time, marked at once with a WAEC grade and the right answers.',
)
Widget _examPrepPage(BuildContext context) => const ExamPrepScreen();

class ExamPrepScreen extends StatefulWidget {
  const ExamPrepScreen();

  @override
  State<ExamPrepScreen> createState() => ExamPrepScreenState();
}

class ExamPrepScreenState extends State<ExamPrepScreen> {
  PracticeTopic? _topic;
  List<QuizQuestion> _set = const <QuizQuestion>[];
  int _round = 0;

  void _start(PracticeTopic topic) => setState(() {
        _topic = topic;
        _set = practiceSet(topic);
        _round++;
      });

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette.of(context);
    if (_topic != null) {
      return PageColumn(
        maxWidth: 760,
        children: <Widget>[
          QuietButton('← All practice sets', tooltip: 'Choose another topic', onPressed: () => setState(() => _topic = null)),
          PageTitle(practiceTitle(_topic!)),
          QuizRunner(
            key: ValueKey<int>(_round),
            prompts: <String>[for (final QuizQuestion question in _set) question.prompt],
            options: <List<String>>[for (final QuizQuestion question in _set) question.options],
            mark: (List<int?> chosen) async {
              final QuizResult result = markQuiz(_set, chosen);
              return QuizMark(
                correct: result.correct,
                total: result.total,
                grade: waecGrade(result.percent),
                answers: <int>[for (final QuizQuestion question in _set) question.answer],
                explanations: <String>[for (final QuizQuestion question in _set) question.explanation],
                note: 'Practice scores are not saved.',
              );
            },
            onAgain: () => _start(_topic!),
          ),
        ],
      );
    }
    return PageColumn(
      children: <Widget>[
        const PageTitle('Exam practice', lead: 'Ten questions at a time, marked at once, with a WAEC grade and the right answers. Your teacher’s quizzes are on your class page.'),
        for (final PracticeTopic topic in PracticeTopic.values)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.md),
            child: Panel(
              child: Wrap(
                spacing: Space.xl,
                runSpacing: Space.md,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                children: <Widget>[
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Semantics(headingLevel: 2, child: Text(practiceTitle(topic), style: displayStyle(context, size: 21))),
                        const SizedBox(height: Space.xs),
                        Text(practiceBlurb(topic), style: textStyle(context, size: 15, color: palette.muted)),
                      ],
                    ),
                  ),
                  PrimaryButton('Start', tooltip: 'Ten ${practiceTitle(topic).toLowerCase()} questions', onPressed: () => _start(topic)),
                ],
              ),
            ),
          ),
        const SizedBox(height: Space.lg),
        RouteLink('Your class quizzes', to: DVRoutes.classes, tooltip: 'Quizzes your teacher set are on each class page'),
      ],
    );
  }
}

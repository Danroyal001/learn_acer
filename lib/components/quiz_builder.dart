// The teacher's quiz form: a title and any number of multiple-choice
// questions, each checked by quiz_rules.dart before the server sees it.
import 'package:flutter/widgets.dart';

import '../dartvel_client/dartvel_client.dart';
import '../services/quiz_rules.dart';
import 'quiz_runner.dart' show optionLetter;
import 'ui.dart';

/// One question as the teacher is writing it: four option boxes, the marked one.
class const QuestionDraft({
  final String prompt = '',
  final List<String> options = const <String>['', '', '', ''],
  final int answer = 0,
  final String explanation = '',
}) {
  QuestionDraft copy({String? prompt, List<String>? options, int? answer, String? explanation}) =>
      QuestionDraft(prompt: prompt ?? this.prompt, options: options ?? this.options, answer: answer ?? this.answer, explanation: explanation ?? this.explanation);

  /// As a quiz question: blank options dropped, the answer counted among the rest.
  QuizQuestion toQuestion() {
    final List<String> filled = <String>[];
    int place = -1;
    for (int index = 0; index < options.length; index++) {
      if (options[index].trim().isEmpty) continue;
      if (index == answer) place = filled.length;
      filled.add(options[index].trim());
    }
    return QuizQuestion(prompt: prompt.trim(), options: filled, answer: place, explanation: explanation.trim());
  }
}

@DVFunctionalWidget()
Widget _quizBuilder(BuildContext context, {required String classId, required VoidCallback onCreated}) {
  final Palette palette = Palette.of(context);
  final DVSignal<bool> open = context.signal(false);
  final DVSignal<String> title = context.signal('');
  final DVSignal<List<QuestionDraft>> drafts = context.signal(const <QuestionDraft>[QuestionDraft()]);
  final DVSignal<bool> busy = context.signal(false);
  final DVSignal<String> problem = context.signal('');

  void change(int index, QuestionDraft draft) {
    final List<QuestionDraft> next = List<QuestionDraft>.of(drafts.read());
    next[index] = draft;
    drafts.value = next;
  }

  Future<void> save() async {
    if (title.read().trim().isEmpty) {
      problem.value = 'Give the quiz a title.';
      return;
    }
    final List<QuizQuestion> questions = <QuizQuestion>[for (final QuestionDraft draft in drafts.read()) draft.toQuestion()];
    for (int index = 0; index < questions.length; index++) {
      final String? wrong = questionProblem(questions[index]);
      if (wrong != null) {
        problem.value = 'Question ${index + 1}: $wrong';
        return;
      }
    }
    busy.value = true;
    problem.value = '';
    try {
      await createQuiz(classId: classId, title: title.read().trim(), questions: encodeQuiz(questions));
      title.value = '';
      drafts.value = const <QuestionDraft>[QuestionDraft()];
      open.value = false;
      onCreated();
    } on Object catch (error) {
      problem.value = problemText(error);
    } finally {
      busy.value = false;
    }
  }

  if (!open.value) {
    return DVBox.row(<Widget>[QuietButton(label: '+ Set a quiz', tooltip: 'Write multiple-choice questions for the class', onTap: () => open.value = true)], spacing: 0);
  }
  final List<QuestionDraft> current = drafts.value;
  return Panel(
    children: <Widget>[
      Field(label: 'Quiz title', value: title.value, hint: 'Week 3 check', onChanged: (String typed) => title.value = typed),
      for (int index = 0; index < current.length; index++) ...<Widget>[
        DVBox.row(<Widget>[
          BodyText(text: 'Question ${index + 1}', bold: true),
          if (current.length > 1)
            QuietButton(label: 'Remove', tooltip: 'Remove question ${index + 1}', color: palette.danger, onTap: () => drafts.value = List<QuestionDraft>.of(drafts.read())..removeAt(index)),
        ], align: DVAlign.spaceBetween),
        Field(label: 'Question', value: current[index].prompt, onChanged: (String typed) => change(index, drafts.read()[index].copy(prompt: typed))),
        for (int option = 0; option < 4; option++)
          Field(
            label: 'Option ${optionLetter(option)}${option >= 2 ? ' (optional)' : ''}',
            value: current[index].options[option],
            onChanged: (String typed) {
              final List<String> options = List<String>.of(drafts.read()[index].options);
              options[option] = typed;
              change(index, drafts.read()[index].copy(options: options));
            },
          ),
        const BodyText(text: 'Which option is right?', size: 15, bold: true),
        ChoiceRow(
          options: <(String, String, String)>[for (int option = 0; option < 4; option++) ('$option', optionLetter(option), 'Mark option ${optionLetter(option)} as the right answer')],
          selected: '${current[index].answer}',
          onChanged: (String chosen) => change(index, drafts.read()[index].copy(answer: int.parse(chosen))),
        ),
        Field(label: 'Why it is right (optional)', value: current[index].explanation, hint: 'Shown after the quiz is marked', onChanged: (String typed) => change(index, drafts.read()[index].copy(explanation: typed))),
      ],
      DVBox.wrapLine(<Widget>[
        QuietButton(label: '+ Another question', tooltip: 'Add a question', onTap: () => drafts.value = <QuestionDraft>[...drafts.read(), const QuestionDraft()]),
        PrimaryButton(label: 'Save quiz', tooltip: 'The class can take it straight away', busy: busy.value, onTap: save),
        QuietButton(label: 'Cancel', tooltip: 'Close without saving', onTap: () => open.value = false),
      ], spacing: Space.md, crossAlign: DVCrossAlign.center),
      if (problem.value.isNotEmpty) Notice(text: problem.value),
    ],
  );
}

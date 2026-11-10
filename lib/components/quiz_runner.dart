// Taking a quiz: one question at a time, then the mark, the grade and a
// review that shows the right answer and why. Used by class quizzes (marked on
// the server) and exam practice (marked here).
import 'package:flutter/widgets.dart';

import '../dartvel_client/dartvel_client.dart';
import 'ui.dart';

/// What marking answered: the score and, per question, the right option.
class const QuizMark({
  required final int correct,
  required final int total,
  required final String grade,
  required final List<int> answers,
  required final List<String> explanations,
  final String note = '',
});

String optionLetter(int index) => String.fromCharCode(65 + index);

@DVFunctionalWidget()
Widget _quizRunner(
  BuildContext context, {
  required List<String> prompts,
  required List<List<String>> options,
  required Future<QuizMark> Function(List<int?> chosen) mark,
  VoidCallback? onAgain,
}) {
  final Palette palette = Palette.of(context);
  final DVSignal<List<int?>> chosen = context.signal(List<int?>.filled(prompts.length, null));
  final DVSignal<int> at = context.signal(0);
  final DVSignal<bool> busy = context.signal(false);
  final DVSignal<String> problem = context.signal('');
  final DVSignal<QuizMark?> result = context.signal<QuizMark?>(null);

  Future<void> finish() async {
    busy.value = true;
    problem.value = '';
    try {
      result.value = await mark(chosen.read());
    } on Object catch (error) {
      problem.value = problemText(error);
    } finally {
      busy.value = false;
    }
  }

  void choose(int option) {
    final List<int?> next = List<int?>.of(chosen.read());
    next[at.read()] = option;
    chosen.value = next;
  }

  final QuizMark? marked = result.value;
  if (marked != null) {
    final int percent = marked.total == 0 ? 0 : (marked.correct * 100 / marked.total).round();
    return DVBox.list(<Widget>[
      Panel(
        spacing: Space.xs,
        children: <Widget>[
          DVText(marked.grade).modifier(DVModifier().fontFamily(displayFont).fontSize(56).color(percent >= 50 ? palette.success : palette.danger).semanticLabel('Grade ${marked.grade}')),
          DVText('${marked.correct} out of ${marked.total} ($percent%)').modifier(DVModifier().fontFamily(displayFont).fontSize(24).color(palette.ink).semanticRole('status')),
          BodyText(text: percent >= 75 ? 'Excellent.' : percent >= 50 ? 'A pass. Look at the ones you missed.' : 'Not yet. Read the answers below and try again.', muted: true),
          if (marked.note.isNotEmpty) BodyText(text: marked.note, size: 14, muted: true),
        ],
      ),
      const SectionTitle(title: 'Your answers'),
      for (int index = 0; index < prompts.length; index++)
        ReviewRow(
          prompt: '${index + 1}. ${prompts[index]}',
          options: options[index],
          chosen: chosen.value[index] ?? -1,
          answer: marked.answers[index],
          explanation: marked.explanations[index],
        ),
      if (onAgain != null) DVBox(PrimaryButton(label: 'Try another set', tooltip: 'New questions', onTap: onAgain), const DVModifier().paddingOnly(top: Space.lg)),
    ], spacing: Space.md);
  }

  final int count = prompts.length;
  final int index = at.value;
  final bool lastOne = index == count - 1;
  return DVBox.list(<Widget>[
    DVText('Question ${index + 1} of $count').modifier(DVModifier().fontFamily(textFont).fontSize(15).fontWeight(FontWeight.w600).color(palette.muted)),
    Panel(
      children: <Widget>[
        SectionTitle(title: prompts[index], level: 2, size: 22),
        for (int option = 0; option < options[index].length; option++)
          DVText('${optionLetter(option)}.  ${options[index][option]}').modifier(
            DVModifier()
                .fontFamily(textFont)
                .fontSize(16)
                .color(palette.ink)
                .backgroundColor(chosen.value[index] == option ? palette.accentSoft : palette.surface)
                .border(Border.all(color: chosen.value[index] == option ? palette.accent : palette.rule, width: chosen.value[index] == option ? 2 : 1))
                .rounded(8)
                .paddingSymmetric(horizontal: Space.lg, vertical: Space.md)
                .minimumTapTarget()
                .semanticLabel('Option ${optionLetter(option)}: ${options[index][option]}${chosen.value[index] == option ? ', chosen' : ''}')
                .tooltip('Choose ${optionLetter(option)}')
                .onTap(() => choose(option)),
          ),
      ],
    ),
    DVBox.wrapLine(<Widget>[
      if (index > 0) QuietButton(label: 'Back', tooltip: 'The previous question', onTap: () => at.value = at.read() - 1),
      if (!lastOne) PrimaryButton(label: chosen.value[index] == null ? 'Skip' : 'Next', tooltip: 'The next question', onTap: () => at.value = at.read() + 1),
      if (lastOne) PrimaryButton(label: 'Mark my answers', tooltip: 'See your score and the right answers', busy: busy.value, onTap: finish),
    ], spacing: Space.md, crossAlign: DVCrossAlign.center),
    if (problem.value.isNotEmpty) Notice(text: problem.value),
  ], spacing: Space.md);
}

@DVFunctionalWidget()
Widget _reviewRow(BuildContext context, {required String prompt, required List<String> options, required int chosen, required int answer, required String explanation}) {
  final Palette palette = Palette.of(context);
  final bool right = chosen == answer;
  String option(int at) => at < 0 || at >= options.length ? 'nothing' : '${optionLetter(at)}. ${options[at]}';
  return DVBox.list(<Widget>[
    BodyText(text: prompt, bold: true),
    BodyText(text: right ? 'Right: ${option(answer)}' : 'You chose ${option(chosen)}. The answer is ${option(answer)}.', size: 15, color: right ? palette.success : palette.danger),
    if (explanation.isNotEmpty) BodyText(text: explanation, size: 15, muted: true),
  ], spacing: Space.xs, modifier: DVModifier().backgroundColor(palette.surface).rounded(10).padding(Space.lg).border(Border(left: BorderSide(color: right ? palette.success : palette.danger, width: 4))));
}

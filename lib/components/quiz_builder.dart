// The teacher's quiz form: a title and any number of multiple-choice
// questions, each checked by quiz_rules.dart before the server sees it.
import 'package:flutter/material.dart';

import '../dartvel_client/dartvel_client.dart';
import '../services/quiz_rules.dart';
import 'ui.dart';

class QuizBuilder extends StatefulWidget {
  const QuizBuilder({super.key, required this.classId, required this.onCreated});

  final String classId;
  final VoidCallback onCreated;

  @override
  State<QuizBuilder> createState() => _QuizBuilderState();
}

class _Draft {
  final TextEditingController prompt = TextEditingController();
  final List<TextEditingController> options = List<TextEditingController>.generate(4, (_) => TextEditingController());
  final TextEditingController explanation = TextEditingController();
  int answer = 0;

  QuizQuestion toQuestion() => QuizQuestion(
        prompt: prompt.text.trim(),
        options: <String>[for (final TextEditingController option in options) option.text.trim()].where((String text) => text.isNotEmpty).toList(),
        answer: () {
          // The marked option's place among the options that are filled in.
          int place = 0;
          for (int index = 0; index < options.length; index++) {
            if (options[index].text.trim().isEmpty) continue;
            if (index == answer) return place;
            place++;
          }
          return -1;
        }(),
        explanation: explanation.text.trim(),
      );

  void dispose() {
    prompt.dispose();
    explanation.dispose();
    for (final TextEditingController option in options) {
      option.dispose();
    }
  }
}

class _QuizBuilderState extends State<QuizBuilder> {
  final TextEditingController _title = TextEditingController();
  final List<_Draft> _drafts = <_Draft>[_Draft()];
  bool _open = false;
  bool _busy = false;
  String? _problem;

  @override
  void dispose() {
    _title.dispose();
    for (final _Draft draft in _drafts) {
      draft.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty) {
      setState(() => _problem = 'Give the quiz a title.');
      return;
    }
    final List<QuizQuestion> questions = <QuizQuestion>[for (final _Draft draft in _drafts) draft.toQuestion()];
    for (int index = 0; index < questions.length; index++) {
      final String? problem = questionProblem(questions[index]);
      if (problem != null) {
        setState(() => _problem = 'Question ${index + 1}: $problem');
        return;
      }
    }
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      await createQuiz(classId: widget.classId, title: _title.text.trim(), questions: encodeQuiz(questions));
      _title.clear();
      for (final _Draft draft in _drafts) {
        draft.dispose();
      }
      setState(() {
        _drafts
          ..clear()
          ..add(_Draft());
        _open = false;
      });
      widget.onCreated();
    } on Object catch (error) {
      if (mounted) setState(() => _problem = problemText(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette.of(context);
    if (!_open) {
      return Padding(
        padding: const EdgeInsets.only(bottom: Space.md),
        child: QuietButton('+ Set a quiz', tooltip: 'Write multiple-choice questions for the class', onPressed: () => setState(() => _open = true)),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.lg),
      child: Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LabelledField(label: 'Quiz title', controller: _title, hint: 'Week 3 check', textCapitalization: TextCapitalization.sentences),
            for (int index = 0; index < _drafts.length; index++) ...<Widget>[
              Padding(
                padding: const EdgeInsets.only(top: Space.md, bottom: Space.sm),
                child: Row(
                  children: <Widget>[
                    Expanded(child: Text('Question ${index + 1}', style: textStyle(context, weight: FontWeight.w700))),
                    if (_drafts.length > 1)
                      QuietButton('Remove', tooltip: 'Remove question ${index + 1}', color: palette.danger, onPressed: () => setState(() => _drafts.removeAt(index).dispose())),
                  ],
                ),
              ),
              LabelledField(label: 'Question', controller: _drafts[index].prompt, textCapitalization: TextCapitalization.sentences),
              RadioGroup<int>(
                groupValue: _drafts[index].answer,
                onChanged: (int? chosen) => setState(() => _drafts[index].answer = chosen ?? 0),
                child: Column(
                  children: <Widget>[
                    for (int option = 0; option < 4; option++)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: Space.sm),
                            child: Tooltip(message: 'Mark option ${String.fromCharCode(65 + option)} as the right answer', child: Radio<int>(value: option)),
                          ),
                          Expanded(child: LabelledField(label: 'Option ${String.fromCharCode(65 + option)}${option >= 2 ? ' (optional)' : ''}', controller: _drafts[index].options[option])),
                        ],
                      ),
                  ],
                ),
              ),
              LabelledField(label: 'Why it is right (optional)', controller: _drafts[index].explanation, hint: 'Shown after the quiz is marked'),
            ],
            Wrap(
              spacing: Space.md,
              runSpacing: Space.sm,
              children: <Widget>[
                QuietButton('+ Another question', tooltip: 'Add a question', onPressed: () => setState(() => _drafts.add(_Draft()))),
                PrimaryButton('Save quiz', tooltip: 'The class can take it straight away', busy: _busy, onPressed: _save),
                QuietButton('Cancel', tooltip: 'Close without saving', onPressed: () => setState(() => _open = false)),
              ],
            ),
            Text('The circle next to an option marks the right answer.', style: textStyle(context, size: 14, color: palette.muted)),
            if (_problem != null) Notice(_problem!),
          ],
        ),
      ),
    );
  }
}

// Taking a quiz: one question at a time, then the mark, the grade and a
// review that shows the right answer and why. Used by class quizzes (marked on
// the server) and exam practice (marked here).
import 'package:flutter/material.dart';

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

class QuizRunner extends StatefulWidget {
  const QuizRunner({super.key, required this.prompts, required this.options, required this.mark, this.onAgain});

  final List<String> prompts;
  final List<List<String>> options;

  /// Marks the chosen options (null when skipped).
  final Future<QuizMark> Function(List<int?> chosen) mark;
  final VoidCallback? onAgain;

  @override
  State<QuizRunner> createState() => _QuizRunnerState();
}

class _QuizRunnerState extends State<QuizRunner> {
  late List<int?> _chosen = List<int?>.filled(widget.prompts.length, null);
  int _at = 0;
  bool _busy = false;
  String? _problem;
  QuizMark? _mark;

  Future<void> _finish() async {
    setState(() {
      _busy = true;
      _problem = null;
    });
    try {
      final QuizMark mark = await widget.mark(_chosen);
      if (mounted) setState(() => _mark = mark);
    } on Object catch (error) {
      if (mounted) setState(() => _problem = problemText(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => _mark == null ? _question(context) : _review(context, _mark!);

  Widget _question(BuildContext context) {
    final Palette palette = Palette.of(context);
    final int count = widget.prompts.length;
    final bool last = _at == count - 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Semantics(
          label: 'Question ${_at + 1} of $count',
          child: ExcludeSemantics(
            child: Row(
              children: <Widget>[
                Text('Question ${_at + 1} of $count', style: textStyle(context, size: 15, weight: FontWeight.w600, color: palette.muted)),
                const SizedBox(width: Space.md),
                Expanded(child: LinearProgressIndicator(value: (_at + 1) / count, color: palette.accent, backgroundColor: palette.rule)),
              ],
            ),
          ),
        ),
        const SizedBox(height: Space.lg),
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Semantics(headingLevel: 2, child: Text(widget.prompts[_at], style: displayStyle(context, size: 22))),
              const SizedBox(height: Space.lg),
              RadioGroup<int>(
                groupValue: _chosen[_at],
                onChanged: (int? chosen) => setState(() => _chosen[_at] = chosen),
                child: Column(
                  children: <Widget>[
                    for (int option = 0; option < widget.options[_at].length; option++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: Space.sm),
                        child: Material(
                          color: _chosen[_at] == option ? palette.accentSoft : Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: _chosen[_at] == option ? palette.accent : palette.rule)),
                          child: RadioListTile<int>(
                            value: option,
                            title: Text('${String.fromCharCode(65 + option)}.  ${widget.options[_at][option]}', style: textStyle(context)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Space.lg),
        Wrap(
          spacing: Space.md,
          runSpacing: Space.sm,
          children: <Widget>[
            if (_at > 0) QuietButton('Back', tooltip: 'The previous question', onPressed: () => setState(() => _at--)),
            if (!last) PrimaryButton(_chosen[_at] == null ? 'Skip' : 'Next', tooltip: 'The next question', onPressed: () => setState(() => _at++)),
            if (last) PrimaryButton('Mark my answers', tooltip: 'See your score and the right answers', busy: _busy, onPressed: _finish),
          ],
        ),
        if (_problem != null) Notice(_problem!),
      ],
    );
  }

  Widget _review(BuildContext context, QuizMark mark) {
    final Palette palette = Palette.of(context);
    final int percent = mark.total == 0 ? 0 : (mark.correct * 100 / mark.total).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Semantics(
          liveRegion: true,
          child: Panel(
            child: Wrap(
              spacing: Space.x2,
              runSpacing: Space.md,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text(mark.grade, style: displayStyle(context, size: 56, color: percent >= 50 ? palette.success : palette.danger)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${mark.correct} out of ${mark.total} ($percent%)', style: displayStyle(context, size: 24)),
                    Text(percent >= 75 ? 'Excellent.' : percent >= 50 ? 'A pass. Look at the ones you missed.' : 'Not yet. Read the answers below and try again.', style: textStyle(context, color: palette.muted)),
                    if (mark.note.isNotEmpty) Text(mark.note, style: textStyle(context, size: 14, color: palette.muted)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SectionTitle('Your answers'),
        for (int index = 0; index < widget.prompts.length; index++) _ReviewRow(index: index, prompt: widget.prompts[index], options: widget.options[index], chosen: _chosen[index], answer: mark.answers[index], explanation: mark.explanations[index]),
        if (widget.onAgain != null) ...<Widget>[
          const SizedBox(height: Space.lg),
          PrimaryButton('Try another set', tooltip: 'New questions', onPressed: widget.onAgain),
        ],
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.index, required this.prompt, required this.options, required this.chosen, required this.answer, required this.explanation});

  final int index;
  final String prompt;
  final List<String> options;
  final int? chosen;
  final int answer;
  final String explanation;

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette.of(context);
    final bool right = chosen == answer;
    String option(int? at) => at == null || at < 0 || at >= options.length ? 'nothing' : '${String.fromCharCode(65 + at)}. ${options[at]}';
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Space.lg),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border(left: BorderSide(color: right ? palette.success : palette.danger, width: 4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${index + 1}. $prompt', style: textStyle(context, weight: FontWeight.w600)),
            const SizedBox(height: Space.xs),
            Text(right ? 'Right: ${option(answer)}' : 'You chose ${option(chosen)}. The answer is ${option(answer)}.', style: textStyle(context, size: 15, color: right ? palette.success : palette.danger)),
            if (explanation.isNotEmpty) Padding(padding: const EdgeInsets.only(top: Space.xs), child: Text(explanation, style: textStyle(context, size: 15, color: palette.muted))),
          ],
        ),
      ),
    );
  }
}

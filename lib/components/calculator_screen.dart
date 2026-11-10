import 'package:flutter/widgets.dart';

import 'ui.dart';
import '../dartvel_client/dartvel_client.dart';
import '../services/calculator.dart';

/// A scientific calculator: type or tap, Enter for the answer.

/// The keypad, row by row: what the key shows and what it does. An empty
/// label is a gap.
const List<List<(String, String)>> calculatorKeys = <List<(String, String)>>[
  <(String, String)>[('sin', 'sin('), ('cos', 'cos('), ('tan', 'tan('), ('√', '√('), ('xʸ', '^')],
  <(String, String)>[('log', 'log('), ('ln', 'ln('), ('π', 'π'), ('e', 'e'), ('n!', '!')],
  <(String, String)>[('(', '('), (')', ')'), ('%', '%'), ('C', 'clear'), ('⌫', 'back')],
  <(String, String)>[('7', '7'), ('8', '8'), ('9', '9'), ('÷', '÷'), ('Ans', 'ans')],
  <(String, String)>[('4', '4'), ('5', '5'), ('6', '6'), ('×', '×'), ('', '')],
  <(String, String)>[('1', '1'), ('2', '2'), ('3', '3'), ('−', '-'), ('', '')],
  <(String, String)>[('0', '0'), ('.', '.'), ('=', 'equals'), ('+', '+'), ('', '')],
];

/// What a screen reader and the tooltip call each symbol key.
const Map<String, String> calculatorKeyNames = <String, String>{
  '√': 'square root',
  'xʸ': 'power',
  'π': 'pi',
  'n!': 'factorial',
  'C': 'clear',
  '⌫': 'delete the last character',
  '÷': 'divide',
  '×': 'times',
  '−': 'minus',
  '+': 'plus',
  '=': 'equals',
  'Ans': 'the last answer',
  '%': 'percent',
};

@DVFunctionalWidget()
Widget _calculatorScreen(BuildContext context) {
  final Palette palette = Palette.of(context);
  final DVSignal<String> sum = context.signal('');
  final DVSignal<bool> degrees = context.signal(true);
  final DVSignal<String> answer = context.signal('');
  final DVSignal<String> problem = context.signal('');
  final DVSignal<double?> last = context.signal<double?>(null);
  final DVSignal<List<(String, String)>> history = context.signal(const <(String, String)>[]);

  void equals() {
    final String typed = sum.read().trim();
    if (typed.isEmpty) return;
    try {
      final double value = evaluate(typed, degrees: degrees.read());
      last.value = value;
      answer.value = formatAnswer(value);
      problem.value = '';
      history.value = <(String, String)>[(typed, formatAnswer(value)), ...history.read()].take(8).toList();
    } on CalculatorError catch (error) {
      answer.value = '';
      problem.value = error.message;
    }
  }

  void press(String key) {
    problem.value = '';
    switch (key) {
      case 'clear':
        sum.value = '';
        answer.value = '';
      case 'back':
        final String now = sum.read();
        if (now.isNotEmpty) sum.value = now.substring(0, now.length - 1);
      case 'equals':
        equals();
      case 'ans':
        final double? previous = last.read();
        if (previous != null) sum.value = sum.read() + formatAnswer(previous);
      default:
        sum.value = sum.read() + key;
    }
  }

  return PageColumn(
    maxWidth: 560,
    children: <Widget>[
      const PageTitle(title: 'Calculator', lead: 'Type a sum or tap the keys. Enter or = gives the answer.'),
      Panel(
        children: <Widget>[
          DVBox.row(<Widget>[
            const BodyText(text: 'Angles in', size: 15, muted: true),
            ChoiceRow(
              options: const <(String, String, String)>[('deg', 'Degrees', 'sin(30) = 0.5'), ('rad', 'Radians', 'sin(π÷6) = 0.5')],
              selected: degrees.value ? 'deg' : 'rad',
              onChanged: (String chosen) => degrees.value = chosen == 'deg',
            ),
          ], spacing: Space.sm),
          Field(label: 'Sum', value: sum.value, hint: '2 + 3 × 4', onChanged: (String typed) => sum.value = typed, onSubmitted: equals),
          DVText(answer.value.isEmpty ? ' ' : '= ${answer.value}').modifier(
            DVModifier().fontFamily(displayFont).fontSize(36).color(palette.ink).align(Alignment.centerRight).semanticLabel(answer.value.isEmpty ? 'No answer yet' : 'Answer ${answer.value}').semanticRole('status'),
          ),
          if (problem.value.isNotEmpty) Notice(text: problem.value),
          DVBox.list(<Widget>[
            for (final List<(String, String)> row in calculatorKeys)
              DVBox.grid(<Widget>[for (final (String label, String key) in row) label.isEmpty ? const DVBox() : CalculatorKey(label: label, primary: key == 'equals', onTap: () => press(key))], columns: 5, spacing: Space.sm, responsive: false),
          ], spacing: Space.sm),
        ],
      ),
      if (history.value.isNotEmpty) ...<Widget>[
        const SectionTitle(title: 'Earlier'),
        for (final (String typed, String result) in history.value) BodyText(text: '$typed = $result', muted: true),
      ],
    ],
  );
}

@DVFunctionalWidget()
Widget _calculatorKey(BuildContext context, {required String label, required VoidCallback onTap, bool primary = false}) {
  final Palette palette = Palette.of(context);
  final String name = calculatorKeyNames[label] ?? label;
  return DVBox(
    DVText(label).modifier(DVModifier().fontFamily(textFont).fontSize(18).fontWeight(FontWeight.w600).color(primary ? palette.onAccent : palette.ink)),
    DVModifier().backgroundColor(primary ? palette.accent : palette.accentSoft).rounded(10).height(52).centered().semanticLabel(name).tooltip(name).onTap(onTap),
  );
}

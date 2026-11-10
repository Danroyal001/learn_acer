import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/ui.dart';
import '../dartvel_client/dartvel_client.dart';
import '../services/calculator.dart';

/// A scientific calculator: type or tap, Enter for the answer.
@DVPage(
  title: 'Scientific calculator – Learn Acer',
  description: 'A free online scientific calculator for students: brackets, powers, roots, factorials, sin, cos, tan in degrees or radians, log and ln, with plain-English errors.',
)
Widget _calculatorPage(BuildContext context) => const CalculatorScreen();

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen();

  @override
  State<CalculatorScreen> createState() => CalculatorScreenState();
}

const List<List<(String, String)>> _keys = <List<(String, String)>>[
  <(String, String)>[('sin', 'sin('), ('cos', 'cos('), ('tan', 'tan('), ('√', '√('), ('xʸ', '^')],
  <(String, String)>[('log', 'log('), ('ln', 'ln('), ('π', 'π'), ('e', 'e'), ('n!', '!')],
  <(String, String)>[('(', '('), (')', ')'), ('%', '%'), ('C', 'clear'), ('⌫', 'back')],
  <(String, String)>[('7', '7'), ('8', '8'), ('9', '9'), ('÷', '÷'), ('Ans', 'ans')],
  <(String, String)>[('4', '4'), ('5', '5'), ('6', '6'), ('×', '×'), ('', '')],
  <(String, String)>[('1', '1'), ('2', '2'), ('3', '3'), ('−', '-'), ('', '')],
  <(String, String)>[('0', '0'), ('.', '.'), ('=', 'equals'), ('+', '+'), ('', '')],
];

const Map<String, String> _keyNames = <String, String>{
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

class CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _expression = TextEditingController();
  bool _degrees = true;
  String _answer = '';
  String _problem = '';
  double? _last;
  final List<(String, String)> _history = <(String, String)>[];

  @override
  void dispose() {
    _expression.dispose();
    super.dispose();
  }

  void _press(String key) {
    setState(() => _problem = '');
    switch (key) {
      case 'clear':
        _expression.clear();
        setState(() => _answer = '');
      case 'back':
        if (_expression.text.isNotEmpty) _expression.text = _expression.text.substring(0, _expression.text.length - 1);
      case 'equals':
        _equals();
      case 'ans':
        if (_last != null) _expression.text += formatAnswer(_last!);
      default:
        _expression.text += key;
    }
    _expression.selection = TextSelection.collapsed(offset: _expression.text.length);
  }

  void _equals() {
    final String sum = _expression.text.trim();
    if (sum.isEmpty) return;
    try {
      final double value = evaluate(sum, degrees: _degrees);
      setState(() {
        _last = value;
        _answer = formatAnswer(value);
        _history.insert(0, (sum, _answer));
        if (_history.length > 8) _history.removeLast();
      });
    } on CalculatorError catch (error) {
      setState(() {
        _answer = '';
        _problem = error.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette.of(context);
    return PageColumn(
      maxWidth: 560,
      children: <Widget>[
        const PageTitle('Calculator', lead: 'Type a sum or tap the keys. Enter or = gives the answer.'),
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('Angles in', style: textStyle(context, size: 15, color: palette.muted)),
                  const SizedBox(width: Space.sm),
                  SegmentedButton<bool>(
                    segments: const <ButtonSegment<bool>>[
                      ButtonSegment<bool>(value: true, label: Text('Degrees'), tooltip: 'sin(30) = 0.5'),
                      ButtonSegment<bool>(value: false, label: Text('Radians'), tooltip: 'sin(π÷6) = 0.5'),
                    ],
                    selected: <bool>{_degrees},
                    showSelectedIcon: false,
                    onSelectionChanged: (Set<bool> chosen) => setState(() => _degrees = chosen.first),
                  ),
                ],
              ),
              const SizedBox(height: Space.lg),
              CallbackShortcuts(
                bindings: <ShortcutActivator, VoidCallback>{const SingleActivator(LogicalKeyboardKey.enter): _equals},
                child: LabelledField(label: 'Sum', controller: _expression, hint: '2 + 3 × 4', onSubmitted: (_) => _equals()),
              ),
              Semantics(
                liveRegion: true,
                label: _answer.isEmpty ? null : 'Answer $_answer',
                child: ExcludeSemantics(
                  child: Text(
                    _answer.isEmpty ? ' ' : '= $_answer',
                    textAlign: TextAlign.right,
                    style: displayStyle(context, size: 36),
                  ),
                ),
              ),
              if (_problem.isNotEmpty) Notice(_problem),
              const SizedBox(height: Space.lg),
              for (final List<(String, String)> row in _keys)
                Padding(
                  padding: const EdgeInsets.only(bottom: Space.sm),
                  child: Row(
                    children: <Widget>[
                      for (final (String label, String key) in row)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Space.xs),
                            child: label.isEmpty ? const SizedBox(height: 52) : _Key(label: label, primary: key == 'equals', onTap: () => _press(key)),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (_history.isNotEmpty) ...<Widget>[
          const SectionTitle('Earlier'),
          for (final (String sum, String answer) in _history)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Space.xs),
              child: Text('$sum = $answer', style: textStyle(context, color: palette.muted)),
            ),
        ],
      ],
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.label, required this.onTap, this.primary = false});

  final String label;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette.of(context);
    final String name = _keyNames[label] ?? label;
    return Tooltip(
      message: name,
      excludeFromSemantics: true,
      child: Semantics(
        button: true,
        label: name,
        excludeSemantics: true,
        child: Material(
          color: primary ? palette.accent : palette.accentSoft,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: SizedBox(
              height: 52,
              child: Center(child: Text(label, style: textStyle(context, size: 18, weight: FontWeight.w600, color: primary ? palette.onAccent : palette.ink))),
            ),
          ),
        ),
      ),
    );
  }
}

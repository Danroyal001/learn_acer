// Exam practice sets made on the spot, so every answer is right by
// construction: element symbols from the table, times tables, mental maths.
import 'dart:math' as math;

import '../content/element.dart';
import '../content/elements.g.dart';
import 'quiz_rules.dart';

enum PracticeTopic { elementSymbols, timesTables, mentalMaths }

String practiceTitle(PracticeTopic topic) => switch (topic) {
      PracticeTopic.elementSymbols => 'Element symbols',
      PracticeTopic.timesTables => 'Times tables',
      PracticeTopic.mentalMaths => 'Mental maths',
    };

String practiceBlurb(PracticeTopic topic) => switch (topic) {
      PracticeTopic.elementSymbols => 'The first 36 elements, both ways: name to symbol and symbol to name. Chemistry and Basic Science.',
      PracticeTopic.timesTables => 'Multiplication and division up to 12 × 12.',
      PracticeTopic.mentalMaths => 'Adding and taking away two- and three-digit numbers, without a calculator.',
    };

/// Ten questions on [topic], no question twice.
List<QuizQuestion> practiceSet(PracticeTopic topic, {math.Random? random}) {
  final math.Random dice = random ?? math.Random();
  final List<QuizQuestion> set = <QuizQuestion>[];
  final Set<String> asked = <String>{};
  while (set.length < 10) {
    final QuizQuestion question = switch (topic) {
      PracticeTopic.elementSymbols => _elementQuestion(dice),
      PracticeTopic.timesTables => _timesQuestion(dice),
      PracticeTopic.mentalMaths => _mentalQuestion(dice),
    };
    if (asked.add(question.prompt)) set.add(question);
  }
  return set;
}

/// Puts [right] among [wrong] (all distinct) at a random place.
QuizQuestion _shuffled(String prompt, String right, Iterable<String> wrong, math.Random dice, {String explanation = ''}) {
  final List<String> options = <String>{right, ...wrong}.take(4).toList()..shuffle(dice);
  return QuizQuestion(prompt: prompt, options: options, answer: options.indexOf(right), explanation: explanation);
}

/// Three distinct values from [make] that are not [right].
Set<String> _distractors(String right, String Function() make) {
  final Set<String> wrong = <String>{};
  int tries = 0;
  while (wrong.length < 3 && tries++ < 200) {
    final String candidate = make();
    if (candidate != right) wrong.add(candidate);
  }
  return wrong;
}

QuizQuestion _elementQuestion(math.Random dice) {
  // The elements a secondary-school syllabus expects by heart: 1 to 36.
  final List<ChemicalElement> pool = elements.take(36).toList();
  final ChemicalElement element = pool[dice.nextInt(pool.length)];
  final String why = '${element.name} is ${element.symbol}, atomic number ${element.number}.';
  if (dice.nextBool()) {
    final Set<String> wrong = _distractors(element.symbol, () => pool[dice.nextInt(pool.length)].symbol);
    return _shuffled('What is the symbol for ${element.name}?', element.symbol, wrong, dice, explanation: why);
  }
  final Set<String> wrong = _distractors(element.name, () => pool[dice.nextInt(pool.length)].name);
  return _shuffled('Which element has the symbol ${element.symbol}?', element.name, wrong, dice, explanation: why);
}

QuizQuestion _timesQuestion(math.Random dice) {
  final int left = 2 + dice.nextInt(11);
  final int right = 2 + dice.nextInt(11);
  final int product = left * right;
  if (dice.nextInt(3) == 0) {
    // Division that comes out exactly.
    final Set<String> wrong = _distractors('$left', () => '${math.max(1, left + dice.nextInt(7) - 3)}');
    return _shuffled('What is $product ÷ $right?', '$left', wrong, dice, explanation: '$left × $right = $product, so $product ÷ $right = $left.');
  }
  // Near misses: a neighbouring row or column of the table.
  final Set<String> wrong = _distractors('$product', () {
    final int nudge = dice.nextBool() ? left : right;
    return '${product + (dice.nextBool() ? nudge : -nudge) + (dice.nextInt(3) == 0 ? 1 : 0)}';
  });
  return _shuffled('What is $left × $right?', '$product', wrong, dice);
}

QuizQuestion _mentalQuestion(math.Random dice) {
  final bool add = dice.nextBool();
  final int left = 20 + dice.nextInt(880);
  final int right = 10 + dice.nextInt(add ? 500 : left - 9);
  final int answer = add ? left + right : left - right;
  // The usual slips: a carry or a borrow off by ten, a units digit off by one.
  final Set<String> wrong = _distractors('$answer', () => '${answer + <int>[10, -10, 1, -1, 100, -100][dice.nextInt(6)]}');
  return _shuffled('What is $left ${add ? '+' : '−'} $right?', '$answer', wrong, dice);
}

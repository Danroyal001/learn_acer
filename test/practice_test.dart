// Practice sets are generated, so every question must be right by construction.
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:learn_acer/content/element.dart';
import 'package:learn_acer/services/practice.dart';
import 'package:learn_acer/services/quiz_rules.dart';

void main() {
  for (final PracticeTopic topic in PracticeTopic.values) {
    test('${topic.name}: 10 valid questions, the answer once among distinct options', () {
      for (int seed = 0; seed < 50; seed++) {
        final List<QuizQuestion> set = practiceSet(topic, random: math.Random(seed));
        expect(set, hasLength(10));
        for (final QuizQuestion question in set) {
          expect(questionProblem(question), isNull, reason: question.prompt);
          expect(question.options.toSet().length, question.options.length, reason: question.prompt);
        }
        expect(set.map((QuizQuestion q) => q.prompt).toSet().length, 10, reason: 'no repeated question in a set');
      }
    });
  }

  test('element symbol questions are true to the table', () {
    for (final QuizQuestion question in practiceSet(PracticeTopic.elementSymbols, random: math.Random(7))) {
      final String right = question.options[question.answer];
      final RegExpMatch? asksSymbol = RegExp(r'^What is the symbol for (.+)\?$').firstMatch(question.prompt);
      final RegExpMatch? asksName = RegExp(r'^Which element has the symbol (.+)\?$').firstMatch(question.prompt);
      if (asksSymbol != null) expect(elementBySymbol(right)?.name, asksSymbol[1]);
      if (asksName != null) expect(elementBySymbol(asksName[1]!)?.name, right);
      expect(asksSymbol != null || asksName != null, isTrue);
    }
  });

  test('arithmetic answers are right', () {
    for (final PracticeTopic topic in <PracticeTopic>[PracticeTopic.timesTables, PracticeTopic.mentalMaths]) {
      for (final QuizQuestion question in practiceSet(topic, random: math.Random(3))) {
        final RegExpMatch match = RegExp(r'^What is (-?\d+) ([+−×÷]) (-?\d+)\?$').firstMatch(question.prompt)!;
        final int left = int.parse(match[1]!);
        final int right = int.parse(match[3]!);
        final int expected = switch (match[2]) { '+' => left + right, '−' => left - right, '×' => left * right, _ => left ~/ right };
        if (match[2] == '÷') expect(left % right, 0, reason: 'division questions divide exactly');
        expect(question.options[question.answer], '$expected');
      }
    }
  });
}

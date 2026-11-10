// The calculator follows the order of operations a maths teacher would mark right.
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_acer/services/calculator.dart';

void main() {
  double value(String expression, {bool degrees = true}) => evaluate(expression, degrees: degrees);

  test('order of operations', () {
    expect(value('2+3×4'), 14);
    expect(value('(2+3)×4'), 20);
    expect(value('10÷4'), 2.5);
    expect(value('2^3^2'), 512); // powers group from the right
    expect(value('-3^2'), -9); // the minus applies after the power
  });

  test('functions and constants', () {
    expect(value('sin(30)'), closeTo(0.5, 1e-12));
    expect(value('sin(30)', degrees: false), closeTo(-0.988, 0.001));
    expect(value('√(16)'), 4);
    expect(value('log(1000)'), closeTo(3, 1e-12));
    expect(value('ln(e)'), closeTo(1, 1e-12));
    expect(value('2π'), closeTo(6.283, 0.001));
    expect(value('5!'), 120);
    expect(value('50%'), 0.5);
  });

  test('mistakes are explained, not shown as a number', () {
    expect(() => value('1÷0'), throwsA(isA<CalculatorError>().having((CalculatorError e) => e.message, 'message', contains('zero'))));
    expect(() => value('2+'), throwsA(isA<CalculatorError>()));
    expect(() => value('(2+3'), throwsA(isA<CalculatorError>().having((CalculatorError e) => e.message, 'message', contains('bracket'))));
    expect(() => value('√(-4)'), throwsA(isA<CalculatorError>()));
  });

  test('answers are written without float noise', () {
    expect(formatAnswer(0.1 + 0.2), '0.3');
    expect(formatAnswer(1e21), '1e+21');
    expect(formatAnswer(14), '14');
  });
}

// A scientific calculator's arithmetic: a small recursive-descent parser over
// the keys on the calculator page. Pure Dart, so it is tested without a screen.
import 'dart:math' as math;

/// Why an expression has no answer, in words a student understands.
class const CalculatorError(final String message) implements Exception {
  @override
  String toString() => message;
}

/// The value of [expression]. Trigonometry works in degrees unless [degrees] is false.
double evaluate(String expression, {bool degrees = true}) {
  final _Parser parser = _Parser(_tokenise(expression), degrees: degrees);
  final double result = parser.parse();
  if (result.isNaN) throw CalculatorError('That has no real answer.');
  if (result.isInfinite)
    throw CalculatorError('The answer is too large to show.');
  return result;
}

/// An answer to at most 10 significant figures, without float noise (0.1+0.2 shows 0.3).
String formatAnswer(double value) {
  if (value == value.roundToDouble() && value.abs() < 1e15)
    return value.toInt().toString();
  if (value.abs() >= 1e15 || value.abs() < 1e-9)
    return value.toStringAsExponential(6).replaceFirst(RegExp(r'\.?0+e'), 'e');
  final String fixed = double.parse(value.toStringAsPrecision(10)).toString();
  return fixed;
}

enum _Kind { number, operator, open, close, name, end }

class const _Token(
  final _Kind kind,
  final String text, [
  final double number = 0,
]);

const Set<String> _functions = <String>{
  'sin',
  'cos',
  'tan',
  'asin',
  'acos',
  'atan',
  'log',
  'ln',
  '√',
  'abs',
};

List<_Token> _tokenise(String expression) {
  final List<_Token> tokens = <_Token>[];
  final String text = expression
      .replaceAll(' ', '')
      .replaceAll('*', '×')
      .replaceAll('/', '÷')
      .replaceAll('−', '-');
  int at = 0;
  while (at < text.length) {
    final String character = text[at];
    if (RegExp(r'[0-9.]').hasMatch(character)) {
      final Match match = RegExp(r'[0-9]*\.?[0-9]*(e[+-]?[0-9]+)?')
          .matchAsPrefix(text, at)!;
      final double? number = double.tryParse(match[0]!);
      if (number == null)
        throw CalculatorError('"${match[0]}" is not a number.');
      tokens.add(_Token(.number, match[0]!, number));
      at = match.end;
    } else if ('+-×÷^!%'.contains(character)) {
      tokens.add(_Token(.operator, character));
      at++;
    } else if (character == '(') {
      tokens.add(const _Token(.open, '('));
      at++;
    } else if (character == ')') {
      tokens.add(const _Token(.close, ')'));
      at++;
    } else if (character == 'π' || character == '√') {
      tokens.add(_Token(.name, character));
      at++;
    } else {
      final Match? match = RegExp(r'[a-z]+').matchAsPrefix(text, at);
      if (match == null)
        throw CalculatorError('"$character" is not a key on this calculator.');
      final String word = match[0]!;
      if (!_functions.contains(word) && word != 'e' && word != 'pi')
        throw CalculatorError(
          '"$word" is not a function this calculator knows.',
        );
      tokens.add(_Token(.name, word == 'pi' ? 'π' : word));
      at = match.end;
    }
  }
  tokens.add(const _Token(.end, ''));
  return tokens;
}

class _Parser(final List<_Token> tokens, {required final bool degrees}) {
  int position = 0;

  _Token get current => tokens[position];

  double parse() {
    if (tokens.length == 1) throw CalculatorError('Type a sum first.');
    final double value = _sum();
    if (current.kind == .close)
      throw CalculatorError(
        'There is a closing bracket with no opening bracket.',
      );
    if (current.kind != .end)
      throw CalculatorError('"${current.text}" is in the wrong place.');
    return value;
  }

  // sum := product (('+'|'-') product)*
  double _sum() {
    double value = _product();
    while (current.kind == .operator &&
        (current.text == '+' || current.text == '-')) {
      final String operator = current.text;
      position++;
      final double right = _product();
      value = operator == '+' ? value + right : value - right;
    }
    return value;
  }

  // product := unary (('×'|'÷') unary | implicit unary)*
  double _product() {
    double value = _unary();
    while (true) {
      if (current.kind == .operator &&
          (current.text == '×' || current.text == '÷')) {
        final String operator = current.text;
        position++;
        final double right = _unary();
        if (operator == '÷') {
          if (right == 0) throw CalculatorError('You cannot divide by zero.');
          value = value / right;
        } else {
          value = value * right;
        }
      } else if (current.kind == .open ||
          current.kind == .name ||
          current.kind == .number) {
        // 2π, 3(4+1), 2sin(30): a number next to a bracket or name multiplies.
        value = value * _unary();
      } else {
        return value;
      }
    }
  }

  // unary := '-' unary | power
  double _unary() {
    if (current.kind == .operator &&
        (current.text == '-' || current.text == '+')) {
      final bool negative = current.text == '-';
      position++;
      final double value = _unary();
      return negative ? -value : value;
    }
    return _power();
  }

  // power := postfix ('^' unary)?   (right-associative)
  double _power() {
    final double base = _postfix();
    if (current.kind == .operator && current.text == '^') {
      position++;
      return math.pow(base, _unary()).toDouble();
    }
    return base;
  }

  // postfix := atom ('!' | '%')*
  double _postfix() {
    double value = _atom();
    while (current.kind == .operator &&
        (current.text == '!' || current.text == '%')) {
      if (current.text == '%') {
        value = value / 100;
      } else {
        if (value < 0 || value != value.roundToDouble())
          throw CalculatorError(
            'Factorial needs a whole number that is not negative.',
          );
        if (value > 170)
          throw CalculatorError('The answer is too large to show.');
        double product = 1;
        for (int factor = 2; factor <= value; factor++) {
          product *= factor;
        }
        value = product;
      }
      position++;
    }
    return value;
  }

  double _atom() {
    final _Token token = current;
    switch (token.kind) {
      case .number:
        position++;
        return token.number;
      case .open:
        position++;
        final double value = _sum();
        if (current.kind != .close)
          throw CalculatorError('A bracket was opened and never closed.');
        position++;
        return value;
      case .name:
        position++;
        if (token.text == 'π') return math.pi;
        if (token.text == 'e') return math.e;
        return _apply(token.text, _argument(token.text));
      case .end:
        throw CalculatorError(
          'The sum ends too soon. Add a number after the last sign.',
        );
      case .close:
        throw CalculatorError(
          'There is a closing bracket with no opening bracket.',
        );
      case .operator:
        throw CalculatorError('"${token.text}" needs a number before it.');
    }
  }

  double _argument(String name) {
    if (current.kind == .open) return _atom();
    // √9 without brackets takes the next value.
    return _postfix();
  }

  double _apply(String name, double value) {
    final double toRadians = degrees ? math.pi / 180 : 1;
    final double fromRadians = degrees ? 180 / math.pi : 1;
    switch (name) {
      case 'sin':
        return _clean(math.sin(value * toRadians));
      case 'cos':
        return _clean(math.cos(value * toRadians));
      case 'tan':
        if (degrees && (value - 90) % 180 == 0)
          throw CalculatorError(
            'tan is not defined at ${formatAnswer(value)}°.',
          );
        return _clean(math.tan(value * toRadians));
      case 'asin':
        if (value.abs() > 1)
          throw CalculatorError('asin only takes values from -1 to 1.');
        return math.asin(value) * fromRadians;
      case 'acos':
        if (value.abs() > 1)
          throw CalculatorError('acos only takes values from -1 to 1.');
        return math.acos(value) * fromRadians;
      case 'atan':
        return math.atan(value) * fromRadians;
      case 'log':
        if (value <= 0)
          throw CalculatorError('log only takes numbers above zero.');
        return math.log(value) / math.ln10;
      case 'ln':
        if (value <= 0)
          throw CalculatorError('ln only takes numbers above zero.');
        return math.log(value);
      case '√':
        if (value < 0)
          throw CalculatorError('A negative number has no real square root.');
        return math.sqrt(value);
      case 'abs':
        return value.abs();
    }
    throw CalculatorError('"$name" is not a function this calculator knows.');
  }

  // sin(180) is 1.2e-16 in floating point; a calculator shows 0.
  double _clean(double value) => value.abs() < 1e-12 ? 0 : value;
}

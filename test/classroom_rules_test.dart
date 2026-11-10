// Classes are joined by a short code a teacher can read out loud.
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_acer/services/classroom_rules.dart';

void main() {
  test('codes are 6 characters with no look-alike letters', () {
    for (int index = 0; index < 200; index++) {
      final String code = newClassCode();
      expect(code, hasLength(6));
      expect(code, matches(RegExp(r'^[ABCDEFGHJKMNPQRSTUVWXYZ23456789]{6}$')));
    }
  });

  test('a typed code is tidied before it is checked', () {
    expect(normaliseClassCode(' ab3-k9z '), 'AB3K9Z');
    expect(normaliseClassCode('ab3k9'), isNull); // too short
    expect(normaliseClassCode('AB3K9O'), isNull); // O is never used
  });

  test('a class needs a name and a subject', () {
    expect(classProblem(name: '', subject: 'Maths'), contains('name'));
    expect(classProblem(name: 'JSS2 Gold', subject: ''), contains('subject'));
    expect(classProblem(name: 'JSS2 Gold', subject: 'Maths'), isNull);
  });

  test('only teacher, student and parent are roles', () {
    expect(roleFrom('teacher'), ClassRole.teacher);
    expect(roleFrom('Parent'), ClassRole.parent);
    expect(roleFrom('admin'), isNull);
  });
}

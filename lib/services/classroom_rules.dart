// Rules for classes that do not need a server: join codes, roles, checks.
import 'dart:math' as math;

/// Who someone is in a class.
enum ClassRole { teacher, student, parent }

/// Letters and digits that cannot be misread aloud or on a board (no 0/O, 1/I/L).
const String classCodeAlphabet = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';

final math.Random _random = math.Random.secure();

/// A fresh 6-character join code.
String newClassCode() => String.fromCharCodes(
      List<int>.generate(6, (_) => classCodeAlphabet.codeUnitAt(_random.nextInt(classCodeAlphabet.length))),
    );

/// [typed] in upper case without spaces or dashes, or null when it cannot be a code.
String? normaliseClassCode(String typed) {
  final String code = typed.toUpperCase().replaceAll(RegExp(r'[\s\-]'), '');
  if (code.length != 6) return null;
  for (final int unit in code.codeUnits) {
    if (!classCodeAlphabet.codeUnits.contains(unit)) return null;
  }
  return code;
}

/// What is missing from a new class, or null when it can be created.
String? classProblem({required String name, required String subject}) {
  if (name.trim().isEmpty) return 'Give the class a name, for example "JSS2 Gold".';
  if (name.trim().length > 60) return 'Keep the class name under 60 characters.';
  if (subject.trim().isEmpty) return 'Choose the subject the class is for.';
  return null;
}

ClassRole? roleFrom(String text) {
  for (final ClassRole role in ClassRole.values) {
    if (role.name == text.trim().toLowerCase()) return role;
  }
  return null;
}

/// The subjects a Nigerian primary or secondary class is usually for.
const List<String> schoolSubjects = <String>[
  'Mathematics',
  'English Language',
  'Basic Science',
  'Physics',
  'Chemistry',
  'Biology',
  'Further Mathematics',
  'Economics',
  'Government',
  'Literature in English',
  'Geography',
  'Civic Education',
  'Computer Studies',
  'Agricultural Science',
  'Accounting',
  'Commerce',
  'History',
  'Christian Religious Studies',
  'Islamic Religious Studies',
  'French',
  'Yoruba',
  'Igbo',
  'Hausa',
  'Other',
];

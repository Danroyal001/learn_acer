// ignore_for_file: unused_element_parameter
import 'package:dartvel_core/dartvel.dart';

/// A class a teacher started; people join it with [code].
@DVModel(generatePages: false)
class const _Classroom({
  required final String id,

  /// Six characters with no look-alike letters, read out in class.
  final String code = '',
  final String name = '',
  final String subject = '',
  final String teacherId = '',
  final String teacherName = '',
  required final DateTime createdAt,
});

/// Someone in a class: its teacher, a student or a parent.
@DVModel(generatePages: false)
class const _Membership({
  /// `<classId>:<userId>`, so joining twice is the same record.
  required final String id,
  final String classId = '',
  final String userId = '',
  final String name = '',
  final String email = '',

  /// `teacher`, `student` or `parent`.
  final String role = '',

  /// A parent's child, by the email the child signed up with.
  final String childEmail = '',
  required final DateTime joinedAt,
});

/// A note, link or resource the teacher posts: the class's learning aid.
@DVModel(generatePages: false)
class const _ClassNote({
  required final String id,
  final String classId = '',
  final String title = '',
  final String body = '',
  final String link = '',
  final String authorName = '',
  required final DateTime postedAt,
});

/// A multiple-choice quiz; [questions] is the stored form from quiz_rules.dart.
@DVModel(generatePages: false)
class const _Quiz({
  required final String id,
  final String classId = '',
  final String title = '',
  final String questions = '',
  required final DateTime createdAt,
});

/// One go at a quiz.
@DVModel(generatePages: false)
class const _QuizAttempt({
  required final String id,
  final String quizId = '',
  final String classId = '',
  final String userId = '',
  final String name = '',
  final int correct = 0,
  final int total = 0,

  /// The chosen option per question, comma separated, `-` when skipped.
  final String answers = '',
  required final DateTime takenAt,
});

// The server's side of classes: who is asking, what they may see, and the
// records each action writes. The backend functions are thin calls into this.
import 'dart:math' as math;

import 'package:dartvel_core/dartvel.dart';

import '../dartvel_client/dartvel_server.dart';
import '../services/classroom_rules.dart';
import '../services/quiz_rules.dart';

final math.Random _random = math.Random.secure();

String _newId() => '${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}${_random.nextInt(1 << 30).toRadixString(36)}';

/// The person behind [context], or a refusal asking them to sign in.
Future<AuthUser> signedIn(DVContext context) async {
  final DVSessionPrincipal? principal = context.session;
  if (principal != null) {
    final Object? user = principal.user;
    if (user is AuthUser) return user;
    final AuthUser? found = await DVAuthEndpoints.accountDirectory?.userById(principal.userId);
    if (found != null) return found;
  }
  throw const DVRefusal('Sign in first.', status: 401);
}

String displayName(AuthUser user) => (user.name ?? '').trim().isNotEmpty ? user.name!.trim() : user.email.split('@').first;

Future<Membership?> membershipOf(String classId, String userId) => Membership.find('$classId:$userId');

Future<(Classroom, Membership)> _memberOrRefuse(String classId, AuthUser user) async {
  final Classroom? classroom = await Classroom.find(classId);
  final Membership? membership = await membershipOf(classId, user.id);
  if (classroom == null || membership == null) throw const DVRefusal('You are not in that class.', status: 403);
  return (classroom, membership);
}

/// A teacher starts a class; they are its first member.
Future<Classroom> createClass(AuthUser teacher, {required String name, required String subject}) async {
  final String? problem = classProblem(name: name, subject: subject);
  if (problem != null) throw DVRefusal(problem);
  String code = newClassCode();
  while ((await classByCode(code)) != null) {
    code = newClassCode();
  }
  final DateTime now = DateTime.now().toUtc();
  final Classroom classroom = await Classroom(
    id: _newId(),
    code: code,
    name: name.trim(),
    subject: subject.trim(),
    teacherId: teacher.id,
    teacherName: displayName(teacher),
    createdAt: now,
  ).save();
  await Membership(id: '${classroom.id}:${teacher.id}', classId: classroom.id, userId: teacher.id, name: displayName(teacher), email: teacher.email, role: ClassRole.teacher.name, childEmail: '', joinedAt: now).save();
  return classroom;
}

Future<Classroom?> classByCode(String code) async {
  for (final Classroom classroom in await Classroom.all()) {
    if (classroom.code == code) return classroom;
  }
  return null;
}

/// A student or parent joins with the code. Joining again changes nothing.
Future<Classroom> joinClass(AuthUser user, {required String code, required String role, String childEmail = ''}) async {
  final String? tidy = normaliseClassCode(code);
  if (tidy == null) throw const DVRefusal('A class code is 6 letters and numbers, like K7M3QP.');
  final ClassRole? as = roleFrom(role);
  if (as == null || as == ClassRole.teacher) throw const DVRefusal('Join as a student or as a parent.');
  if (as == ClassRole.parent && !childEmail.contains('@')) throw const DVRefusal('Give the email your child signs in with, so you see their scores.');
  final Classroom? classroom = await classByCode(tidy);
  if (classroom == null) throw DVRefusal('No class has the code $tidy. Check it with your teacher.');
  final Membership? existing = await membershipOf(classroom.id, user.id);
  if (existing == null) {
    await Membership(
      id: '${classroom.id}:${user.id}',
      classId: classroom.id,
      userId: user.id,
      name: displayName(user),
      email: user.email,
      role: as.name,
      childEmail: as == ClassRole.parent ? childEmail.trim().toLowerCase() : '',
      joinedAt: DateTime.now().toUtc(),
    ).save();
  }
  return classroom;
}

/// The classes [user] is in, newest first, with their role in each.
Future<List<Map<String, Object?>>> myClasses(AuthUser user) async {
  final List<Map<String, Object?>> found = <Map<String, Object?>>[];
  for (final Membership membership in await Membership.all()) {
    if (membership.userId != user.id) continue;
    final Classroom? classroom = await Classroom.find(membership.classId);
    if (classroom == null) continue;
    found.add(<String, Object?>{
      'id': classroom.id,
      'name': classroom.name,
      'subject': classroom.subject,
      'teacher': classroom.teacherName,
      'role': membership.role,
      'code': membership.role == ClassRole.teacher.name ? classroom.code : '',
      'createdAt': classroom.createdAt.toIso8601String(),
    });
  }
  found.sort((Map<String, Object?> a, Map<String, Object?> b) => '${b['createdAt']}'.compareTo('${a['createdAt']}'));
  return found;
}

/// Whose scores [viewer] may see: everyone's for the teacher, their own for a
/// student, their child's for a parent.
bool maySeeScoresOf(Membership viewer, Membership student) => switch (roleFrom(viewer.role)) {
      ClassRole.teacher => true,
      ClassRole.student => viewer.userId == student.userId,
      ClassRole.parent => viewer.childEmail.isNotEmpty && viewer.childEmail == student.email.toLowerCase(),
      null => false,
    };

/// Everything the class page shows [user]: notes, quizzes, people (teacher
/// only) and the scores they may see.
Future<Map<String, Object?>> classView(AuthUser user, String classId) async {
  final (Classroom classroom, Membership me) = await _memberOrRefuse(classId, user);
  final bool teacher = me.role == ClassRole.teacher.name;
  final List<Membership> members = <Membership>[for (final Membership membership in await Membership.all()) if (membership.classId == classId) membership];
  final Map<String, Membership> byUser = <String, Membership>{for (final Membership membership in members) membership.userId: membership};
  final List<ClassNote> notes = <ClassNote>[for (final ClassNote note in await ClassNote.all()) if (note.classId == classId) note]
    ..sort((ClassNote a, ClassNote b) => b.postedAt.compareTo(a.postedAt));
  final List<Quiz> quizzes = <Quiz>[for (final Quiz quiz in await Quiz.all()) if (quiz.classId == classId) quiz]
    ..sort((Quiz a, Quiz b) => b.createdAt.compareTo(a.createdAt));
  final List<QuizAttempt> attempts = <QuizAttempt>[
    for (final QuizAttempt attempt in await QuizAttempt.all())
      if (attempt.classId == classId && byUser[attempt.userId] != null && maySeeScoresOf(me, byUser[attempt.userId]!)) attempt,
  ]..sort((QuizAttempt a, QuizAttempt b) => b.takenAt.compareTo(a.takenAt));
  final Map<String, String> quizTitles = <String, String>{for (final Quiz quiz in quizzes) quiz.id: quiz.title};
  return <String, Object?>{
    'id': classroom.id,
    'name': classroom.name,
    'subject': classroom.subject,
    'teacher': classroom.teacherName,
    'role': me.role,
    'code': teacher ? classroom.code : '',
    'notes': <Map<String, Object?>>[
      for (final ClassNote note in notes)
        <String, Object?>{'id': note.id, 'title': note.title, 'body': note.body, 'link': note.link, 'author': note.authorName, 'postedAt': note.postedAt.toIso8601String()},
    ],
    'quizzes': <Map<String, Object?>>[
      for (final Quiz quiz in quizzes) <String, Object?>{'id': quiz.id, 'title': quiz.title, 'questions': decodeQuiz(quiz.questions).length},
    ],
    'people': teacher
        ? <Map<String, Object?>>[
            for (final Membership membership in members)
              <String, Object?>{'name': membership.name, 'role': membership.role, if (membership.role == ClassRole.parent.name) 'child': membership.childEmail},
          ]
        : const <Map<String, Object?>>[],
    'scores': <Map<String, Object?>>[
      for (final QuizAttempt attempt in attempts)
        <String, Object?>{
          'quiz': quizTitles[attempt.quizId] ?? 'A quiz',
          'name': attempt.name,
          'correct': attempt.correct,
          'total': attempt.total,
          'grade': waecGrade(attempt.total == 0 ? 0 : (attempt.correct * 100 / attempt.total).round()),
          'takenAt': attempt.takenAt.toIso8601String(),
        },
    ],
  };
}

Future<Membership> _teacherOrRefuse(String classId, AuthUser user) async {
  final (Classroom _, Membership me) = await _memberOrRefuse(classId, user);
  if (me.role != ClassRole.teacher.name) throw const DVRefusal('Only the class teacher can do that.', status: 403);
  return me;
}

/// The teacher posts a note, a link, or both.
Future<void> postNote(AuthUser user, {required String classId, required String title, required String body, required String link}) async {
  final Membership me = await _teacherOrRefuse(classId, user);
  if (title.trim().isEmpty) throw const DVRefusal('Give the note a title.');
  final String tidyLink = link.trim();
  if (tidyLink.isNotEmpty && !RegExp(r'^https?://\S+\.\S+$').hasMatch(tidyLink)) throw const DVRefusal('A link starts with https:// and has no spaces.');
  if (body.trim().isEmpty && tidyLink.isEmpty) throw const DVRefusal('Write the note or add a link.');
  await ClassNote(id: _newId(), classId: classId, title: title.trim(), body: body.trim(), link: tidyLink, authorName: me.name, postedAt: DateTime.now().toUtc()).save();
}

/// The teacher sets a quiz; every question is checked before it is saved.
Future<String> createQuiz(AuthUser user, {required String classId, required String title, required String questions}) async {
  await _teacherOrRefuse(classId, user);
  if (title.trim().isEmpty) throw const DVRefusal('Give the quiz a title.');
  final List<QuizQuestion> parsed = decodeQuiz(questions);
  if (parsed.isEmpty) throw const DVRefusal('Add at least one question.');
  for (int index = 0; index < parsed.length; index++) {
    final String? problem = questionProblem(parsed[index]);
    if (problem != null) throw DVRefusal('Question ${index + 1}: $problem');
  }
  final Quiz quiz = await Quiz(id: _newId(), classId: classId, title: title.trim(), questions: encodeQuiz(parsed), createdAt: DateTime.now().toUtc()).save();
  return quiz.id;
}

/// A quiz for taking: the questions without their answers.
Future<Map<String, Object?>> quizForTaking(AuthUser user, String quizId) async {
  final Quiz? quiz = await Quiz.find(quizId);
  if (quiz == null) throw const DVRefusal('That quiz no longer exists.', status: 404);
  final (Classroom classroom, Membership _) = await _memberOrRefuse(quiz.classId, user);
  return <String, Object?>{
    'id': quiz.id,
    'title': quiz.title,
    'classId': classroom.id,
    'className': classroom.name,
    'questions': <Map<String, Object?>>[
      for (final QuizQuestion question in decodeQuiz(quiz.questions)) <String, Object?>{'prompt': question.prompt, 'options': question.options},
    ],
  };
}

/// Marks a go at a quiz on the server (the answers never leave it before
/// marking) and records it. Answers the review with the right options.
Future<Map<String, Object?>> submitAttempt(AuthUser user, {required String quizId, required List<int?> chosen}) async {
  final Quiz? quiz = await Quiz.find(quizId);
  if (quiz == null) throw const DVRefusal('That quiz no longer exists.', status: 404);
  final (Classroom _, Membership me) = await _memberOrRefuse(quiz.classId, user);
  final List<QuizQuestion> questions = decodeQuiz(quiz.questions);
  final QuizResult result = markQuiz(questions, chosen);
  if (me.role == ClassRole.student.name) {
    await QuizAttempt(
      id: _newId(),
      quizId: quiz.id,
      classId: quiz.classId,
      userId: user.id,
      name: me.name,
      correct: result.correct,
      total: result.total,
      answers: <String>[for (final ReviewedAnswer answer in result.review) answer.chosen?.toString() ?? '-'].join(','),
      takenAt: DateTime.now().toUtc(),
    ).save();
  }
  return <String, Object?>{
    'correct': result.correct,
    'total': result.total,
    'percent': result.percent,
    'grade': waecGrade(result.percent),
    'recorded': me.role == ClassRole.student.name,
    'review': <Map<String, Object?>>[
      for (final ReviewedAnswer answer in result.review)
        <String, Object?>{'chosen': answer.chosen, 'answer': answer.question.answer, 'explanation': answer.question.explanation},
    ],
  };
}

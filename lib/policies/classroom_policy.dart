// Every class record is written and read through the backend functions in
// lib/backend/functions, which check who is asking. The data API is closed, so
// nobody can list another class's members or a student's scores directly.
import 'package:dartvel_core/dartvel.dart';

import '../dartvel_client/dartvel_server.dart';

@DVPolicy(Classroom)
class ClassroomPolicy {
  bool viewAny(AuthUser? user, Classroom? classroom) => false;
  bool view(AuthUser? user, Classroom? classroom) => false;
  bool create(AuthUser? user, Classroom? classroom) => false;
  bool update(AuthUser? user, Classroom? classroom) => false;
  bool delete(AuthUser? user, Classroom? classroom) => false;
}

@DVPolicy(Membership)
class MembershipPolicy {
  bool viewAny(AuthUser? user, Membership? membership) => false;
  bool view(AuthUser? user, Membership? membership) => false;
  bool create(AuthUser? user, Membership? membership) => false;
  bool update(AuthUser? user, Membership? membership) => false;
  bool delete(AuthUser? user, Membership? membership) => false;
}

@DVPolicy(ClassNote)
class ClassNotePolicy {
  bool viewAny(AuthUser? user, ClassNote? note) => false;
  bool view(AuthUser? user, ClassNote? note) => false;
  bool create(AuthUser? user, ClassNote? note) => false;
  bool update(AuthUser? user, ClassNote? note) => false;
  bool delete(AuthUser? user, ClassNote? note) => false;
}

@DVPolicy(Quiz)
class QuizPolicy {
  bool viewAny(AuthUser? user, Quiz? quiz) => false;
  bool view(AuthUser? user, Quiz? quiz) => false;
  bool create(AuthUser? user, Quiz? quiz) => false;
  bool update(AuthUser? user, Quiz? quiz) => false;
  bool delete(AuthUser? user, Quiz? quiz) => false;
}

@DVPolicy(QuizAttempt)
class QuizAttemptPolicy {
  bool viewAny(AuthUser? user, QuizAttempt? attempt) => false;
  bool view(AuthUser? user, QuizAttempt? attempt) => false;
  bool create(AuthUser? user, QuizAttempt? attempt) => false;
  bool update(AuthUser? user, QuizAttempt? attempt) => false;
  bool delete(AuthUser? user, QuizAttempt? attempt) => false;
}

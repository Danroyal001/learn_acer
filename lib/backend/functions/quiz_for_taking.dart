// POST /api/quiz_for_taking: a quiz's questions, without the answers.
import 'package:dartvel_core/dartvel.dart';

import '../classrooms.dart';

@DVBackendFunction()
Future<Map<String, Object?>> _quizForTaking(DVContext context, String quizId) async => quizForTaking(await signedIn(context), quizId);

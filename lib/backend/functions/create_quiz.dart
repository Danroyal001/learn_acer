// POST /api/create_quiz: the teacher sets a multiple-choice quiz.
import 'package:dartvel_core/dartvel.dart';

import '../classrooms.dart';

@DVBackendFunction(middleware: [DVMiddlewares.rateLimit])
Future<String> _createQuiz(DVContext context, String classId, String title, String questions) async =>
    createQuiz(await signedIn(context), classId: classId, title: title, questions: questions);

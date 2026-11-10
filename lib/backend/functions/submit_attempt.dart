// POST /api/submit_attempt: marks a go at a quiz on the server.
// [answers] is one entry per question, comma separated: the option's index, or `-` when skipped.
import 'package:dartvel_core/dartvel.dart';

import '../classrooms.dart';

@DVBackendFunction(middleware: [DVMiddlewares.rateLimit])
Future<Map<String, Object?>> _submitAttempt(DVContext context, String quizId, String answers) async => submitAttempt(
      await signedIn(context),
      quizId: quizId,
      chosen: <int?>[for (final String part in answers.split(',')) int.tryParse(part.trim())],
    );

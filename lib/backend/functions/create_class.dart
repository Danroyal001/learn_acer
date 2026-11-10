// POST /api/create_class: a teacher starts a class and gets its join code.
import 'package:dartvel_core/dartvel.dart';

import '../classrooms.dart';

@DVBackendFunction(middleware: [DVMiddlewares.rateLimit])
Future<Map<String, Object?>> _createClass(DVContext context, String name, String subject) async {
  final classroom = await createClass(await signedIn(context), name: name, subject: subject);
  return <String, Object?>{'id': classroom.id, 'code': classroom.code};
}

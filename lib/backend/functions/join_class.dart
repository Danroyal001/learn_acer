// POST /api/join_class: a student or parent joins with the class code.
import 'package:dartvel_core/dartvel.dart';

import '../classrooms.dart';

@DVBackendFunction(middleware: [DVMiddlewares.rateLimit])
Future<Map<String, Object?>> _joinClass(DVContext context, String code, String role, String childEmail) async {
  final classroom = await joinClass(await signedIn(context), code: code, role: role, childEmail: childEmail);
  return <String, Object?>{'id': classroom.id};
}

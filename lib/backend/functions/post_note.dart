// POST /api/post_note: the teacher posts a note or link to the class.
import 'package:dartvel_core/dartvel.dart';

import '../classrooms.dart';

@DVBackendFunction(middleware: [DVMiddlewares.rateLimit])
Future<bool> _postNote(DVContext context, String classId, String title, String noteText, String link) async {
  await postNote(await signedIn(context), classId: classId, title: title, body: noteText, link: link);
  return true;
}

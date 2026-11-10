// POST /api/class_view: one class as the signed-in member may see it.
import 'package:dartvel_core/dartvel.dart';

import '../classrooms.dart';

@DVBackendFunction()
Future<Map<String, Object?>> _classView(DVContext context, String classId) async => classView(await signedIn(context), classId);

// POST /api/my_classes: the classes the signed-in person is in.
import 'package:dartvel_core/dartvel.dart';

import '../classrooms.dart';

@DVBackendFunction()
Future<List<Map<String, Object?>>> _myClasses(DVContext context) async => myClasses(await signedIn(context));

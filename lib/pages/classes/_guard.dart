import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../dartvel_client/dartvel_client.dart';

/// Classes and quizzes belong to the people in them: sign in first. The server
/// answers these pages the same way, so a signed-out request never gets them.
FutureOr<String?> guard(BuildContext context, GoRouterState state) => DVAccountPages.requireSession(context, state);

import 'package:flutter/material.dart';

import 'components/ui.dart';
import 'dartvel_client/dartvel_client.dart';

/// The app's root: the framework's router in Learn Acer's exercise-book
/// (light) and chalkboard (dark) themes, following the device's setting.
@DVAppRoot()
Widget _learnAcerRoot(BuildContext context, DVAppParts parts) => MaterialApp.router(
      title: 'Learn Acer',
      debugShowCheckedModeBanner: false,
      themeMode: .system,
      theme: learnAcerTheme(.light),
      darkTheme: learnAcerTheme(.dark),
      routerConfig: parts.router,
    );

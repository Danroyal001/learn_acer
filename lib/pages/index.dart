import 'package:flutter/widgets.dart';
import '../dartvel_client/dartvel_client.dart';

@DVPage(title: 'Dartvel', showAppBar: true, centerTitle: true)
Widget _indexPage(BuildContext context) => DVBox.list([
      const DVText('Welcome to Dartvel'),
      const DVText('DARTVEL').modifier(
        const DVModifier().fontSize(28).fontWeight(.w800),
      ),
      const DVText('Your Dartvel app is ready!').modifier(
        const DVModifier().padding(8),
      ),
      DVText('Loaded at: ${DateTime.now().toIso8601String()}'),
    ]).modifier(
      const DVModifier().padding(24).align(.center),
    );

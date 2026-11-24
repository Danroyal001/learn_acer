// Privacy and terms say what Learn Acer keeps and who to ask, and every page's footer links to both.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_acer/components/ui.dart';
import 'package:learn_acer/dartvel_client/dartvel_client.dart';

Future<void> show(WidgetTester tester, Widget screen) async {
  tester.view.physicalSize = const Size(390, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(theme: learnAcerTheme(Brightness.light), home: Scaffold(body: SingleChildScrollView(child: screen))));
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

void main() {
  testWidgets('the privacy page says what is kept, what parents see and who to ask', (WidgetTester tester) async {
    await show(tester, const PrivacyScreen());
    expect(find.text('Privacy'), findsWidgets);
    expect(find.textContaining('quiz attempt'), findsWidgets);
    expect(find.textContaining('only that child'), findsWidgets);
    expect(find.textContaining('Practice scores are not saved'), findsWidgets);
    expect(find.textContaining('info@sigmadev.digital'), findsWidgets);
  });

  testWidgets('the terms page names who runs Learn Acer and the law', (WidgetTester tester) async {
    await show(tester, const TermsScreen());
    expect(find.text('Terms of use'), findsWidgets);
    expect(find.textContaining('SigmaDev Digital'), findsWidgets);
    expect(find.textContaining('laws of Nigeria'), findsWidgets);
  });

  testWidgets('the footer on every page links to privacy and terms', (WidgetTester tester) async {
    await show(tester, const SiteFooter());
    expect(find.text('Privacy'), findsOneWidget);
    expect(find.text('Terms of use'), findsOneWidget);
  });
}

// The calculator screen takes a typed sum and answers it, without throwing.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_acer/components/ui.dart';
import 'package:learn_acer/dartvel_client/dartvel_client.dart';

void main() {
  testWidgets('typing a sum and pressing Enter shows the answer', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(theme: learnAcerTheme(Brightness.light), home: const Scaffold(body: SingleChildScrollView(child: CalculatorScreen()))));
    await tester.pumpAndSettle();
    final Finder field = find.byType(EditableText).first;
    await tester.tap(field);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.enterText(field, '2+3×4');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('= 14'), findsOneWidget);
  });
}

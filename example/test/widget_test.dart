import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ir_sensor_plugin_example/main.dart';

void main() {
  testWidgets('Verify Platform version', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that platform version is retrieved.
    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is Text && widget.data!.startsWith('Running on:'),
      ),
      findsOneWidget,
    );
  });
  testWidgets('Verify Has IR emitter', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify has IR emitter is retrieved.
    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is Text && widget.data!.startsWith('Has Ir Emitter:'),
      ),
      findsOneWidget,
    );
  });
  testWidgets('Verify IR Carrier Frequencies', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that IR carrier frequencies is retrieved.
    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is Text &&
            widget.data!.startsWith('IR Carrier Frequencies:'),
      ),
      findsOneWidget,
    );
  });
  group('FormSpecificCode', () {
    const mockCode = 'CODE HEX';

    const keyInputKey = Key('textField_code_hex');
    const saveButtonKey = Key('key_buttom_hex');

    testWidgets(
      'trasmitting HEX code when pressing ElevatedButton',
      (tester) async {
        await tester.pumpWidget(MyApp());
        await tester.enterText(find.byKey(keyInputKey), mockCode);

        await tester.ensureVisible(find.byKey(saveButtonKey));
        await tester.tap(find.byKey(saveButtonKey));
      },
    );
  });
}

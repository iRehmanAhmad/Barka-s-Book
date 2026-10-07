import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barka_book/core/widgets/bouncy_button.dart';

void main() {
  testWidgets('BouncyButton renders child and triggers callback on tap', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: BouncyButton(
              onPressed: () {
                tapped = true;
              },
              child: const Text('Tap Me!'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Tap Me!'), findsOneWidget);

    await tester.tap(find.byType(BouncyButton));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:barka_book/main.dart';

void main() {
  testWidgets('BarkaBookApp smoke test - verifies title renders', (WidgetTester tester) async {
    await tester.pumpWidget(const BarkaBookApp());
    expect(find.text("Barka's Book (بارکہ کی کتاب)"), findsOneWidget);
  });
}

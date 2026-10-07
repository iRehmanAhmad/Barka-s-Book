import 'package:flutter_test/flutter_test.dart';
import 'package:barka_book/main.dart';
import 'package:barka_book/core/audio/audio_controller.dart';
import 'package:barka_book/core/storage/progress_repository.dart';
import 'package:barka_book/features/book_engine/data/repositories/book_repository.dart';

void main() {
  testWidgets('BarkaBookApp smoke test - verifies main dashboard launches', (WidgetTester tester) async {
    await tester.pumpWidget(BarkaBookApp(
      audioController: AudioController(),
      bookRepository: BookRepository(),
      progressRepository: ProgressRepository(),
    ));

    expect(find.text('Barka Faral 👧'), findsOneWidget);
    expect(find.text("Barka's Book Shelf 📚"), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barka_book/features/home/presentation/screens/home_screen.dart';
import 'package:barka_book/features/book_engine/data/repositories/book_repository.dart';
import 'package:barka_book/core/audio/audio_controller.dart';
import 'package:barka_book/core/storage/progress_repository.dart';

void main() {
  testWidgets('HomeScreen renders Barka profile greeting and bookshelf subjects', (WidgetTester tester) async {
    final audioController = AudioController();
    final bookRepository = BookRepository();
    final progressRepository = ProgressRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          bookRepository: bookRepository,
          audioController: audioController,
          progressRepository: progressRepository,
        ),
      ),
    );

    expect(find.text('Barka Faral 👧'), findsOneWidget);
    expect(find.text("Barka's Book Shelf 📚"), findsOneWidget);
    expect(find.text('English Phonics'), findsOneWidget);
    expect(find.text('اردو قاعدہ'), findsOneWidget);
    expect(find.text('Fun Maths & Numbers'), findsOneWidget);
  });
}

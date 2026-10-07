import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barka_book/features/book_engine/data/models/book_manifest.dart';
import 'package:barka_book/features/book_engine/data/models/book_page.dart';
import 'package:barka_book/features/book_engine/data/models/hotspot_item.dart';
import 'package:barka_book/features/book_engine/data/models/vocabulary_word.dart';
import 'package:barka_book/features/book_engine/presentation/screens/book_reader_screen.dart';
import 'package:barka_book/core/audio/audio_controller.dart';

void main() {
  testWidgets('BookReaderScreen renders pages and handles page navigation', (WidgetTester tester) async {
    final manifest = BookManifest(
      bookId: 'test_book',
      title: 'English Test',
      subject: 'english',
      grade: 'nursery',
      isRtl: false,
      pages: [
        const BookPage(
          pageNumber: 1,
          letter: 'A',
          mainIllustration: HotspotItem(assetPath: 'test.json', type: 'lottie'),
          vocabularyWords: [
            VocabularyWord(word: 'Apple', audio: 'apple.ogg'),
          ],
        ),
        const BookPage(
          pageNumber: 2,
          letter: 'B',
          mainIllustration: HotspotItem(assetPath: 'test.json', type: 'lottie'),
          vocabularyWords: [
            VocabularyWord(word: 'Ball', audio: 'ball.ogg'),
          ],
        ),
      ],
    );

    final audioController = AudioController();

    await tester.pumpWidget(
      MaterialApp(
        home: BookReaderScreen(
          manifest: manifest,
          audioController: audioController,
        ),
      ),
    );

    // Page 1 should display 'A' and 'Apple'
    expect(find.text('A'), findsOneWidget);
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('1 / 2'), findsOneWidget);

    // Tap next page
    final nextButtonFinder = find.byIcon(Icons.arrow_forward_rounded);
    expect(nextButtonFinder, findsOneWidget);
    await tester.tap(nextButtonFinder);
    await tester.pumpAndSettle();

    // Page 2 should display 'B' and 'Ball'
    expect(find.text('B'), findsOneWidget);
    expect(find.text('Ball'), findsOneWidget);
    expect(find.text('2 / 2'), findsOneWidget);
  });
}

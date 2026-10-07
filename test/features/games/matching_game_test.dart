import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barka_book/features/games/matching/presentation/screens/matching_game_screen.dart';
import 'package:barka_book/core/audio/audio_controller.dart';

void main() {
  testWidgets('MatchingGameScreen renders pairs and back button', (WidgetTester tester) async {
    final pairs = [
      {'symbol': 'A', 'target': 'Apple'},
      {'symbol': 'B', 'target': 'Ball'},
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: MatchingGameScreen(
          pairs: pairs,
          audioController: AudioController(),
        ),
      ),
    );

    expect(find.text('Match & Connect! 🎯'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Ball'), findsOneWidget);
  });
}

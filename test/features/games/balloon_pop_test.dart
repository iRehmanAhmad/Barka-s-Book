import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barka_book/features/games/balloon_pop/presentation/screens/balloon_pop_screen.dart';
import 'package:barka_book/core/audio/audio_controller.dart';

void main() {
  testWidgets('BalloonPopScreen renders target prompt and balloons', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BalloonPopScreen(
          targetSound: 'audio/english/phonics/b.ogg',
          correctSymbol: 'B',
          distractorSymbols: const ['A', 'C'],
          audioController: AudioController(),
        ),
      ),
    );

    expect(find.text('Pop: "B" 🎈'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
  });
}

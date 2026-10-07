import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barka_book/features/book_engine/data/models/mini_game_config.dart';
import 'package:barka_book/features/games/tracing/domain/tracing_detector.dart';

void main() {
  group('TracingDetector Unit Tests', () {
    test('Calculates checkpoints proximity and marks completion', () {
      final checkpoints = [
        const TracingPoint(x: 0.2, y: 0.2),
        const TracingPoint(x: 0.5, y: 0.5),
        const TracingPoint(x: 0.8, y: 0.8),
      ];

      final detector = TracingDetector(
        checkpoints: checkpoints,
        proximityThreshold: 20.0,
      );

      const canvasSize = Size(100, 100);

      // Checkpoint 0 is at (20, 20)
      bool touched0 = detector.registerTouch(const Offset(22, 21), canvasSize);
      expect(touched0, isTrue);
      expect(detector.reachedIndices.contains(0), isTrue);
      expect(detector.completionProgress, closeTo(1 / 3, 0.01));
      expect(detector.isCompleted, isFalse);

      // Checkpoint 1 is at (50, 50)
      bool touched1 = detector.registerTouch(const Offset(49, 52), canvasSize);
      expect(touched1, isTrue);
      expect(detector.reachedIndices.contains(1), isTrue);
      expect(detector.completionProgress, closeTo(2 / 3, 0.01));
      expect(detector.isCompleted, isFalse);

      // Checkpoint 2 is at (80, 80)
      bool touched2 = detector.registerTouch(const Offset(81, 79), canvasSize);
      expect(touched2, isTrue);
      expect(detector.reachedIndices.contains(2), isTrue);
      expect(detector.completionProgress, 1.0);
      expect(detector.isCompleted, isTrue);
    });

    test('reset clears reached checkpoints', () {
      final checkpoints = [
        const TracingPoint(x: 0.5, y: 0.5),
      ];
      final detector = TracingDetector(checkpoints: checkpoints);
      detector.registerTouch(const Offset(50, 50), const Size(100, 100));
      expect(detector.isCompleted, isTrue);

      detector.reset();
      expect(detector.reachedIndices, isEmpty);
      expect(detector.isCompleted, isFalse);
    });
  });
}

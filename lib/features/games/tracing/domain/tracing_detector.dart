import 'dart:math';
import 'package:flutter/material.dart';
import '../../../book_engine/data/models/mini_game_config.dart';

class TracingDetector {
  final List<TracingPoint> checkpoints;
  final double proximityThreshold;
  final Set<int> _reachedIndices = {};

  TracingDetector({
    required this.checkpoints,
    this.proximityThreshold = 45.0,
  });

  Set<int> get reachedIndices => Set.unmodifiable(_reachedIndices);

  double get completionProgress {
    if (checkpoints.isEmpty) return 1.0;
    return _reachedIndices.length / checkpoints.length;
  }

  bool get isCompleted => completionProgress >= 0.80;

  bool registerTouch(Offset touchPoint, Size canvasSize) {
    if (checkpoints.isEmpty) return true;

    bool newlyReached = false;
    for (int i = 0; i < checkpoints.length; i++) {
      if (_reachedIndices.contains(i)) continue;

      final targetX = checkpoints[i].x * canvasSize.width;
      final targetY = checkpoints[i].y * canvasSize.height;

      final distance = sqrt(pow(touchPoint.dx - targetX, 2) + pow(touchPoint.dy - targetY, 2));
      if (distance <= proximityThreshold) {
        _reachedIndices.add(i);
        newlyReached = true;
      }
    }
    return newlyReached;
  }

  void reset() {
    _reachedIndices.clear();
  }
}

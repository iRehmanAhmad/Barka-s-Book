import 'package:flutter/material.dart';
import 'package:barka_book/features/book_engine/data/models/mini_game_config.dart';

class TracingPainter extends CustomPainter {
  final List<TracingPoint> guidePoints;
  final Set<int> reachedIndices;
  final List<Offset> userStrokes;
  final Color strokeColor;

  TracingPainter({
    required this.guidePoints,
    required this.reachedIndices,
    required this.userStrokes,
    this.strokeColor = const Color(0xFFFFB703),
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Guideline Track
    final guidePaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 28
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    if (guidePoints.length > 1) {
      final path = Path();
      path.moveTo(guidePoints[0].x * size.width, guidePoints[0].y * size.height);
      for (int i = 1; i < guidePoints.length; i++) {
        path.lineTo(guidePoints[i].x * size.width, guidePoints[i].y * size.height);
      }
      canvas.drawPath(path, guidePaint);
    }

    // 2. Draw Checkpoint Dots
    for (int i = 0; i < guidePoints.length; i++) {
      final center = Offset(guidePoints[i].x * size.width, guidePoints[i].y * size.height);
      final isReached = reachedIndices.contains(i);

      final dotPaint = Paint()
        ..color = isReached ? const Color(0xFF2A9D8F) : const Color(0xFFFB8500)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, isReached ? 14 : 10, dotPaint);

      // White inner core
      final corePaint = Paint()..color = Colors.white;
      canvas.drawCircle(center, 4, corePaint);
    }

    // 3. Draw User's Finger Strokes
    if (userStrokes.length > 1) {
      final userPaint = Paint()
        ..color = strokeColor
        ..strokeWidth = 22
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      final userPath = Path();
      userPath.moveTo(userStrokes[0].dx, userStrokes[0].dy);
      for (int i = 1; i < userStrokes.length; i++) {
        userPath.lineTo(userStrokes[i].dx, userStrokes[i].dy);
      }
      canvas.drawPath(userPath, userPaint);
    }
  }

  @override
  bool shouldRepaint(covariant TracingPainter oldDelegate) {
    return true;
  }
}

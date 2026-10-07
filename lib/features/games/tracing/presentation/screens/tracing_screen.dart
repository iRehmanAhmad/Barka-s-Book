import 'package:flutter/material.dart';
import '../../../book_engine/data/models/mini_game_config.dart';
import '../../../../core/audio/audio_controller.dart';
import '../../../../core/audio/sound_effects.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/bouncy_button.dart';
import '../../domain/tracing_detector.dart';
import '../widgets/tracing_canvas.dart';

class TracingScreen extends StatefulWidget {
  final MiniGameConfig config;
  final AudioController audioController;
  final VoidCallback? onComplete;

  const TracingScreen({
    super.key,
    required this.config,
    required this.audioController,
    this.onComplete,
  });

  @override
  State<TracingScreen> createState() => _TracingScreenState();
}

class _TracingScreenState extends State<TracingScreen> {
  late TracingDetector _detector;
  final List<Offset> _userStrokes = [];
  bool _isSuccessCelebration = false;

  @override
  void initState() {
    super.initState();
    _detector = TracingDetector(
      checkpoints: widget.config.guidePoints ?? [],
    );
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    if (_isSuccessCelebration) return;

    setState(() {
      _userStrokes.add(details.localPosition);
      final reachedNew = _detector.registerTouch(details.localPosition, size);
      if (reachedNew) {
        widget.audioController.playSfx(SoundEffects.pop, volume: 0.6);
      }
    });

    if (_detector.isCompleted && !_isSuccessCelebration) {
      _onCompleted();
    }
  }

  void _onCompleted() {
    setState(() {
      _isSuccessCelebration = true;
    });

    widget.audioController.playSfx(SoundEffects.cheer);
    widget.audioController.playSfx(SoundEffects.applause);
    widget.onComplete?.call();
  }

  void _reset() {
    setState(() {
      _userStrokes.clear();
      _detector.reset();
      _isSuccessCelebration = false;
    });
    widget.audioController.playSfx(SoundEffects.whoosh);
  }

  @override
  Widget build(BuildContext context) {
    final symbol = widget.config.targetSymbol ?? '';

    return Scaffold(
      backgroundColor: AppColors.softBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BouncyButton(
                    onPressed: () => Navigator.maybePop(context),
                    backgroundColor: AppColors.oceanTeal,
                    minWidth: 52,
                    minHeight: 52,
                    borderRadius: BorderRadius.circular(26),
                    child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                  ),
                  Text(
                    'Trace "$symbol"',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepNavy,
                    ),
                  ),
                  BouncyButton(
                    onPressed: _reset,
                    backgroundColor: AppColors.primaryYellow,
                    minWidth: 52,
                    minHeight: 52,
                    borderRadius: BorderRadius.circular(26),
                    child: const Icon(Icons.refresh_rounded, color: AppColors.deepNavy, size: 28),
                  ),
                ],
              ),
            ),

            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: _detector.completionProgress,
                  minHeight: 14,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.appleRed),
                ),
              ),
            ),

            // Tracing Canvas Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final canvasSize = Size(constraints.maxWidth, constraints.maxHeight);

                    return Stack(
                      children: [
                        GestureDetector(
                          onPanStart: (details) => _onPanUpdate(
                            DragUpdateDetails(globalPosition: details.globalPosition, localPosition: details.localPosition),
                            canvasSize,
                          ),
                          onPanUpdate: (details) => _onPanUpdate(details, canvasSize),
                          child: Container(
                            width: canvasSize.width,
                            height: canvasSize.height,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(color: AppColors.cardBorder, width: 3),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x14000000),
                                  blurRadius: 16,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: CustomPaint(
                              painter: TracingPainter(
                                guidePoints: widget.config.guidePoints ?? [],
                                reachedIndices: _detector.reachedIndices,
                                userStrokes: _userStrokes,
                              ),
                            ),
                          ),
                        ),

                        // Success Celebration Card
                        if (_isSuccessCelebration)
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(32),
                                border: Border.all(color: AppColors.starGold, width: 4),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x33000000),
                                    blurRadius: 24,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star_rounded, size: 80, color: AppColors.starGold),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Shabash Barka!\nGreat Job! 🌟',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.deepNavy,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  BouncyButton(
                                    onPressed: () => Navigator.maybePop(context),
                                    backgroundColor: AppColors.oceanTeal,
                                    child: const Text(
                                      'Next! ➡️',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

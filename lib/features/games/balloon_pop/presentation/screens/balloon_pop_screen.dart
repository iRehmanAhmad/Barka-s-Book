import 'package:flutter/material.dart';
import '../../../../core/audio/audio_controller.dart';
import '../../../../core/audio/sound_effects.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/bouncy_button.dart';
import '../widgets/floating_balloon.dart';

class BalloonPopScreen extends StatefulWidget {
  final String targetSound;
  final String correctSymbol;
  final List<String> distractorSymbols;
  final AudioController audioController;
  final VoidCallback? onComplete;

  const BalloonPopScreen({
    super.key,
    required this.targetSound,
    required this.correctSymbol,
    required this.distractorSymbols,
    required this.audioController,
    this.onComplete,
  });

  @override
  State<BalloonPopScreen> createState() => _BalloonPopScreenState();
}

class _BalloonPopScreenState extends State<BalloonPopScreen> {
  late List<String> _allSymbols;
  bool _isSuccessCelebration = false;

  final List<Color> _balloonColors = const [
    Color(0xFFFF006E),
    Color(0xFF2196F3),
    Color(0xFFFB8500),
    Color(0xFF55A630),
  ];

  @override
  void initState() {
    super.initState();
    _allSymbols = [widget.correctSymbol, ...widget.distractorSymbols]..shuffle();
    _playPromptAudio();
  }

  void _playPromptAudio() {
    widget.audioController.speakPhonics(widget.targetSound);
  }

  void _onBalloonTapped(String symbol) {
    if (_isSuccessCelebration) return;

    if (symbol == widget.correctSymbol) {
      widget.audioController.playSfx(SoundEffects.pop);
      setState(() {
        _isSuccessCelebration = true;
      });
      widget.audioController.playSfx(SoundEffects.cheer);
      widget.audioController.playSfx(SoundEffects.applause);
      widget.onComplete?.call();
    } else {
      widget.audioController.playSfx(SoundEffects.boing);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F2FE), // Sky-like background
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
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
                    'Pop: "${widget.correctSymbol}" 🎈',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepNavy,
                    ),
                  ),
                  BouncyButton(
                    onPressed: _playPromptAudio,
                    backgroundColor: AppColors.starGold,
                    minWidth: 52,
                    minHeight: 52,
                    borderRadius: BorderRadius.circular(26),
                    child: const Icon(Icons.volume_up_rounded, color: AppColors.deepNavy, size: 28),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Balloon Sky Playground
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Wrap(
                      spacing: 32,
                      runSpacing: 40,
                      alignment: WrapAlignment.center,
                      children: List.generate(_allSymbols.length, (index) {
                        final symbol = _allSymbols[index];
                        final color = _balloonColors[index % _balloonColors.length];

                        return FloatingBalloon(
                          symbol: symbol,
                          color: color,
                          onTap: () => _onBalloonTapped(symbol),
                        );
                      }),
                    ),
                  ),

                  // Success Celebration Card
                  if (_isSuccessCelebration)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                            const Icon(Icons.celebration_rounded, size: 80, color: AppColors.berryPink),
                            const SizedBox(height: 8),
                            const Text(
                              'Pop! Excellent!\nYou Found It! 🎈✨',
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
                                'Next! 🌟',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

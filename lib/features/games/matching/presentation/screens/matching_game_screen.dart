import 'package:flutter/material.dart';
import '../../../../core/audio/audio_controller.dart';
import '../../../../core/audio/sound_effects.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/bouncy_button.dart';

class MatchingGameScreen extends StatefulWidget {
  final List<Map<String, String>> pairs;
  final AudioController audioController;
  final VoidCallback? onComplete;

  const MatchingGameScreen({
    super.key,
    required this.pairs,
    required this.audioController,
    this.onComplete,
  });

  @override
  State<MatchingGameScreen> createState() => _MatchingGameScreenState();
}

class _MatchingGameScreenState extends State<MatchingGameScreen> {
  final Set<String> _matchedSymbols = {};
  bool _isSuccessCelebration = false;

  void _onMatched(String symbol) {
    setState(() {
      _matchedSymbols.add(symbol);
    });

    widget.audioController.playSfx(SoundEffects.pop);

    if (_matchedSymbols.length == widget.pairs.length) {
      setState(() {
        _isSuccessCelebration = true;
      });
      widget.audioController.playSfx(SoundEffects.cheer);
      widget.audioController.playSfx(SoundEffects.applause);
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
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
                  const Text(
                    'Match & Connect! 🎯',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepNavy,
                    ),
                  ),
                  const SizedBox(width: 52),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Matching Columns
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left Column: Draggable Symbols
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: widget.pairs.map((pair) {
                            final symbol = pair['symbol'] ?? '';
                            final isMatched = _matchedSymbols.contains(symbol);

                            if (isMatched) {
                              return Opacity(
                                opacity: 0.3,
                                child: _buildSymbolCard(symbol, isMatched: true),
                              );
                            }

                            return Draggable<String>(
                              data: symbol,
                              feedback: Material(
                                color: Colors.transparent,
                                child: _buildSymbolCard(symbol, isDragging: true),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.3,
                                child: _buildSymbolCard(symbol),
                              ),
                              child: _buildSymbolCard(symbol),
                            );
                          }).toList(),
                        ),

                        // Right Column: Target Match Cards
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: widget.pairs.map((pair) {
                            final symbol = pair['symbol'] ?? '';
                            final target = pair['target'] ?? '';
                            final isMatched = _matchedSymbols.contains(symbol);

                            return DragTarget<String>(
                              onWillAcceptWithDetails: (details) => details.data == symbol,
                              onAcceptWithDetails: (details) => _onMatched(details.data),
                              builder: (context, candidateData, rejectedData) {
                                final isHovered = candidateData.isNotEmpty;

                                return Container(
                                  width: 140,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: isMatched
                                        ? const Color(0xFFD8F3DC)
                                        : (isHovered ? const Color(0xFFFFF3B0) : Colors.white),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isMatched
                                          ? AppColors.grassGreen
                                          : (isHovered ? AppColors.sunOrange : AppColors.cardBorder),
                                      width: 3,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x14000000),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (isMatched)
                                        const Padding(
                                          padding: EdgeInsets.only(right: 6),
                                          child: Icon(Icons.check_circle_rounded, color: AppColors.grassGreen, size: 24),
                                        ),
                                      Text(
                                        target,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isMatched ? AppColors.grassGreen : AppColors.deepNavy,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ],
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
                            const Icon(Icons.auto_awesome_rounded, size: 80, color: AppColors.starGold),
                            const SizedBox(height: 8),
                            const Text(
                              'Brilliant Barka!\nAll Matched! 🎉',
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
                                'Done! 🌟',
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

  Widget _buildSymbolCard(String symbol, {bool isDragging = false, bool isMatched = false}) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: isMatched ? AppColors.grassGreen : AppColors.sunOrange,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0x22000000),
            blurRadius: isDragging ? 16 : 8,
            offset: Offset(0, isDragging ? 8 : 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        symbol,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

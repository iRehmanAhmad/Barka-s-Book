import 'package:flutter/material.dart';
import '../../data/models/book_manifest.dart';
import '../../../../core/audio/audio_controller.dart';
import '../../../../core/audio/sound_effects.dart';
import '../../../../core/localization/rtl_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/bouncy_button.dart';
import '../widgets/animated_hotspot.dart';
import '../widgets/word_speech_badge.dart';
import '../widgets/page_turner.dart';

class BookReaderScreen extends StatefulWidget {
  final BookManifest manifest;
  final AudioController audioController;
  final Function(BuildContext, dynamic)? onOpenMiniGame;

  const BookReaderScreen({
    super.key,
    required this.manifest,
    required this.audioController,
    this.onOpenMiniGame,
  });

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _playCurrentPagePhonics();
  }

  void _playCurrentPagePhonics() {
    if (widget.manifest.pages.isEmpty) return;
    final page = widget.manifest.pages[_currentIndex];
    if (page.phonicsSound != null) {
      widget.audioController.speakPhonics(page.phonicsSound!);
    }
  }

  void _nextPage() {
    if (_currentIndex < widget.manifest.pages.length - 1) {
      setState(() {
        _currentIndex++;
      });
      widget.audioController.playSfx(SoundEffects.pageFlip);
      _playCurrentPagePhonics();
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      widget.audioController.playSfx(SoundEffects.pageFlip);
      _playCurrentPagePhonics();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.manifest.pages.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No pages found in this book!')),
      );
    }

    final currentPage = widget.manifest.pages[_currentIndex];
    final isUrdu = widget.manifest.isRtl;

    return Directionality(
      textDirection: RtlHelper.getDirection(widget.manifest.isRtl),
      child: Scaffold(
        backgroundColor: AppColors.softBackground,
        body: SafeArea(
          child: Column(
            children: [
              // Top AppBar
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
                      child: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          widget.manifest.title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isUrdu ? 22 : 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepNavy,
                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                          ),
                        ),
                      ),
                    ),
                    if (currentPage.miniGame != null)
                      BouncyButton(
                        onPressed: () {
                          widget.audioController.playSfx(SoundEffects.pop);
                          widget.onOpenMiniGame?.call(context, currentPage.miniGame);
                        },
                        backgroundColor: AppColors.starGold,
                        minWidth: 52,
                        minHeight: 52,
                        borderRadius: BorderRadius.circular(26),
                        child: const Icon(Icons.extension_rounded, color: AppColors.deepNavy, size: 28),
                      ),
                  ],
                ),
              ),

              // Hero Lesson Page Body
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),

                        // Big Letter / Number Hero Display
                        if (currentPage.letter != null)
                          GestureDetector(
                            onTap: _playCurrentPagePhonics,
                            child: Text(
                              currentPage.letter!,
                              style: isUrdu
                                  ? AppTextStyles.urduHeadline
                                  : AppTextStyles.englishAlphabetHero,
                            ),
                          )
                        else if (currentPage.number != null)
                          GestureDetector(
                            onTap: _playCurrentPagePhonics,
                            child: Text(
                              '${currentPage.number}',
                              style: AppTextStyles.mathNumberHero,
                            ),
                          ),

                        if (currentPage.phonicsDescription != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              currentPage.phonicsDescription!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                        const SizedBox(height: 16),

                        // Interactive Living Book Hotspot
                        AnimatedHotspot(
                          item: currentPage.mainIllustration,
                          onTap: () {
                            if (currentPage.mainIllustration.interactiveSfx != null) {
                              widget.audioController.playSfx(currentPage.mainIllustration.interactiveSfx!);
                            } else {
                              widget.audioController.playSfx(SoundEffects.pop);
                            }
                          },
                        ),

                        const SizedBox(height: 24),

                        // Vocabulary Badges
                        if (currentPage.vocabularyWords.isNotEmpty)
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: currentPage.vocabularyWords.map((word) {
                              return WordSpeechBadge(
                                word: word,
                                isUrdu: isUrdu,
                                onTap: () {
                                  widget.audioController.speakWord(word.audio);
                                },
                              );
                            }).toList(),
                          ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),

              // Page Turner Bottom Navigation
              PageTurner(
                currentPage: _currentIndex + 1,
                totalPages: widget.manifest.pages.length,
                onPrevious: _previousPage,
                onNext: _nextPage,
                isRtl: widget.manifest.isRtl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:barka_book/features/book_engine/data/models/book_manifest.dart';
import 'package:barka_book/features/book_engine/data/models/mini_game_config.dart';
import 'package:barka_book/features/book_engine/data/repositories/book_repository.dart';
import 'package:barka_book/features/book_engine/presentation/screens/book_reader_screen.dart';
import 'package:barka_book/features/games/balloon_pop/presentation/screens/balloon_pop_screen.dart';
import 'package:barka_book/features/games/matching/presentation/screens/matching_game_screen.dart';
import 'package:barka_book/features/games/tracing/presentation/screens/tracing_screen.dart';
import 'package:barka_book/features/rewards/presentation/screens/sticker_album_screen.dart';
import 'package:barka_book/core/audio/audio_controller.dart';
import 'package:barka_book/core/audio/sound_effects.dart';
import 'package:barka_book/core/storage/progress_repository.dart';
import 'package:barka_book/core/theme/app_colors.dart';
import 'package:barka_book/core/widgets/bouncy_button.dart';
import 'package:barka_book/features/home/presentation/widgets/subject_card.dart';

class HomeScreen extends StatelessWidget {
  final BookRepository bookRepository;
  final AudioController audioController;
  final ProgressRepository progressRepository;

  const HomeScreen({
    super.key,
    required this.bookRepository,
    required this.audioController,
    required this.progressRepository,
  });

  void _openBook(BuildContext context, Future<BookManifest> Function() loader) async {
    audioController.playSfx(SoundEffects.pop);
    try {
      final manifest = await loader();
      if (!context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookReaderScreen(
            manifest: manifest,
            audioController: audioController,
            onOpenMiniGame: (ctx, config) => _openMiniGame(ctx, config),
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open book: $e')),
      );
    }
  }

  void _openMiniGame(BuildContext context, MiniGameConfig config) {
    if (config.type == 'tracing') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TracingScreen(
            config: config,
            audioController: audioController,
            onComplete: () => progressRepository.addStars(1),
          ),
        ),
      );
    } else if (config.type == 'matching' && config.pairs != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MatchingGameScreen(
            pairs: config.pairs!,
            audioController: audioController,
            onComplete: () => progressRepository.addStars(1),
          ),
        ),
      );
    } else if (config.type == 'balloon_pop' && config.correctSymbol != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BalloonPopScreen(
            targetSound: config.targetSound ?? '',
            correctSymbol: config.correctSymbol!,
            distractorSymbols: config.distractorSymbols ?? [],
            audioController: audioController,
            onComplete: () => progressRepository.addStars(1),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Greeting with Barka's Real Avatar
                  Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFFF5D8F), width: 3),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33FF5D8F),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/barka_avatar.png',
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Container(
                              color: AppColors.starGold,
                              alignment: Alignment.center,
                              child: const Text('👧', style: TextStyle(fontSize: 30)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Barka Faral 👧',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                              color: AppColors.deepNavy,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '🍭 Playgroup Candy Star ⭐',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFF5D8F),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Toy Box & Mute Buttons
                  Row(
                    children: [
                      BouncyButton(
                        onPressed: () {
                          audioController.playSfx(SoundEffects.starChime);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StickerAlbumScreen(
                                repository: progressRepository,
                                audioController: audioController,
                              ),
                            ),
                          );
                        },
                        backgroundColor: AppColors.starGold,
                        minWidth: 48,
                        minHeight: 48,
                        borderRadius: BorderRadius.circular(24),
                        padding: EdgeInsets.zero,
                        child: const Icon(Icons.card_giftcard_rounded, color: AppColors.deepNavy, size: 24),
                      ),
                      const SizedBox(width: 8),
                      BouncyButton(
                        onPressed: () => audioController.toggleMute(),
                        backgroundColor: Colors.white,
                        minWidth: 48,
                        minHeight: 48,
                        borderRadius: BorderRadius.circular(24),
                        padding: EdgeInsets.zero,
                        child: Icon(
                          audioController.isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                          color: AppColors.deepNavy,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Candy Land Panoramic Banner
              ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: Container(
                  height: 125,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/candy_banner.png',
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF9A8B), Color(0xFFFF6A88), Color(0xFFFF99AC)],
                            ),
                          ),
                        ),
                      ),
                      // Soft gradient overlay for readable text
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.55),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      const Positioned(
                        bottom: 12,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Barka's Book Shelf 📚",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black45,
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "Tap a book to listen, play, and win stickers!",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Bookshelf Cards with Real Illustrations
              Expanded(
                child: ListView(
                  children: [
                    SubjectCard(
                      title: 'English Phonics',
                      subtitle: 'Alphabet A-Z, Phonics & Words',
                      heroLetters: 'A B C',
                      icon: Icons.menu_book_rounded,
                      imageAsset: 'assets/images/apple.png',
                      gradientColors: const [Color(0xFF38B6FF), Color(0xFF7B2CBF)],
                      onTap: () => _openBook(context, bookRepository.loadEnglishNursery),
                    ),
                    const SizedBox(height: 14),
                    SubjectCard(
                      title: 'اردو قاعدہ',
                      subtitle: 'حروفِ تہجی اور بنیادی الفاظ',
                      heroLetters: 'ا ب پ',
                      icon: Icons.auto_stories_rounded,
                      imageAsset: 'assets/images/anaar.png',
                      isUrdu: true,
                      gradientColors: const [Color(0xFFFF006E), Color(0xFFFF8C42)],
                      onTap: () => _openBook(context, bookRepository.loadUrduNursery),
                    ),
                    const SizedBox(height: 14),
                    SubjectCard(
                      title: 'Fun Maths & Numbers',
                      subtitle: 'Counting 1-10, Shapes & Colors',
                      heroLetters: '1 2 3',
                      icon: Icons.calculate_rounded,
                      imageAsset: 'assets/images/sun.png',
                      gradientColors: const [Color(0xFF06D6A0), Color(0xFF0077B6)],
                      onTap: () => _openBook(context, bookRepository.loadMathsNursery),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

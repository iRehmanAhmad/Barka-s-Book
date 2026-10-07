import 'package:flutter/material.dart';
import 'package:barka_book/core/audio/audio_controller.dart';
import 'package:barka_book/core/audio/sound_effects.dart';
import 'package:barka_book/core/storage/progress_repository.dart';
import 'package:barka_book/core/theme/app_colors.dart';
import 'package:barka_book/core/widgets/bouncy_button.dart';

class StickerAlbumScreen extends StatefulWidget {
  final ProgressRepository repository;
  final AudioController audioController;
  final VoidCallback? onWatchRewardedAdBonus;

  const StickerAlbumScreen({
    super.key,
    required this.repository,
    required this.audioController,
    this.onWatchRewardedAdBonus,
  });

  @override
  State<StickerAlbumScreen> createState() => _StickerAlbumScreenState();
}

class _StickerAlbumScreenState extends State<StickerAlbumScreen> {
  @override
  Widget build(BuildContext context) {
    final stickers = widget.repository.getStickers();
    final totalStars = widget.repository.totalStars;

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
                  const Text(
                    "Barka's Toy Box 🧸",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepNavy,
                    ),
                  ),
                  // Stars Counter Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.starGold,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1F000000),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.deepNavy, size: 24),
                        const SizedBox(width: 4),
                        Text(
                          '$totalStars',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepNavy,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Kid-safe Rewarded Video Bonus Card (Families-Compliant Monetization)
            if (widget.onWatchRewardedAdBonus != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFB703), Color(0xFFFB8500)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 40),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Watch a quick video to unlock a surprise golden sticker! 🎁',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      BouncyButton(
                        onPressed: () {
                          widget.audioController.playSfx(SoundEffects.pop);
                          widget.onWatchRewardedAdBonus!();
                        },
                        backgroundColor: Colors.white,
                        minWidth: 80,
                        minHeight: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        child: const Text(
                          'Watch ▶',
                          style: TextStyle(
                            color: AppColors.sunOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Grid of Stickers
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.95,
                ),
                itemCount: stickers.length,
                itemBuilder: (context, index) {
                  final sticker = stickers[index];

                  return BouncyButton(
                    onPressed: () {
                      if (sticker.isUnlocked) {
                        widget.audioController.playSfx(SoundEffects.starChime);
                      } else {
                        widget.audioController.playSfx(SoundEffects.boing);
                      }
                    },
                    backgroundColor: sticker.isUnlocked ? Colors.white : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (sticker.isUnlocked) ...[
                          Icon(sticker.icon, size: 64, color: sticker.color),
                          const SizedBox(height: 10),
                          Text(
                            sticker.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.deepNavy,
                            ),
                          ),
                          Text(
                            sticker.urduName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B7280),
                              fontFamily: 'NotoNastaliqUrdu',
                            ),
                          ),
                        ] else ...[
                          Icon(Icons.lock_rounded, size: 52, color: Colors.grey.shade400),
                          const SizedBox(height: 10),
                          Text(
                            'Needs ⭐ ${sticker.starsRequired}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../features/rewards/data/models/sticker_item.dart';

class ProgressRepository {
  int _totalStars = 0;
  final Set<String> _completedLessons = {};
  final Set<String> _unlockedStickerIds = {};

  static final List<StickerItem> defaultStickers = [
    const StickerItem(
      id: 'sticker_gold_star',
      name: 'Golden Star',
      urduName: 'سنہرا ستارہ',
      icon: Icons.star_rounded,
      color: Color(0xFFFFD166),
      starsRequired: 0,
      isUnlocked: true,
    ),
    const StickerItem(
      id: 'sticker_teddy_bear',
      name: 'Cute Teddy',
      urduName: 'بھالو',
      icon: Icons.pets_rounded,
      color: Color(0xFFFB8500),
      starsRequired: 2,
    ),
    const StickerItem(
      id: 'sticker_butterfly',
      name: 'Colorful Butterfly',
      urduName: 'تتلی',
      icon: Icons.filter_vintage_rounded,
      color: Color(0xFFFF006E),
      starsRequired: 4,
    ),
    const StickerItem(
      id: 'sticker_rocket',
      name: 'Space Rocket',
      urduName: 'راکٹ',
      icon: Icons.rocket_launch_rounded,
      color: Color(0xFF2196F3),
      starsRequired: 6,
    ),
    const StickerItem(
      id: 'sticker_apple',
      name: 'Shiny Apple',
      urduName: 'سیب',
      icon: Icons.apple_rounded,
      color: Color(0xFFE63946),
      starsRequired: 8,
    ),
    const StickerItem(
      id: 'sticker_crown',
      name: 'Golden Crown',
      urduName: 'تاج',
      icon: Icons.military_tech_rounded,
      color: Color(0xFFFFB703),
      starsRequired: 10,
    ),
  ];

  int get totalStars => _totalStars;

  Set<String> get completedLessons => Set.unmodifiable(_completedLessons);

  Future<void> addStars(int count) async {
    _totalStars += count;
    _checkAutomaticStickerUnlocks();
  }

  Future<void> markLessonCompleted(String bookId, int pageNumber) async {
    final key = '${bookId}_$pageNumber';
    if (!_completedLessons.contains(key)) {
      _completedLessons.add(key);
      await addStars(1);
    }
  }

  void _checkAutomaticStickerUnlocks() {
    for (final sticker in defaultStickers) {
      if (_totalStars >= sticker.starsRequired) {
        _unlockedStickerIds.add(sticker.id);
      }
    }
  }

  List<StickerItem> getStickers() {
    _checkAutomaticStickerUnlocks();
    return defaultStickers.map((sticker) {
      final isUnlocked = sticker.isUnlocked ||
          _unlockedStickerIds.contains(sticker.id) ||
          _totalStars >= sticker.starsRequired;
      return sticker.copyWith(isUnlocked: isUnlocked);
    }).toList();
  }

  Future<void> unlockBonusSticker(String stickerId) async {
    _unlockedStickerIds.add(stickerId);
  }
}

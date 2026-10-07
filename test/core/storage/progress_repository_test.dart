import 'package:flutter_test/flutter_test.dart';
import 'package:barka_book/core/storage/progress_repository.dart';

void main() {
  group('ProgressRepository Unit Tests', () {
    late ProgressRepository repository;

    setUp(() {
      repository = ProgressRepository();
    });

    test('Initial state starts with 0 stars and 1 default unlocked sticker', () {
      expect(repository.totalStars, 0);
      final stickers = repository.getStickers();
      expect(stickers.first.isUnlocked, isTrue); // Golden star is default unlocked
      expect(stickers[1].isUnlocked, isFalse); // Teddy requires 2 stars
    });

    test('Earning stars automatically unlocks eligible stickers', () async {
      await repository.addStars(4);

      expect(repository.totalStars, 4);
      final stickers = repository.getStickers();
      // Teddy requires 2, Butterfly requires 4 -> both should be unlocked
      expect(stickers.firstWhere((s) => s.id == 'sticker_teddy_bear').isUnlocked, isTrue);
      expect(stickers.firstWhere((s) => s.id == 'sticker_butterfly').isUnlocked, isTrue);
      // Rocket requires 6 -> should remain locked
      expect(stickers.firstWhere((s) => s.id == 'sticker_rocket').isUnlocked, isFalse);
    });

    test('markLessonCompleted awards stars and prevents duplicate awards', () async {
      await repository.markLessonCompleted('barka_nursery_english', 1);
      expect(repository.totalStars, 1);
      expect(repository.completedLessons.contains('barka_nursery_english_1'), isTrue);

      // Re-completing same lesson should not double award
      await repository.markLessonCompleted('barka_nursery_english', 1);
      expect(repository.totalStars, 1);
    });

    test('unlockBonusSticker directly unlocks a sticker', () async {
      await repository.unlockBonusSticker('sticker_crown');
      final stickers = repository.getStickers();
      expect(stickers.firstWhere((s) => s.id == 'sticker_crown').isUnlocked, isTrue);
    });
  });
}

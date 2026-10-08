import 'package:flutter/material.dart';
import 'package:barka_book/features/book_engine/data/models/vocabulary_word.dart';
import 'package:barka_book/core/widgets/bouncy_button.dart';

class WordSpeechBadge extends StatelessWidget {
  final VocabularyWord word;
  final VoidCallback onTap;
  final bool isUrdu;

  const WordSpeechBadge({
    super.key,
    required this.word,
    required this.onTap,
    this.isUrdu = false,
  });

  static const Map<String, String> _wordEmojis = {
    'Apple': '🍎',
    'Ant': '🐜',
    'Aeroplane': '✈️',
    'Ball': '⚽',
    'Boy': '👦',
    'Butterfly': '🦋',
    'Cat': '🐱',
    'Car': '🚗',
    'Cup': '☕',
    'انار': '🍎',
    'انگور': '🍇',
    'اونٹ': '🐪',
    'بلی': '🐱',
    'بطخ': '🦆',
    'بستہ': '🎒',
    'پنکھا': '🪭',
    'پتنگ': '🪁',
    'پودا': '🌱',
    'One Shining Sun!': '☀️',
    'Two Flying Birds!': '🐦',
    'Three Red Apples!': '🍎',
  };

  @override
  Widget build(BuildContext context) {
    Color badgeColor = const Color(0xFFFF5D8F);
    if (word.color != null && word.color!.isNotEmpty) {
      try {
        final hexString = word.color!.replaceAll('#', '');
        badgeColor = Color(int.parse('FF$hexString', radix: 16));
      } catch (_) {}
    }

    final emoji = _wordEmojis[word.word] ?? '🍬';

    return BouncyButton(
      onPressed: onTap,
      backgroundColor: badgeColor,
      borderRadius: BorderRadius.circular(32),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      minHeight: 60,
      minWidth: 120,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Emoji circle badge
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            word.word,
            style: TextStyle(
              fontSize: isUrdu ? 26 : 21,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
              shadows: const [
                Shadow(
                  color: Color(0x33000000),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.volume_up_rounded,
            color: Colors.white70,
            size: 20,
          ),
        ],
      ),
    );
  }
}

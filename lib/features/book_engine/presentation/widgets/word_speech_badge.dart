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

  @override
  Widget build(BuildContext context) {
    Color badgeColor = const Color(0xFF2A9D8F);
    if (word.color != null && word.color!.isNotEmpty) {
      try {
        final hexString = word.color!.replaceAll('#', '');
        badgeColor = Color(int.parse('FF$hexString', radix: 16));
      } catch (_) {}
    }

    return BouncyButton(
      onPressed: onTap,
      backgroundColor: badgeColor,
      borderRadius: BorderRadius.circular(30),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      minHeight: 56,
      minWidth: 100,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.volume_up_rounded, color: Colors.white, size: 26),
          const SizedBox(width: 10),
          Text(
            word.word,
            style: TextStyle(
              fontSize: isUrdu ? 24 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
            ),
          ),
        ],
      ),
    );
  }
}

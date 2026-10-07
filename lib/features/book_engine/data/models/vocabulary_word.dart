class VocabularyWord {
  final String word;
  final String audio;
  final String? color;

  const VocabularyWord({
    required this.word,
    required this.audio,
    this.color,
  });

  factory VocabularyWord.fromJson(Map<String, dynamic> json) {
    return VocabularyWord(
      word: json['word'] as String? ?? '',
      audio: json['audio'] as String? ?? '',
      color: json['color'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'audio': audio,
      'color': color,
    };
  }
}

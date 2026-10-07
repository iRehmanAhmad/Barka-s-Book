import 'hotspot_item.dart';
import 'vocabulary_word.dart';
import 'mini_game_config.dart';

class BookPage {
  final int pageNumber;
  final String? letter;
  final int? number;
  final String? numberWord;
  final String? urduNumberWord;
  final String? phonicsSound;
  final String? phonicsDescription;
  final HotspotItem mainIllustration;
  final List<VocabularyWord> vocabularyWords;
  final List<Map<String, dynamic>> countingItems;
  final MiniGameConfig? miniGame;

  const BookPage({
    required this.pageNumber,
    this.letter,
    this.number,
    this.numberWord,
    this.urduNumberWord,
    this.phonicsSound,
    this.phonicsDescription,
    required this.mainIllustration,
    this.vocabularyWords = const [],
    this.countingItems = const [],
    this.miniGame,
  });

  factory BookPage.fromJson(Map<String, dynamic> json) {
    var words = <VocabularyWord>[];
    if (json['vocabularyWords'] != null) {
      words = (json['vocabularyWords'] as List)
          .map((w) => VocabularyWord.fromJson(w as Map<String, dynamic>))
          .toList();
    }

    var counting = <Map<String, dynamic>>[];
    if (json['countingItems'] != null) {
      counting = (json['countingItems'] as List)
          .map((c) => Map<String, dynamic>.from(c as Map))
          .toList();
    }

    return BookPage(
      pageNumber: json['pageNumber'] as int? ?? 1,
      letter: json['letter'] as String?,
      number: json['number'] as int?,
      numberWord: json['numberWord'] as String?,
      urduNumberWord: json['urduNumberWord'] as String?,
      phonicsSound: json['phonicsSound'] as String?,
      phonicsDescription: json['phonicsDescription'] as String?,
      mainIllustration: json['mainIllustration'] != null
          ? HotspotItem.fromJson(json['mainIllustration'] as Map<String, dynamic>)
          : const HotspotItem(assetPath: '', type: 'image'),
      vocabularyWords: words,
      countingItems: counting,
      miniGame: json['miniGame'] != null
          ? MiniGameConfig.fromJson(json['miniGame'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageNumber': pageNumber,
      'letter': letter,
      'number': number,
      'numberWord': numberWord,
      'urduNumberWord': urduNumberWord,
      'phonicsSound': phonicsSound,
      'phonicsDescription': phonicsDescription,
      'mainIllustration': mainIllustration.toJson(),
      'vocabularyWords': vocabularyWords.map((w) => w.toJson()).toList(),
      'countingItems': countingItems,
      'miniGame': miniGame?.toJson(),
    };
  }
}

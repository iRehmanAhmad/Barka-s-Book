import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barka_book/features/book_engine/data/models/book_manifest.dart';
import 'package:barka_book/features/book_engine/data/models/book_page.dart';
import 'package:barka_book/features/book_engine/data/repositories/book_repository.dart';

class MockAssetBundle extends CachingAssetBundle {
  final Map<String, String> assets;

  MockAssetBundle(this.assets);

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (assets.containsKey(key)) {
      return assets[key]!;
    }
    throw FlutterError('Unable to load asset: $key');
  }

  @override
  Future<ByteData> load(String key) async {
    final string = await loadString(key);
    final bytes = utf8.encode(string);
    return ByteData.sublistView(Uint8List.fromList(bytes));
  }
}

void main() {
  group('BookManifest & Model Unit Tests', () {
    test('Correctly parses English nursery manifest with mini-game', () {
      final jsonMap = {
        'bookId': 'barka_nursery_english',
        'title': "Barka's English Phonics",
        'subject': 'english',
        'grade': 'nursery',
        'isRtl': false,
        'pages': [
          {
            'pageNumber': 1,
            'letter': 'A',
            'phonicsSound': 'audio/english/phonics/a.ogg',
            'phonicsDescription': '/æ/ as in Apple',
            'mainIllustration': {
              'assetPath': 'assets/animations/apple.json',
              'type': 'lottie',
              'interactiveSfx': 'audio/sfx/apple_crunch.ogg',
              'motionTrigger': 'tap_wobble_and_bounce'
            },
            'vocabularyWords': [
              {
                'word': 'Apple',
                'audio': 'audio/english/words/apple.ogg',
                'color': '#FF4B4B'
              }
            ],
            'miniGame': {
              'type': 'tracing',
              'targetSymbol': 'A',
              'guidePoints': [
                {'x': 0.5, 'y': 0.2},
                {'x': 0.2, 'y': 0.8}
              ]
            }
          }
        ]
      };

      final manifest = BookManifest.fromJson(jsonMap);

      expect(manifest.bookId, 'barka_nursery_english');
      expect(manifest.isRtl, false);
      expect(manifest.pages.length, 1);

      final page = manifest.pages.first;
      expect(page.letter, 'A');
      expect(page.phonicsSound, 'audio/english/phonics/a.ogg');
      expect(page.mainIllustration.type, 'lottie');
      expect(page.vocabularyWords.length, 1);
      expect(page.vocabularyWords.first.word, 'Apple');
      expect(page.miniGame?.type, 'tracing');
      expect(page.miniGame?.guidePoints?.length, 2);
      expect(page.miniGame?.guidePoints?.first.x, 0.5);
    });

    test('Correctly parses Urdu Qayda manifest with RTL flag', () {
      final jsonMap = {
        'bookId': 'barka_nursery_urdu',
        'title': 'بارکہ کا اردو قاعدہ',
        'subject': 'urdu',
        'grade': 'nursery',
        'isRtl': true,
        'pages': [
          {
            'pageNumber': 1,
            'letter': 'ا',
            'phonicsSound': 'audio/urdu/phonics/alif.ogg',
            'phonicsDescription': 'الف',
            'mainIllustration': {
              'assetPath': 'assets/animations/pomegranate.json',
              'type': 'lottie'
            },
            'vocabularyWords': [
              {
                'word': 'انار',
                'audio': 'audio/urdu/words/anaar.ogg'
              }
            ]
          }
        ]
      };

      final manifest = BookManifest.fromJson(jsonMap);

      expect(manifest.isRtl, true);
      expect(manifest.title, 'بارکہ کا اردو قاعدہ');
      expect(manifest.pages.first.letter, 'ا');
      expect(manifest.pages.first.vocabularyWords.first.word, 'انار');
    });

    test('BookRepository loads and parses manifests via MockAssetBundle', () async {
      final mockData = json.encode({
        'bookId': 'test_book',
        'title': 'Test Book',
        'subject': 'maths',
        'grade': 'nursery',
        'isRtl': false,
        'pages': []
      });

      final mockBundle = MockAssetBundle({
        'assets/test.json': mockData,
      });

      final repo = BookRepository(assetBundle: mockBundle);
      final manifest = await repo.loadManifest('assets/test.json');

      expect(manifest.bookId, 'test_book');
      expect(manifest.subject, 'maths');
      expect(manifest.pages, isEmpty);
    });
  });
}

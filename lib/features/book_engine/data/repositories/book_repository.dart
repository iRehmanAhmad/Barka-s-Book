import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/book_manifest.dart';

class BookRepository {
  final AssetBundle _assetBundle;

  BookRepository({AssetBundle? assetBundle})
      : _assetBundle = assetBundle ?? rootBundle;

  Future<BookManifest> loadManifest(String assetPath) async {
    try {
      final jsonString = await _assetBundle.loadString(assetPath);
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return BookManifest.fromJson(jsonMap);
    } catch (e) {
      throw FormatException('Failed to load or parse book manifest from $assetPath: $e');
    }
  }

  Future<BookManifest> loadEnglishNursery() {
    return loadManifest('assets/books/barka_nursery/english_manifest.json');
  }

  Future<BookManifest> loadUrduNursery() {
    return loadManifest('assets/books/barka_nursery/urdu_manifest.json');
  }

  Future<BookManifest> loadMathsNursery() {
    return loadManifest('assets/books/barka_nursery/maths_manifest.json');
  }
}

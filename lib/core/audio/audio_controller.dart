import 'package:flutter/foundation.dart';

abstract class AudioPlayerClient {
  Future<void> playAsset(String assetPath, {double volume = 1.0});
  Future<void> stop();
}

class NoOpAudioPlayerClient implements AudioPlayerClient {
  @override
  Future<void> playAsset(String assetPath, {double volume = 1.0}) async {}

  @override
  Future<void> stop() async {}
}

class AudioController extends ChangeNotifier {
  final AudioPlayerClient _sfxClient;
  final AudioPlayerClient _voiceClient;
  final AudioPlayerClient _bgmClient;

  bool _isMuted = false;
  bool _isBgmEnabled = true;

  AudioController({
    AudioPlayerClient? sfxClient,
    AudioPlayerClient? voiceClient,
    AudioPlayerClient? bgmClient,
  })  : _sfxClient = sfxClient ?? NoOpAudioPlayerClient(),
        _voiceClient = voiceClient ?? NoOpAudioPlayerClient(),
        _bgmClient = bgmClient ?? NoOpAudioPlayerClient();

  bool get isMuted => _isMuted;
  bool get isBgmEnabled => _isBgmEnabled;

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      stopAll();
    }
    notifyListeners();
  }

  void toggleBgm() {
    _isBgmEnabled = !_isBgmEnabled;
    if (!_isBgmEnabled) {
      _bgmClient.stop();
    }
    notifyListeners();
  }

  Future<void> playSfx(String assetPath, {double volume = 1.0}) async {
    if (_isMuted) return;
    try {
      await _sfxClient.playAsset(assetPath, volume: volume);
    } catch (e) {
      debugPrint('Error playing SFX $assetPath: $e');
    }
  }

  Future<void> speakPhonics(String assetPath, {double volume = 1.0}) async {
    if (_isMuted) return;
    try {
      await _voiceClient.stop();
      await _voiceClient.playAsset(assetPath, volume: volume);
    } catch (e) {
      debugPrint('Error speaking phonics $assetPath: $e');
    }
  }

  Future<void> speakWord(String assetPath, {double volume = 1.0}) async {
    if (_isMuted) return;
    try {
      await _voiceClient.stop();
      await _voiceClient.playAsset(assetPath, volume: volume);
    } catch (e) {
      debugPrint('Error speaking word $assetPath: $e');
    }
  }

  Future<void> stopAll() async {
    try {
      await Future.wait([
        _sfxClient.stop(),
        _voiceClient.stop(),
        _bgmClient.stop(),
      ]);
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
  }
}

import 'package:audioplayers/audioplayers.dart';
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

class FlutterAudioPlayerClient implements AudioPlayerClient {
  final AudioPlayer _player;

  FlutterAudioPlayerClient({AudioPlayer? player}) : _player = player ?? AudioPlayer();

  @override
  Future<void> playAsset(String assetPath, {double volume = 1.0}) async {
    try {
      var cleanPath = assetPath.startsWith('assets/')
          ? assetPath.substring(7)
          : assetPath;
      await _player.stop();
      await _player.setVolume(volume);
      try {
        await _player.play(AssetSource(cleanPath));
      } catch (e) {
        // Fallback: if .ogg failed, try .mp3; if .mp3 failed, try .ogg
        if (cleanPath.endsWith('.ogg')) {
          final mp3Path = cleanPath.replaceAll(RegExp(r'\.ogg$'), '.mp3');
          await _player.play(AssetSource(mp3Path));
        } else if (cleanPath.endsWith('.mp3')) {
          final oggPath = cleanPath.replaceAll(RegExp(r'\.mp3$'), '.ogg');
          await _player.play(AssetSource(oggPath));
        } else {
          rethrow;
        }
      }
    } catch (e) {
      debugPrint('FlutterAudioPlayerClient error playing $assetPath: $e');
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (e) {
      debugPrint('FlutterAudioPlayerClient error stopping: $e');
    }
  }
}

class AudioController extends ChangeNotifier {
  final AudioPlayerClient _sfxClient;
  final AudioPlayerClient _voiceClient;
  final AudioPlayerClient _bgmClient;

  bool _isMuted = false;
  bool _isBgmEnabled = true;

  /// Production factory that initializes real hardware audio players
  factory AudioController.live() {
    return AudioController(
      sfxClient: FlutterAudioPlayerClient(),
      voiceClient: FlutterAudioPlayerClient(),
      bgmClient: FlutterAudioPlayerClient(),
    );
  }

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

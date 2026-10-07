import 'package:flutter_test/flutter_test.dart';
import 'package:barka_book/core/audio/audio_controller.dart';
import 'package:barka_book/core/audio/sound_effects.dart';

class MockAudioClient implements AudioPlayerClient {
  final List<String> playedAssets = [];
  int stopCallCount = 0;

  @override
  Future<void> playAsset(String assetPath, {double volume = 1.0}) async {
    playedAssets.add(assetPath);
  }

  @override
  Future<void> stop() async {
    stopCallCount++;
  }
}

void main() {
  group('AudioController Unit Tests', () {
    late MockAudioClient sfxClient;
    late MockAudioClient voiceClient;
    late MockAudioClient bgmClient;
    late AudioController controller;

    setUp(() {
      sfxClient = MockAudioClient();
      voiceClient = MockAudioClient();
      bgmClient = MockAudioClient();
      controller = AudioController(
        sfxClient: sfxClient,
        voiceClient: voiceClient,
        bgmClient: bgmClient,
      );
    });

    test('playSfx routes sound to sfx client without interrupting voice', () async {
      await controller.playSfx(SoundEffects.pop);

      expect(sfxClient.playedAssets, contains(SoundEffects.pop));
      expect(voiceClient.playedAssets, isEmpty);
      expect(sfxClient.stopCallCount, 0);
    });

    test('speakPhonics stops previous voice and plays new audio', () async {
      await controller.speakPhonics('audio/english/phonics/a.ogg');

      expect(voiceClient.stopCallCount, 1);
      expect(voiceClient.playedAssets, contains('audio/english/phonics/a.ogg'));
      expect(sfxClient.playedAssets, isEmpty);
    });

    test('Muting prevents audio playback and stops active channels', () async {
      controller.toggleMute();
      expect(controller.isMuted, true);

      await controller.playSfx(SoundEffects.cheer);
      await controller.speakPhonics('audio/urdu/phonics/alif.ogg');

      expect(sfxClient.playedAssets, isEmpty);
      expect(voiceClient.playedAssets, isEmpty);
    });

    test('stopAll terminates all three audio channels', () async {
      await controller.stopAll();

      expect(sfxClient.stopCallCount, 1);
      expect(voiceClient.stopCallCount, 1);
      expect(bgmClient.stopCallCount, 1);
    });
  });
}

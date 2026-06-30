import 'package:flutter_test/flutter_test.dart';
import 'package:somni_script_app/core/services/audio/audio_service.dart';

void main() {
  group('AudioPlayerState', () {
    test('default state values', () {
      const state = AudioPlayerState();

      expect(state.status, PlayerStatus.idle);
      expect(state.position, Duration.zero);
      expect(state.duration, Duration.zero);
      expect(state.remainingSeconds, 0);
      expect(state.voiceVolume, 0.8);
      expect(state.whiteNoiseVolume, 0.0);
      expect(state.oceanVolume, 0.0);
      expect(state.rainVolume, 0.0);
      expect(state.lofiVolume, 0.0);
      expect(state.sleepTimerMinutes, 30);
      expect(state.currentTitle, '');
    });

    test('copyWith updates only specified fields', () {
      const base = AudioPlayerState(
        status: PlayerStatus.playing,
        currentTitle: 'Test',
      );

      final updated = base.copyWith(voiceVolume: 0.5);

      expect(updated.status, PlayerStatus.playing); // unchanged
      expect(updated.currentTitle, 'Test'); // unchanged
      expect(updated.voiceVolume, 0.5); // updated
      expect(updated.whiteNoiseVolume, 0.0); // unchanged default
    });

    test('copyWith status transition', () {
      const idle = AudioPlayerState();
      final playing = idle.copyWith(status: PlayerStatus.playing);

      expect(playing.status, PlayerStatus.playing);
      expect(playing.voiceVolume, 0.8); // preserved default
    });
  });
}

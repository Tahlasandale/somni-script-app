import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Status du lecteur audio.
enum PlayerStatus { idle, playing, paused, fadingOut }

/// État global du service audio (partagé par Riverpod).
class AudioPlayerState {
  final PlayerStatus status;
  final Duration position;
  final Duration duration;
  final int remainingSeconds;
  final double voiceVolume;
  final double whiteNoiseVolume;
  final double oceanVolume;
  final double rainVolume;
  final double lofiVolume;
  final int sleepTimerMinutes;
  final String currentTitle;

  const AudioPlayerState({
    this.status = PlayerStatus.idle,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.remainingSeconds = 0,
    this.voiceVolume = 0.8,
    this.whiteNoiseVolume = 0.0,
    this.oceanVolume = 0.0,
    this.rainVolume = 0.0,
    this.lofiVolume = 0.0,
    this.sleepTimerMinutes = 30,
    this.currentTitle = '',
  });

  AudioPlayerState copyWith({
    PlayerStatus? status,
    Duration? position,
    Duration? duration,
    int? remainingSeconds,
    double? voiceVolume,
    double? whiteNoiseVolume,
    double? oceanVolume,
    double? rainVolume,
    double? lofiVolume,
    int? sleepTimerMinutes,
    String? currentTitle,
  }) {
    return AudioPlayerState(
      status: status ?? this.status,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      voiceVolume: voiceVolume ?? this.voiceVolume,
      whiteNoiseVolume: whiteNoiseVolume ?? this.whiteNoiseVolume,
      oceanVolume: oceanVolume ?? this.oceanVolume,
      rainVolume: rainVolume ?? this.rainVolume,
      lofiVolume: lofiVolume ?? this.lofiVolume,
      sleepTimerMinutes: sleepTimerMinutes ?? this.sleepTimerMinutes,
      currentTitle: currentTitle ?? this.currentTitle,
    );
  }
}

/// Service de lecture audio avec mixage multi-pistes et minuteur.
class AudioService {
  FlutterTts? _tts;
  AudioPlayer? _ambientPlayer;
  Timer? _sleepTimer;
  Timer? _fadeOutTimer;
  Timer? _progressTimer;

  AudioPlayerState _state = const AudioPlayerState();
  AudioPlayerState get state => _state;

  /// Texte complet du script en cours (pour pause/reprise).
  String _fullScriptText = '';
  /// Position caractère dans le texte (pour reprise après pause).
  int _charPosition = 0;

  // Callback notifié à chaque changement d'état
  void Function(AudioPlayerState)? onStateChanged;

  AudioService() {
    _initTts();
  }

  Future<void> _initTts() async {
    _tts = FlutterTts();
    await _tts?.setLanguage('fr-FR');
    await _tts?.setPitch(0.9);
    await _tts?.setSpeechRate(0.45);
    await _tts?.setVolume(_state.voiceVolume);

    // Suivi de progression
    _tts?.setProgressHandler((String text, int start, int end, String word) {
      _charPosition = end;
      final totalChars = _fullScriptText.length;
      final progress = totalChars > 0
          ? Duration(seconds: (end / totalChars * 60).round())
          : Duration.zero;
      _state = _state.copyWith(position: progress);
      _notify();
    });

    // Fin de lecture automatique
    _tts?.setCompletionHandler(() {
      if (_state.status == PlayerStatus.playing) {
        _state = _state.copyWith(status: PlayerStatus.idle, position: Duration.zero);
        _charPosition = 0;
        _notify();
      }
    });
  }

  /// Démarre la lecture d'un script TTS + ambiances.
  Future<void> play({
    required String scriptText,
    String title = '',
  }) async {
    await stop();

    _fullScriptText = scriptText;
    _charPosition = 0;

    _state = _state.copyWith(
      status: PlayerStatus.playing,
      currentTitle: title,
      position: Duration.zero,
      duration: Duration(seconds: (scriptText.length / 15).round()),
    );
    _notify();

    await _speakFrom(0);

    _startProgressTimer();
  }

  /// Parle une portion du texte depuis [start] caractère.
  Future<void> _speakFrom(int start) async {
    if (start >= _fullScriptText.length) return;
    final remaining = _fullScriptText.substring(start);
    await _tts?.setVolume(_state.voiceVolume);
    await _tts?.speak(remaining);
  }

  /// Timer de progression approximative quand TTS ne donne pas de callback.
  void _startProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_state.status == PlayerStatus.playing) {
        final elapsed = _state.position + const Duration(seconds: 1);
        _state = _state.copyWith(position: elapsed);
        _notify();
      }
    });
  }

  /// Met en pause / reprend.
  Future<void> togglePause() async {
    if (_state.status == PlayerStatus.playing) {
      // Stop TTS, garde la position caractère
      await _tts?.stop();
      _state = _state.copyWith(status: PlayerStatus.paused);
      _progressTimer?.cancel();
    } else if (_state.status == PlayerStatus.paused) {
      // Reprend depuis la position sauvegardée
      _state = _state.copyWith(status: PlayerStatus.playing);
      await _speakFrom(_charPosition);
      _startProgressTimer();
    }
    _notify();
  }

  /// Arrête tout.
  Future<void> stop() async {
    _sleepTimer?.cancel();
    _fadeOutTimer?.cancel();
    _progressTimer?.cancel();

    await _tts?.stop();
    await _ambientPlayer?.stop();

    _fullScriptText = '';
    _charPosition = 0;

    _state = _state.copyWith(
      status: PlayerStatus.idle,
      position: Duration.zero,
      remainingSeconds: 0,
    );
    _notify();
  }

  /// Définit le minuteur d'endormissement.
  void setSleepTimer(int minutes) {
    _sleepTimer?.cancel();
    _state = _state.copyWith(sleepTimerMinutes: minutes);
    _notify();

    if (minutes > 0 && _state.status == PlayerStatus.playing) {
      _startFadeOut(minutes);
    }
  }

  void _startFadeOut(int minutes) {
    final fadeDuration = const Duration(seconds: 30);
    final totalMs = (minutes * 60 * 1000) - fadeDuration.inMilliseconds;

    if (totalMs <= 0) return;

    _fadeOutTimer = Timer(Duration(milliseconds: totalMs), () async {
      _state = _state.copyWith(status: PlayerStatus.fadingOut);
      _notify();

      // Fade-out progressif sur 30 secondes
      final steps = 30;
      for (int i = 0; i < steps; i++) {
        final volume = 1.0 - (i / steps);
        await _tts?.setVolume(volume * _state.voiceVolume);
        await _ambientPlayer?.setVolume(volume);
        await Future.delayed(const Duration(seconds: 1));
      }

      await stop();
    });
  }

  /// Met à jour le volume d'une piste.
  void setVolume(String track, double volume) {
    switch (track) {
      case 'voice':
        _state = _state.copyWith(voiceVolume: volume);
        _tts?.setVolume(volume);
        break;
      case 'whiteNoise':
        _state = _state.copyWith(whiteNoiseVolume: volume);
        break;
      case 'ocean':
        _state = _state.copyWith(oceanVolume: volume);
        break;
      case 'rain':
        _state = _state.copyWith(rainVolume: volume);
        break;
      case 'lofi':
        _state = _state.copyWith(lofiVolume: volume);
        break;
    }
    _notify();
  }

  void _notify() {
    onStateChanged?.call(_state);
  }

  /// Libère les ressources.
  void dispose() {
    _sleepTimer?.cancel();
    _fadeOutTimer?.cancel();
    _progressTimer?.cancel();
    _tts?.stop();
    _ambientPlayer?.dispose();
  }
}

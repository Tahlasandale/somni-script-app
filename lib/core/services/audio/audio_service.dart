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

/// Types d'ambiances sonores disponibles.
enum AmbientType { whiteNoise, ocean, rain, lofi }

/// Service de lecture audio avec mixage multi-pistes et minuteur.
///
/// Utilise flutter_tts pour la voix (TTS) et just_audio pour les ambiances
/// sonores. La voix est découpée en chunks de max 3000 car. pour éviter
/// les coupures Android.
class AudioService {
  // ── TTS ────────────────────────────────────────────────────────────────
  FlutterTts? _tts;
  bool _ttsReady = false;

  /// Texte complet du script en cours (pour pause/reprise).
  String _fullScriptText = '';

  /// Position caractère absolue dans le texte complet.
  int _charPosition = 0;

  /// Chunks du texte découpé (max 3000 car. chacun).
  List<String> _chunks = [];

  /// Index du chunk en cours de lecture.
  int _currentChunkIndex = 0;

  /// Position de départ absolue de chaque chunk dans _fullScriptText.
  List<int> _chunkStartIndices = [];

  // ── Ambiance ───────────────────────────────────────────────────────────
  AudioPlayer? _ambientPlayer;
  AmbientType? _currentAmbient;

  /// URLs CDN libres de droit (SoundHelix) — à remplacer par de vraies
  /// ambiances plus tard.
  static const Map<AmbientType, String> _ambientUrls = {
    AmbientType.whiteNoise:
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    AmbientType.ocean:
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    AmbientType.rain:
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
    AmbientType.lofi:
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-16.mp3',
  };

  // ── Timers ─────────────────────────────────────────────────────────────
  Timer? _sleepTimer;
  Timer? _fadeOutTimer;
  Timer? _progressTimer;

  // ── État ───────────────────────────────────────────────────────────────
  AudioPlayerState _state = const AudioPlayerState();
  AudioPlayerState get state => _state;

  // Callback notifié à chaque changement d'état
  void Function(AudioPlayerState)? onStateChanged;

  // ── Constructeur ───────────────────────────────────────────────────────
  AudioService() {
    _ambientPlayer = AudioPlayer();
    _initTts(); // fire & forget — la vérification se fait dans chaque méthode
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  TTS — Initialisation
  // ═══════════════════════════════════════════════════════════════════════

  Future<void> _initTts() async {
    try {
      _tts = FlutterTts();

      // Vérifier la disponibilité du français, fallback anglais
      final frAvailable = await _tts!.isLanguageAvailable('fr-FR');
      final lang = frAvailable ? 'fr-FR' : 'en-US';
      await _tts!.setLanguage(lang);

      await _tts!.setPitch(0.9);
      await _tts!.setSpeechRate(0.45);
      await _tts!.setVolume(_state.voiceVolume);

      // Suivi de progression — end est relatif au chunk en cours
      _tts!.setProgressHandler(
          (String text, int start, int end, String word) {
        final chunkOffset = _currentChunkIndex < _chunkStartIndices.length
            ? _chunkStartIndices[_currentChunkIndex]
            : 0;
        _charPosition = chunkOffset + end;
        final totalChars = _fullScriptText.length;
        final progress = totalChars > 0
            ? Duration(seconds: (end / totalChars * 60).round())
            : Duration.zero;
        _state = _state.copyWith(position: progress);
        _notify();
      });

      // Fin d'un chunk → passer au suivant
      _tts!.setCompletionHandler(() {
        _currentChunkIndex++;
        if (_currentChunkIndex < _chunks.length &&
            _state.status == PlayerStatus.playing) {
          _speakCurrentChunk();
        } else if (_currentChunkIndex >= _chunks.length) {
          // Tout le texte a été lu
          _state = _state.copyWith(
              status: PlayerStatus.idle, position: Duration.zero);
          _charPosition = 0;
          _currentChunkIndex = 0;
          _chunks = [];
          _chunkStartIndices = [];
          _notify();
          _progressTimer?.cancel();
        }
      });

      _ttsReady = true;
    } catch (_) {
      _ttsReady = false;
    }
  }

  /// Vérifie que le TTS est prêt avant toute utilisation.
  bool get _isTtsReady => _ttsReady && _tts != null;

  // ═══════════════════════════════════════════════════════════════════════
  //  TTS — Chunking & lecture
  // ═══════════════════════════════════════════════════════════════════════

  /// Découpe [text] en chunks de max 3000 caractères en coupant
  /// préférentiellement en fin de phrase (. ! ?) ou au dernier espace.
  List<String> _splitIntoChunks(String text) {
    const maxChars = 3000;
    final chunks = <String>[];
    int start = 0;

    while (start < text.length) {
      if (start + maxChars >= text.length) {
        chunks.add(text.substring(start));
        break;
      }

      int end = start + maxChars;

      // Cherche une fin de phrase vers l'arrière
      int splitAt = _lastIndexOfAny(text, ['.', '!', '?'], end);
      if (splitAt > start) {
        // On inclut la ponctuation
        chunks.add(text.substring(start, splitAt + 1));
        start = splitAt + 1;
        // Saute les espaces après la ponctuation
        while (start < text.length && text[start] == ' ') {
          start++;
        }
        continue;
      }

      // Fallback : dernier espace
      splitAt = text.lastIndexOf(' ', end);
      if (splitAt > start) {
        chunks.add(text.substring(start, splitAt));
        start = splitAt + 1;
        continue;
      }

      // Hard split : on coupe au maxChars
      chunks.add(text.substring(start, end));
      start = end;
    }

    return chunks;
  }

  /// Retourne le dernier index de l'une des [chars] dans [text] avant ou à
  /// [end], ou -1 si aucun trouvé.
  int _lastIndexOfAny(String text, List<String> chars, int end) {
    int best = -1;
    for (final ch in chars) {
      final idx = text.lastIndexOf(ch, end);
      if (idx > best) best = idx;
    }
    return best;
  }

  /// Parle le chunk pointé par [_currentChunkIndex].
  Future<void> _speakCurrentChunk() async {
    if (!_isTtsReady || _currentChunkIndex >= _chunks.length) return;
    await _tts!.setVolume(_state.voiceVolume);
    await _tts!.speak(_chunks[_currentChunkIndex]);
  }

  /// Démarre la lecture par chunks depuis [_charPosition].
  /// Si [_charPosition] tombe au milieu d'un chunk, on le découpe.
  Future<void> _speakChunksFromPosition() async {
    if (!_isTtsReady || _fullScriptText.isEmpty) return;

    _chunks = _splitIntoChunks(_fullScriptText);
    _chunkStartIndices = [];
    int offset = 0;
    for (final chunk in _chunks) {
      _chunkStartIndices.add(offset);
      offset += chunk.length;
    }

    // Trouver le chunk qui contient _charPosition
    _currentChunkIndex = 0;
    for (int i = 0; i < _chunkStartIndices.length; i++) {
      if (_charPosition >= _chunkStartIndices[i]) {
        _currentChunkIndex = i;
      }
    }

    // Si on reprend au milieu d'un chunk, on le réduit
    final chunkStart = _chunkStartIndices[_currentChunkIndex];
    if (_charPosition > chunkStart) {
      final offsetInChunk = _charPosition - chunkStart;
      _chunks[_currentChunkIndex] =
          _chunks[_currentChunkIndex].substring(offsetInChunk);
      _chunkStartIndices[_currentChunkIndex] = _charPosition;
    }

    await _speakCurrentChunk();
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  Ambiance sonore
  // ═══════════════════════════════════════════════════════════════════════

  /// Charge et lance une ambiance en boucle infinie.
  Future<void> setAmbient(AmbientType type) async {
    if (_ambientPlayer == null) return;

    _currentAmbient = type;
    final url = _ambientUrls[type]!;

    try {
      await _ambientPlayer!.setAudioSource(
        AudioSource.uri(
          Uri.parse(url),
          tag: type.name,
        ),
      );
      _ambientPlayer!.setLoopMode(LoopMode.all); // boucle infinie

      // Applique le volume actuel de cette piste
      final vol = _ambientVolumeForType(type);
      await _ambientPlayer!.setVolume(vol);

      if (vol > 0) {
        await _ambientPlayer!.play();
      }
    } catch (_) {
      // Échec de chargement du flux — silencieux
    }
  }

  /// Retourne le volume actuel pour un type d'ambiance.
  double _ambientVolumeForType(AmbientType type) {
    switch (type) {
      case AmbientType.whiteNoise:
        return _state.whiteNoiseVolume;
      case AmbientType.ocean:
        return _state.oceanVolume;
      case AmbientType.rain:
        return _state.rainVolume;
      case AmbientType.lofi:
        return _state.lofiVolume;
    }
  }

  /// Définit le volume sur la piste d'ambiance active.
  void _applyAmbientVolume() {
    if (_ambientPlayer == null || _currentAmbient == null) return;
    _ambientPlayer!.setVolume(_ambientVolumeForType(_currentAmbient!));
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  Interface publique — Play / Pause / Stop
  // ═══════════════════════════════════════════════════════════════════════

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

    await _speakChunksFromPosition();
    _startProgressTimer();
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
      await _speakChunksFromPosition();
      _startProgressTimer();
    }
    _notify();
  }

  /// Sauter au chunk suivant (avance rapide).
  Future<void> skipNext() async {
    if (_chunks.isEmpty || _currentChunkIndex >= _chunks.length - 1) return;
    final wasPlaying = _state.status == PlayerStatus.playing;
    await _tts?.stop();
    _currentChunkIndex++;
    _charPosition =
        _currentChunkIndex < _chunkStartIndices.length
            ? _chunkStartIndices[_currentChunkIndex]
            : _charPosition;
    if (wasPlaying) {
      await _speakCurrentChunk();
    }
  }

  /// Revenir au chunk précédent (retour rapide).
  Future<void> skipPrevious() async {
    if (_chunks.isEmpty || _currentChunkIndex <= 0) return;
    final wasPlaying = _state.status == PlayerStatus.playing;
    await _tts?.stop();
    _currentChunkIndex--;
    _charPosition = _chunkStartIndices[_currentChunkIndex];
    if (wasPlaying) {
      await _speakCurrentChunk();
    }
  }

  /// Arrête tout.
  Future<void> stop() async {
    _sleepTimer?.cancel();
    _fadeOutTimer?.cancel();
    _progressTimer?.cancel();

    await _tts?.stop();

    // Stop l'ambiance si elle joue
    if (_ambientPlayer != null) {
      await _ambientPlayer!.stop();
    }

    _fullScriptText = '';
    _charPosition = 0;
    _chunks = [];
    _chunkStartIndices = [];
    _currentChunkIndex = 0;

    _state = _state.copyWith(
      status: PlayerStatus.idle,
      position: Duration.zero,
      remainingSeconds: 0,
    );
    _notify();
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  Interface publique — Volume
  // ═══════════════════════════════════════════════════════════════════════

  /// Met à jour le volume d'une piste.
  void setVolume(String track, double volume) {
    switch (track) {
      case 'voice':
        _state = _state.copyWith(voiceVolume: volume);
        _tts?.setVolume(volume);
        break;
      case 'whiteNoise':
        _state = _state.copyWith(whiteNoiseVolume: volume);
        if (volume > 0) {
          // Lance l'ambiance whiteNoise si pas déjà active
          if (_currentAmbient != AmbientType.whiteNoise) {
            setAmbient(AmbientType.whiteNoise);
          } else {
            _applyAmbientVolume();
          }
        } else {
          _applyAmbientVolume();
        }
        break;
      case 'ocean':
        _state = _state.copyWith(oceanVolume: volume);
        if (volume > 0) {
          if (_currentAmbient != AmbientType.ocean) {
            setAmbient(AmbientType.ocean);
          } else {
            _applyAmbientVolume();
          }
        } else {
          _applyAmbientVolume();
        }
        break;
      case 'rain':
        _state = _state.copyWith(rainVolume: volume);
        if (volume > 0) {
          if (_currentAmbient != AmbientType.rain) {
            setAmbient(AmbientType.rain);
          } else {
            _applyAmbientVolume();
          }
        } else {
          _applyAmbientVolume();
        }
        break;
      case 'lofi':
        _state = _state.copyWith(lofiVolume: volume);
        if (volume > 0) {
          if (_currentAmbient != AmbientType.lofi) {
            setAmbient(AmbientType.lofi);
          } else {
            _applyAmbientVolume();
          }
        } else {
          _applyAmbientVolume();
        }
        break;
    }
    _notify();
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  Interface publique — Minuteur / Fade-out
  // ═══════════════════════════════════════════════════════════════════════

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
    const fadeDuration = Duration(seconds: 30);
    final totalMs = (minutes * 60 * 1000) - fadeDuration.inMilliseconds;

    if (totalMs <= 0) return;

    _fadeOutTimer = Timer(Duration(milliseconds: totalMs), () async {
      _state = _state.copyWith(status: PlayerStatus.fadingOut);
      _notify();

      // Fade-out progressif sur 30 secondes
      final steps = 30;
      for (int i = 0; i < steps; i++) {
        final factor = 1.0 - (i / steps);
        // Baisse progressive du volume voix
        await _tts?.setVolume(factor * _state.voiceVolume);
        // Baisse progressive du volume ambiance
        if (_ambientPlayer != null && _currentAmbient != null) {
          await _ambientPlayer!
              .setVolume(factor * _ambientVolumeForType(_currentAmbient!));
        }
        await Future.delayed(const Duration(seconds: 1));
      }

      await stop();
    });
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  Interface publique — seekToChapter
  // ═══════════════════════════════════════════════════════════════════════

  /// Sauter au début d'un chapitre (marqué par '--- Chapitre N :' dans le
  /// texte). [chapterIndex] est 1-indexé (le premier chapitre = 1).
  Future<void> seekToChapter(int chapterIndex) async {
    if (_fullScriptText.isEmpty) return;

    final pattern = RegExp(r'---\s*Chapitre\s+\d+\s*:');
    final matches = pattern.allMatches(_fullScriptText).toList();

    if (chapterIndex < 1 || chapterIndex > matches.length) return;

    final matchIndex = chapterIndex - 1;
    _charPosition = matches[matchIndex].start;

    // Redémarrer la lecture depuis cette position
    final wasPlaying = _state.status == PlayerStatus.playing ||
        _state.status == PlayerStatus.paused;

    if (wasPlaying) {
      await _tts?.stop();
      _state = _state.copyWith(status: PlayerStatus.playing);
      await _speakChunksFromPosition();
      _startProgressTimer();
      _notify();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  Timer de progression
  // ═══════════════════════════════════════════════════════════════════════

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

  // ═══════════════════════════════════════════════════════════════════════
  //  Notification
  // ═══════════════════════════════════════════════════════════════════════

  void _notify() {
    onStateChanged?.call(_state);
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  Dispose
  // ═══════════════════════════════════════════════════════════════════════

  /// Libère les ressources.
  void dispose() {
    _sleepTimer?.cancel();
    _fadeOutTimer?.cancel();
    _progressTimer?.cancel();
    _tts?.stop();
    _ambientPlayer?.dispose();
    _ambientPlayer = null;
  }
}

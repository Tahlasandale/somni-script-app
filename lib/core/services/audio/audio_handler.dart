import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Decoupe [text] en chunks de maximum [maxChars] caracteres,
/// en coupant a la frontiere de phrase la plus proche (., !, ?).
List<String> _chunkText(String text, {int maxChars = 3000}) {
  final chunks = <String>[];

  int start = 0;
  while (start < text.length) {
    if (start + maxChars >= text.length) {
      // Dernier chunk
      chunks.add(text.substring(start));
      break;
    }

    // Chercher une frontiere de phrase dans les 200 derniers caracteres
    final end = start + maxChars;
    int cut = -1;

    // Parcourir a rebours depuis end pour trouver . ! ou ?
    for (int i = end; i > start + (maxChars ~/ 2); i--) {
      if (i >= text.length) continue;
      final ch = text[i];
      if (ch == '.' || ch == '!' || ch == '?' || ch == '\n') {
        cut = i + 1; // inclure le caractere de ponctuation
        break;
      }
    }

    // Si aucun point trouve, couper a maxChars
    if (cut <= start) {
      cut = end;
    }

    chunks.add(text.substring(start, cut));
    start = cut;
  }

  return chunks;
}

/// Position precise dans le texte pour pause/reprise.
class _TextPosition {
  final int chunkIndex;

  const _TextPosition({this.chunkIndex = 0});
}

/// Un [AudioHandler] utilisant [audio_service] pour un vrai background
/// avec notification Android, integre a [FlutterTts] pour la lecture de scripts.
class SomniAudioHandler extends BaseAudioHandler {
  final FlutterTts _tts;

  // Chunking
  List<String> _chunks = [];
  int _currentChunkIndex = 0;
  int _totalChars = 0;

  // Position precise pour pause/reprise
  _TextPosition _savedPosition = const _TextPosition();

  // Durée estimée (basée sur ~15 carac/s)
  Duration _estimatedDuration = Duration.zero;

  // Callback vers le state partagé (AudioPlayerState dans audio_service.dart)
  void Function(dynamic state)? onStateChanged;

  // Flag pour éviter les réentrées dans le completion handler
  bool _isCompletingChunk = false;

  // Indique si on est en train de lire
  bool _isPlaying = false;

  SomniAudioHandler({required this._tts}) {
    // Configurer le completion handler sur le TTS
    _tts.setCompletionHandler(_onChunkComplete);

    // Configurer le progress handler
    _tts.setProgressHandler(_onTtsProgress);
  }

  // ────────────────────────────────────────────────────────────────
  // Gestion du queue / MediaItem
  // ────────────────────────────────────────────────────────────────

  /// Prepare la lecture d'un script sans demarrer.
  void prepareScript({
    required String scriptText,
    String title = '',
  }) {
    _totalChars = scriptText.length;
    _chunks = _chunkText(scriptText);
    _currentChunkIndex = 0;
    _savedPosition = const _TextPosition();
    _estimatedDuration = Duration(seconds: (_totalChars / 15).round());

    // Publier le MediaItem
    mediaItem.add(MediaItem(
      id: 'somni_script',
      title: title.isNotEmpty ? title : 'Script',
      artist: 'SomniScript',
      duration: _estimatedDuration,
    ));
  }

  // ────────────────────────────────────────────────────────────────
  // Contrôles audio_service (override des methodes de BaseAudioHandler)
  // ────────────────────────────────────────────────────────────────

  /// Demarre ou reprend la lecture.
  @override
  Future<void> play() async {
    if (_chunks.isEmpty) return;

    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.ready,
      playing: true,
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.pause,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
    ));

    _isPlaying = true;

    if (_savedPosition.chunkIndex < _chunks.length &&
        _savedPosition.chunkIndex != _currentChunkIndex) {
      // Reprendre depuis la position sauvegardée
      _currentChunkIndex = _savedPosition.chunkIndex;
    }

    if (_currentChunkIndex < _chunks.length) {
      await _speakCurrentChunk();
    } else {
      // Si on est à la fin, recommencer
      _currentChunkIndex = 0;
      await _speakCurrentChunk();
    }
  }

  /// Met en pause la lecture.
  @override
  Future<void> pause() async {
    await _tts.stop();

    _isPlaying = false;

    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.ready,
      playing: false,
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
    ));

    // Sauvegarder la position actuelle pour la reprise
    _savedPosition = _TextPosition(
      chunkIndex: _currentChunkIndex,
    );
  }

  /// Arrête complètement la lecture et réinitialise.
  @override
  Future<void> stop() async {
    await _tts.stop();

    _isPlaying = false;
    _currentChunkIndex = 0;
    _savedPosition = const _TextPosition();
    _chunks = [];
    _totalChars = 0;

    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.idle,
      playing: false,
      controls: [
        MediaControl.play,
      ],
    ));

    mediaItem.add(const MediaItem(
      id: 'somni_script',
      title: '',
      artist: 'SomniScript',
    ));
  }

  /// Seek vers une position (saut de chunk).
  @override
  Future<void> seek(Duration position) async {
    // Convertir la durée en position dans les chunks
    if (_chunks.isEmpty || _estimatedDuration.inMilliseconds == 0) return;

    final ratio = position.inMilliseconds / _estimatedDuration.inMilliseconds;
    final targetChar = (ratio * _totalChars).round();

    // Trouver le chunk correspondant
    int charCount = 0;
    int targetChunk = 0;
    for (int i = 0; i < _chunks.length; i++) {
      charCount += _chunks[i].length;
      if (charCount > targetChar) {
        targetChunk = i;
        break;
      }
      targetChunk = i + 1;
    }
    if (targetChunk >= _chunks.length) targetChunk = _chunks.length - 1;

    final wasPlaying = _isPlaying;

    await _tts.stop();
    _currentChunkIndex = targetChunk;
    _savedPosition = _TextPosition(chunkIndex: targetChunk);

    if (wasPlaying) {
      await _speakCurrentChunk();
    }
  }

  /// Sauter au chunk suivant.
  @override
  Future<void> skipToNext() async {
    if (_currentChunkIndex + 1 < _chunks.length) {
      final wasPlaying = _isPlaying;
      await _tts.stop();
      _currentChunkIndex++;
      _savedPosition = _TextPosition(chunkIndex: _currentChunkIndex);

      if (wasPlaying) {
        await _speakCurrentChunk();
      }
    }
  }

  /// Revenir au chunk précédent.
  @override
  Future<void> skipToPrevious() async {
    if (_currentChunkIndex > 0) {
      final wasPlaying = _isPlaying;
      await _tts.stop();
      _currentChunkIndex--;
      _savedPosition = _TextPosition(chunkIndex: _currentChunkIndex);

      if (wasPlaying) {
        await _speakCurrentChunk();
      }
    }
  }

  /// Quand le service est tué par le système.
  @override
  Future<void> onTaskRemoved() async {
    await _tts.stop();
    _isPlaying = false;

    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.idle,
      playing: false,
      controls: [],
    ));

    await super.onTaskRemoved();
  }

  // ────────────────────────────────────────────────────────────────
  // Logique interne TTS
  // ────────────────────────────────────────────────────────────────

  Future<void> _speakCurrentChunk() async {
    if (_currentChunkIndex >= _chunks.length) {
      await _onAllChunksComplete();
      return;
    }

    final chunk = _chunks[_currentChunkIndex];

    // Calculer la position actuelle dans le texte
    final charPos = _chunks
        .sublist(0, _currentChunkIndex)
        .fold(0, (int sum, String c) => sum + c.length);
    final pos = Duration(
      seconds: (charPos / 15).round(),
    );

    playbackState.add(playbackState.value.copyWith(
      updatePosition: pos,
      bufferedPosition: _estimatedDuration,
      playing: true,
      processingState: AudioProcessingState.ready,
    ));

    await _tts.speak(chunk);
  }

  Future<void> _onChunkComplete() async {
    if (_isCompletingChunk) return;
    _isCompletingChunk = true;

    try {
      if (!_isPlaying) return; // On a été arrêté

      // Passer au chunk suivant
      _currentChunkIndex++;

      if (_currentChunkIndex >= _chunks.length) {
        await _onAllChunksComplete();
      } else {
        await _speakCurrentChunk();
      }
    } finally {
      _isCompletingChunk = false;
    }
  }

  Future<void> _onAllChunksComplete() async {
    _isPlaying = false;
    _currentChunkIndex = 0;
    _savedPosition = const _TextPosition();

    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.completed,
      playing: false,
      updatePosition: _estimatedDuration,
      controls: [
        MediaControl.play,
      ],
    ));
  }

  void _onTtsProgress(String text, int start, int end, String word) {
    if (!_isPlaying) return;

    // Calculer la position absolue dans le script complet
    int charBeforeCurrent = 0;
    for (int i = 0; i < _currentChunkIndex; i++) {
      charBeforeCurrent += _chunks[i].length;
    }
    final absolutePos = charBeforeCurrent + end;

    final estimatedPos = _totalChars > 0
        ? Duration(
            milliseconds:
                (absolutePos / _totalChars * _estimatedDuration.inMilliseconds)
                    .round(),
          )
        : Duration.zero;

    playbackState.add(playbackState.value.copyWith(
      updatePosition: estimatedPos,
      playing: true,
      processingState: AudioProcessingState.ready,
    ));
  }

  /// Libère les ressources.
  void dispose() {
    _tts.stop();
  }
}

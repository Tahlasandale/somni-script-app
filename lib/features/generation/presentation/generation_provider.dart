import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:somni_script_app/core/db/app_models.dart';
import 'package:somni_script_app/core/providers/gemini_provider.dart';
import 'package:somni_script_app/core/providers/database_provider.dart';
import 'package:somni_script_app/core/providers/navigation_provider.dart';

/// État du processus de génération.
enum GenerationStatus { idle, planning, writing, editing, done, error }

class GenerationState {
  final GenerationStatus status;
  final String log;
  final String? result;
  final String? error;
  final String? lastTitle;
  final String? lastMediaType;

  const GenerationState({
    this.status = GenerationStatus.idle,
    this.log = '',
    this.result,
    this.error,
    this.lastTitle,
    this.lastMediaType,
  });

  GenerationState copyWith({
    GenerationStatus? status,
    String? log,
    String? result,
    String? error,
    String? lastTitle,
    String? lastMediaType,
  }) {
    return GenerationState(
      status: status ?? this.status,
      log: log ?? this.log,
      result: result ?? this.result,
      error: error ?? this.error,
      lastTitle: lastTitle ?? this.lastTitle,
      lastMediaType: lastMediaType ?? this.lastMediaType,
    );
  }
}

/// Provider notifier du pipeline de génération.
class GenerationNotifier extends StateNotifier<GenerationState> {
  final Ref _ref;

  GenerationNotifier(this._ref) : super(const GenerationState());

  Future<void> generate({
    required String userPrompt,
    required bool isPodcast,
  }) async {
    if (userPrompt.trim().isEmpty) return;

    state = state.copyWith(
      status: GenerationStatus.planning,
      log: '🚀 Démarrage du pipeline de génération...',
      result: null,
      error: null,
      lastTitle: null,
      lastMediaType: null,
    );

    try {
      final service = await _ref.read(geminiServiceProvider.future);
      if (service == null) {
        state = state.copyWith(
          status: GenerationStatus.error,
          error:
              'Clé API Gemini non configurée. Rends-toi dans l\'onglet Bibliothèque.',
          log: '❌ Clé API manquante',
        );
        return;
      }

      state = state.copyWith(
        status: GenerationStatus.planning,
        log: service.lastLog,
      );

      final script = await service.generateFullScript(
        userPrompt: userPrompt,
        isPodcast: isPodcast,
      );

      // Titre — tronqué du prompt si trop long
      final title = userPrompt.length > 60
          ? '${userPrompt.substring(0, 57)}…'
          : userPrompt;
      final mediaType = isPodcast ? 'PODCAST' : 'STORY';

      state = state.copyWith(
        status: GenerationStatus.done,
        log: service.lastLog,
        result: script,
        lastTitle: title,
        lastMediaType: mediaType,
      );

      // Sauvegarde dans Isar
      await _saveToDb(script: script, title: title, mediaType: mediaType, userPrompt: userPrompt);

      // Préparer la navigation vers l'écran de lecture
      _ref.read(pendingPlaybackProvider.notifier).state = PendingPlayback(
        script: script,
        title: title,
        mediaType: mediaType,
      );
    } catch (e) {
      state = state.copyWith(
        status: GenerationStatus.error,
        error: e.toString(),
        log: '❌ Erreur : ${e.toString()}',
      );
    }
  }

  Future<void> _saveToDb({
    required String script,
    required String title,
    required String mediaType,
    required String userPrompt,
  }) async {
    try {
      final db = await _ref.read(isarProvider.future);
      final history = MediaHistory()
        ..title = title
        ..userPrompt = userPrompt
        ..fullNarrativeText = script
        ..mediaType = mediaType
        ..createdAt = DateTime.now();
      await db.writeTxn(() => db.mediaHistorys.put(history));
    } catch (e) {
      print('⚠️ Échec sauvegarde session : $e');
    }
  }

  void reset() {
    state = const GenerationState();
  }
}

final generationProvider =
    StateNotifierProvider<GenerationNotifier, GenerationState>((ref) {
  return GenerationNotifier(ref);
});

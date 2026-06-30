import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/gemini_provider.dart';

/// État du processus de génération.
enum GenerationStatus { idle, planning, writing, editing, done, error }

class GenerationState {
  final GenerationStatus status;
  final String log;
  final String? result;
  final String? error;

  const GenerationState({
    this.status = GenerationStatus.idle,
    this.log = '',
    this.result,
    this.error,
  });

  GenerationState copyWith({
    GenerationStatus? status,
    String? log,
    String? result,
    String? error,
  }) {
    return GenerationState(
      status: status ?? this.status,
      log: log ?? this.log,
      result: result ?? this.result,
      error: error ?? this.error,
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
    );

    try {
      final service = await _ref.read(geminiServiceProvider.future);
      if (service == null) {
        state = state.copyWith(
          status: GenerationStatus.error,
          error: 'Clé API Gemini non configurée. Rends-toi dans l\'onglet Bibliothèque.',
          log: '❌ Clé API manquante',
        );
        return;
      }

      // Écouter les logs depuis le service via un callback
      // Note: le GeminiService expose _lastLog mais pas de Stream
      // On va plutôt utiliser le polling simple via un timer

      state = state.copyWith(
        status: GenerationStatus.planning,
        log: service.lastLog,
      );

      final script = await service.generateFullScript(
        userPrompt: userPrompt,
        isPodcast: isPodcast,
      );

      state = state.copyWith(
        status: GenerationStatus.done,
        log: service.lastLog,
        result: script,
      );
    } catch (e) {
      state = state.copyWith(
        status: GenerationStatus.error,
        error: e.toString(),
        log: '❌ Erreur : ${e.toString()}',
      );
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

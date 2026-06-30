import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:somni_script_app/config/app_theme.dart';
import 'package:somni_script_app/features/generation/presentation/generation_provider.dart';

/// Onglet 1 : Générateur IA
/// Zone de saisie textuelle, commutateur Histoire/Podcast,
/// et console de logs asynchrones du pipeline multi-agents.
class GenerationScreen extends ConsumerStatefulWidget {
  const GenerationScreen({super.key});

  @override
  ConsumerState<GenerationScreen> createState() => _GenerationScreenState();
}

class _GenerationScreenState extends ConsumerState<GenerationScreen> {
  final _promptController = TextEditingController();
  bool _isPodcast = false;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(generationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Générer'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Histoire')),
                ButtonSegment(value: true, label: Text('Podcast')),
              ],
              selected: {_isPodcast},
              onSelectionChanged: (set) =>
                  setState(() => _isPodcast = set.first),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Zone de saisie
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _promptController,
              maxLines: 6,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Décris l\'ambiance, le thème, ce dont tu rêves…',
              ),
            ),
          ),

          // Bouton de génération
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: state.status == GenerationStatus.idle ||
                        state.status == GenerationStatus.error
                    ? _generate
                    : null,
                icon: state.status == GenerationStatus.idle ||
                        state.status == GenerationStatus.error
                    ? const Icon(Icons.auto_awesome)
                    : const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                label: Text(_buttonLabel(state.status)),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Console de logs
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          state.error!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    if (state.log.isNotEmpty)
                      Text(
                        state.log,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    if (state.log.isEmpty && state.error == null)
                      const Center(
                        child: Text(
                          'Console de génération\n'
                          '(Planification → Rédaction → Édition → Synthèse)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    if (state.result != null) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Script généré :',
                        style: TextStyle(
                          color: AppTheme.accentGreen,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.result!,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buttonLabel(GenerationStatus status) {
    switch (status) {
      case GenerationStatus.planning:
        return 'Planification…';
      case GenerationStatus.writing:
        return 'Rédaction…';
      case GenerationStatus.editing:
        return 'Édition…';
      case GenerationStatus.done:
        return 'Prêt ✓';
      case GenerationStatus.error:
        return 'Réessayer';
      case GenerationStatus.idle:
        return 'Générer';
    }
  }

  Future<void> _generate() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;
    await ref.read(generationProvider.notifier).generate(
          userPrompt: prompt,
          isPodcast: _isPodcast,
        );
  }
}

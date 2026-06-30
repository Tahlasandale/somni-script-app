import 'package:flutter/material.dart';
import 'package:somni_script_app/config/app_theme.dart';

/// Onglet 1 : Générateur IA
/// Zone de saisie textuelle, commutateur Histoire/Podcast,
/// et console de logs asynchrones du pipeline multi-agents.
class GenerationScreen extends StatefulWidget {
  const GenerationScreen({super.key});

  @override
  State<GenerationScreen> createState() => _GenerationScreenState();
}

class _GenerationScreenState extends State<GenerationScreen> {
  final _promptController = TextEditingController();
  bool _isPodcast = false;
  bool _isGenerating = false;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Générer'),
        actions: [
          // Commutateur Histoire / Podcast
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
                onPressed: _isGenerating ? null : _generate,
                icon: _isGenerating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(_isGenerating
                    ? 'Génération en cours…'
                    : 'Générer'),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Console de logs (placeholder)
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
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
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generate() async {
    if (_promptController.text.trim().isEmpty) return;
    setState(() => _isGenerating = true);
    // TODO: Implémenter le pipeline multi-agents Gemini
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isGenerating = false);
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:somni_script_app/config/app_theme.dart';
import 'package:somni_script_app/core/db/app_models.dart';
import 'package:somni_script_app/core/providers/secure_storage_provider.dart';
import 'package:somni_script_app/core/providers/database_provider.dart';

/// Onglet 3 : Bibliothèque & Paramètres
/// Historique chronologique des sessions + configuration.
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final _apiKeyController = TextEditingController();
  bool _obscured = true;
  bool _isSaving = false;
  List<MediaHistory> _history = [];
  bool _isLoadingHistory = true;
  StreamSubscription? _historySub;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
    _loadHistory();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _historySub?.cancel();
    super.dispose();
  }

  Future<void> _loadApiKey() async {
    final storage = ref.read(secureStorageProvider);
    final key = await storage.read(key: 'gemini_api_key');
    if (mounted) {
      setState(() {
        _apiKeyController.text = key ?? '';
      });
    }
  }

  StreamSubscription<List<MediaHistory>> _watchHistory(Isar db) {
    return db.mediaHistorys.where()
      .sortByCreatedAtDesc()
      .watch(fireImmediately: true)
      .listen((results) {
        if (mounted) {
          setState(() {
            _history = results;
            _isLoadingHistory = false;
          });
        }
      });
  }

  Future<void> _loadHistory() async {
    try {
      final db = await ref.read(isarProvider.future);
      _historySub = _watchHistory(db);
    } catch (_) {
      if (mounted) setState(() => _isLoadingHistory = false);
    }
  }

  Future<void> _saveApiKey() async {
    setState(() => _isSaving = true);
    try {
      final storage = ref.read(secureStorageProvider);
      final key = _apiKeyController.text.trim();
      if (key.isNotEmpty) {
        await storage.write(key: 'gemini_api_key', value: key);
      } else {
        await storage.delete(key: 'gemini_api_key');
      }
      // Invalider le provider pour qu'il se rafraîchisse
      ref.invalidate(geminiApiKeyProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Clé API sauvegardée')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bibliothèque'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Section API Key ---
          _SettingsSection(
            title: 'Configuration',
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _apiKeyController,
                    obscureText: _obscured,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                      fontFamily: 'monospace',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Clé API Gemini',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscured ? Icons.visibility_off : Icons.visibility,
                          size: 18,
                        ),
                        onPressed: () =>
                            setState(() => _obscured = !_obscured),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonalIcon(
                  onPressed: _isSaving ? null : _saveApiKey,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save, size: 18),
                  label: Text(_isSaving ? '…' : 'Sauver'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // --- Section modèle ---
          _SettingsSection(
            title: 'Modèle Gemini',
            child: Consumer(builder: (context, ref, _) {
              final modelsAsync = ref.watch(availableGeminiModelsProvider);
              final currentModelAsync = ref.watch(geminiModelNameProvider);
              final currentModel = currentModelAsync.valueOrNull ?? '';

              return modelsAsync.when(
                loading: () => const SizedBox(
                  height: 36,
                  child: Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                error: (_, _) => const Text(
                  'Impossible de charger les modèles.\n'
                  'Vérifie ta clé API.',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                ),
                data: (models) {
                  if (models.isEmpty) {
                    return const Text(
                      'Aucun modèle trouvé. Vérifie ta clé API.',
                      style:
                          TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                    );
                  }

                  return DropdownButtonFormField<String>(
                    key: ValueKey(currentModel),
                    initialValue: models.any((m) => m.shortName == currentModel)
                        ? currentModel
                        : null,
                    dropdownColor: const Color(0xFF1A1A2E),
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(),
                    ),
                    items: models.map((m) {
                      return DropdownMenuItem(
                        value: m.shortName,
                        child: Text(m.displayName),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setGeminiModelName(ref, val);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Modèle changé : $val'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  );
                },
              );
            }),
          ),

          const SizedBox(height: 16),

          // --- Historique ---
          const Text(
            'Historique',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          if (_isLoadingHistory)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_history.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: const Column(
                children: [
                  Icon(Icons.history, size: 48, color: AppTheme.textSecondary),
                  SizedBox(height: 12),
                  Text(
                    'Aucune session pour le moment.\n'
                    'Génère ton premier récit ou podcast !',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          else
            ..._history.map((item) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      '${item.mediaType == 'STORY' ? '📖' : '🎙️'}  '
                      '${_formatDate(item.createdAt)}',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_arrow,
                          color: AppTheme.accentGreen),
                      onPressed: () {
                        // TODO: lancer la lecture depuis l'historique
                      },
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year} ${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingsSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Card(child: Padding(padding: const EdgeInsets.all(12), child: child)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:somni_script_app/config/app_theme.dart';

/// Onglet 3 : Bibliothèque & Paramètres
/// Historique chronologique des sessions + configuration.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
          const _SettingsSection(
            title: 'Configuration',
            child: _ApiKeyField(),
          ),

          const SizedBox(height: 16),

          // --- Historique (placeholder) ---
          const Text(
            'Historique',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          // Placeholder quand vide
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: const Column(
              children: [
                Icon(
                  Icons.history,
                  size: 48,
                  color: AppTheme.textSecondary,
                ),
                SizedBox(height: 12),
                Text(
                  'Aucune session pour le moment.\nGénère ton premier récit ou podcast !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingsSection({
    required this.title,
    required this.child,
  });

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

class _ApiKeyField extends StatefulWidget {
  const _ApiKeyField();

  @override
  State<_ApiKeyField> createState() => _ApiKeyFieldState();
}

class _ApiKeyFieldState extends State<_ApiKeyField> {
  final _controller = TextEditingController();
  bool _obscured = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
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
                onPressed: () => setState(() => _obscured = !_obscured),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton.tonalIcon(
          onPressed: () {},
          icon: const Icon(Icons.save, size: 18),
          label: const Text('Sauver'),
        ),
      ],
    );
  }
}

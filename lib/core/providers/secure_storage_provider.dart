import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final geminiApiKeyProvider = FutureProvider<String?>((ref) async {
  final storage = ref.watch(secureStorageProvider);
  return storage.read(key: 'gemini_api_key');
});

final geminiModelNameProvider = FutureProvider<String>((ref) async {
  final storage = ref.watch(secureStorageProvider);
  return (await storage.read(key: 'gemini_model_name')) ?? 'gemini-2.5-flash';
});

/// Écrit la clé ET invalide le provider du nom de modèle.
void setGeminiModelName(WidgetRef ref, String modelName) {
  final storage = ref.read(secureStorageProvider);
  storage.write(key: 'gemini_model_name', value: modelName);
  ref.invalidate(geminiModelNameProvider);
}

/// Modèle disponible renvoyé par l'API Gemini.
class GeminiModelInfo {
  final String name; // "models/gemini-2.5-flash"
  final String displayName;
  final String description;
  final bool supportsGenerateContent;

  String get shortName => name.replaceFirst('models/', '');

  GeminiModelInfo({
    required this.name,
    required this.displayName,
    required this.description,
    this.supportsGenerateContent = false,
  });
}

/// Provider asynchrone qui liste les modèles Gemini utilisables.
final availableGeminiModelsProvider =
    FutureProvider<List<GeminiModelInfo>>((ref) async {
  final apiKey = await ref.watch(geminiApiKeyProvider.future);
  if (apiKey == null || apiKey.isEmpty) return [];

  try {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 10);
    final request = await client.getUrl(
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey',
      ),
    );
    final response = await request.close();
    if (response.statusCode != 200) return [];

    final body = await response.transform(utf8.decoder).join();
    final json = jsonDecode(body) as Map<String, dynamic>;
    final modelsList = json['models'] as List<dynamic>? ?? [];

    final result = modelsList
        .map((m) => m as Map<String, dynamic>)
        .where((m) {
          final name = m['name'] as String? ?? '';
          return name.startsWith('models/gemini-');
        })
        .map((m) {
          final methods = m['supportedGenerationMethods'] as List<dynamic>? ?? [];
          return GeminiModelInfo(
            name: m['name'] as String? ?? '',
            displayName: m['displayName'] as String? ?? '',
            description: m['description'] as String? ?? '',
            supportsGenerateContent:
                methods.any((e) => e.toString().contains('generateContent')),
          );
        })
        .where((m) => m.supportsGenerateContent)
        .toList()
      ..sort((a, b) => a.displayName.compareTo(b.displayName));

    return result;
  } catch (_) {
    return [];
  }
});

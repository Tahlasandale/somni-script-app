import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/gemini/gemini_service.dart';
import 'secure_storage_provider.dart';

final geminiServiceProvider = FutureProvider<GeminiService?>((ref) async {
  final k = await ref.watch(geminiApiKeyProvider.future);
  if (k == null || k.isEmpty) return null;
  return GeminiService(secretKey: k);
});

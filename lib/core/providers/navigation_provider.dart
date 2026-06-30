import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Données d'un script prêt à être lu.
class PendingPlayback {
  final String script;
  final String title;
  final String mediaType;

  const PendingPlayback({
    required this.script,
    required this.title,
    required this.mediaType,
  });
}

/// Provider du script en attente de lecture.
/// L'écran de génération le définit, l'écran de lecture le consomme et le reset.
final pendingPlaybackProvider =
    StateProvider<PendingPlayback?>((ref) => null);

/// Provider de l'index d'onglet actif dans HomeShell.
final tabIndexProvider = StateProvider<int>((ref) => 0);

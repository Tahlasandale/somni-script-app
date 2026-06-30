import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/audio/audio_service.dart';

/// Provider singleton du service audio.
final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provider qui expose l'état courant du lecteur audio.
final audioPlayerStateProvider = StreamProvider<AudioPlayerState>((ref) {
  final service = ref.watch(audioServiceProvider);
  final controller = StreamController<AudioPlayerState>.broadcast();

  service.onStateChanged = (state) {
    controller.add(state);
  };

  controller.add(service.state);

  ref.onDispose(() => controller.close());
  return controller.stream;
});

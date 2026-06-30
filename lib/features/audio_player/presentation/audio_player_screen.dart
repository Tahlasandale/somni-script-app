import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:somni_script_app/config/app_theme.dart';
import 'package:somni_script_app/core/constants.dart';
import 'package:somni_script_app/core/providers/audio_provider.dart';
import 'package:somni_script_app/core/providers/navigation_provider.dart';
import 'package:somni_script_app/core/services/audio/audio_service.dart';

/// Onglet 2 : Lecteur & Mixeur Immersif
/// Contrôles de lecture, matrice de mixage multi-pistes,
/// et minuteur d'endormissement.
class AudioPlayerScreen extends ConsumerStatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  ConsumerState<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends ConsumerState<AudioPlayerScreen> {
  @override
  void initState() {
    super.initState();

    // Écouter les scripts en attente et les lire automatiquement
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(pendingPlaybackProvider, (prev, next) {
        if (next == null) return;
        final audioService = ref.read(audioServiceProvider);
        audioService.play(
          scriptText: next.script,
          title: next.title,
        );
        // Consommé — on remet à null
        ref.read(pendingPlaybackProvider.notifier).state = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(audioPlayerStateProvider).value ??
        const AudioPlayerState();
    final audioService = ref.read(audioServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecture'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Cover / État ---
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    state.status == PlayerStatus.idle
                        ? Icons.nightlight_round
                        : Icons.headphones,
                    size: 64,
                    color: state.status == PlayerStatus.idle
                        ? AppTheme.textSecondary
                        : AppTheme.accentGreen,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    state.currentTitle.isEmpty
                        ? 'Aucune session en cours'
                        : state.currentTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                  if (state.status == PlayerStatus.fadingOut)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Fermeture progressive…',
                        style: TextStyle(
                          color: AppTheme.accentOrange,
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // --- Contrôles de lecture ---
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _controlButton(Icons.skip_previous, () {
                audioService.skipPrevious();
              }),
              const SizedBox(width: 16),
              _playButton(state),
              const SizedBox(width: 16),
              _controlButton(Icons.skip_next, () {
                audioService.skipNext();
              }),
            ],
          ),

          const SizedBox(height: 24),

          // --- Minuteur ---
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timer, color: AppTheme.textSecondary, size: 20),
              const SizedBox(width: 8),
              ...AppConstants.sleepTimerOptions.map((minutes) {
                final selected = state.sleepTimerMinutes == minutes;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text('${minutes}min'),
                    selected: selected,
                    onSelected: (_) {
                      audioService.setSleepTimer(minutes);
                    },
                    selectedColor: AppTheme.accentGreen.withAlpha(40),
                    labelStyle: TextStyle(
                      color: selected
                          ? AppTheme.accentGreen
                          : AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                );
              }),
            ],
          ),

          const SizedBox(height: 24),

          // --- Matrice de mixage ---
          const Text(
            'Mixage',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          _mixerSlider(
              'Voix', state.voiceVolume, AppTheme.accentOrange, (v) {
            audioService.setVolume('voice', v);
          }),
          _mixerSlider(
              'Bruit blanc', state.whiteNoiseVolume, Colors.grey, (v) {
            audioService.setVolume('whiteNoise', v);
          }),
          _mixerSlider('Océan', state.oceanVolume, AppTheme.accentBlue, (v) {
            audioService.setVolume('ocean', v);
          }),
          _mixerSlider(
              'Pluie', state.rainVolume, const Color(0xFF607D8B), (v) {
            audioService.setVolume('rain', v);
          }),
          _mixerSlider(
              'Lofi', state.lofiVolume, const Color(0xFFCE93D8), (v) {
            audioService.setVolume('lofi', v);
          }),
        ],
      ),
    );
  }

  Widget _controlButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: AppTheme.textPrimary),
      iconSize: 32,
      onPressed: onTap,
    );
  }

  Widget _playButton(AudioPlayerState state) {
    final playing = state.status == PlayerStatus.playing;
    final audioService = ref.read(audioServiceProvider);

    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        color: AppTheme.accentGreen,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(playing ? Icons.pause : Icons.play_arrow),
        color: Colors.black,
        iconSize: 36,
        onPressed: () => audioService.togglePause(),
      ),
    );
  }

  Widget _mixerSlider(
      String label, double value, Color color, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Slider(
              value: value,
              onChanged: onChanged,
              min: 0.0,
              max: 1.0,
              activeColor: color,
              inactiveColor: AppTheme.surfaceCard,
            ),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '${(value * 100).toInt()}%',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

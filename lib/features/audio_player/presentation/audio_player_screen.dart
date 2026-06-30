import 'package:flutter/material.dart';
import 'package:somni_script_app/config/app_theme.dart';
import 'package:somni_script_app/core/constants.dart';

/// Onglet 2 : Lecteur & Mixeur Immersif
/// Contrôles de lecture, matrice de mixage multi-pistes,
/// et minuteur d'endormissement.
class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  bool _isPlaying = false;
  int _sleepTimerMinutes = AppConstants.sleepTimerDefaultMinutes;

  // Volumes des pistes de mixage
  double _voiceVolume = AppConstants.defaultVoiceVolume;
  double _whiteNoiseVolume = 0.0;
  double _oceanVolume = 0.0;
  double _rainVolume = 0.0;
  double _lofiVolume = 0.0;

  @override
  Widget build(BuildContext context) {
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
              child: Icon(
                _isPlaying ? Icons.headphones : Icons.nightlight_round,
                size: 64,
                color: _isPlaying
                    ? AppTheme.accentGreen
                    : AppTheme.textSecondary,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Titre (placeholder)
          const Text(
            'Aucune session en cours',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 24),

          // --- Contrôles de lecture ---
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _controlButton(Icons.skip_previous, () {}),
              const SizedBox(width: 16),
              _playButton(),
              const SizedBox(width: 16),
              _controlButton(Icons.skip_next, () {}),
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
                final selected = _sleepTimerMinutes == minutes;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text('${minutes}min'),
                    selected: selected,
                    onSelected: (_) =>
                        setState(() => _sleepTimerMinutes = minutes),
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

          _mixerSlider('Voix', _voiceVolume, AppTheme.accentOrange, (v) {
            setState(() => _voiceVolume = v);
          }),
          _mixerSlider('Bruit blanc', _whiteNoiseVolume, Colors.grey, (v) {
            setState(() => _whiteNoiseVolume = v);
          }),
          _mixerSlider('Océan', _oceanVolume, AppTheme.accentBlue, (v) {
            setState(() => _oceanVolume = v);
          }),
          _mixerSlider('Pluie', _rainVolume, const Color(0xFF607D8B), (v) {
            setState(() => _rainVolume = v);
          }),
          _mixerSlider('Lofi', _lofiVolume, const Color(0xFFCE93D8), (v) {
            setState(() => _lofiVolume = v);
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

  Widget _playButton() {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        color: AppTheme.accentGreen,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
        color: Colors.black,
        iconSize: 36,
        onPressed: () => setState(() => _isPlaying = !_isPlaying),
      ),
    );
  }

  Widget _mixerSlider(String label, double value, Color color, ValueChanged<double> onChanged) {
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

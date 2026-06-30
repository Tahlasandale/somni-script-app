/// Constantes applicatives pour SomniScriptApp.
class AppConstants {
  AppConstants._();

  // --- Identité ---
  static const String appName = 'SomniScript';
  static const String appTagline = 'Endormez-vous avec l\'hypnose IA';

  // --- Navigation ---
  static const int tabGeneration = 0;
  static const int tabPlayer = 1;
  static const int tabHistory = 2;

  // --- Audio ---
  static const int sleepTimerDefaultMinutes = 30;
  static const List<int> sleepTimerOptions = [15, 30, 45, 60];
  static const double defaultVoiceVolume = 0.8;
  static const double fadeOutDurationSeconds = 30;

  // --- Gemini ---
  static const String defaultModel = 'gemini-2.0-flash';
  static const int maxChapters = 6;
}

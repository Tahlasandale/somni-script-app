import 'package:isar_community/isar.dart';

part 'app_models.g.dart';

/// Configuration utilisateur persistante.
@collection
class UserConfig {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String userId = 'default_user';

  String geminiApiKey = '';
  String modelName = 'gemini-2.5-flash';
  DateTime lastModified = DateTime.now();
}

/// Historique d'une session de génération audio.
@collection
class MediaHistory {
  Id id = Isar.autoIncrement;

  late String title;
  late String userPrompt;
  late String generatedPlanJson;
  late String fullNarrativeText;

  @Index()
  late String mediaType; // 'STORY' | 'PODCAST'

  @Index(type: IndexType.value)
  late DateTime createdAt;

  final audioPreferences = IsarLink<AudioPreferences>();
}

/// Mixage et minuteur pour une session.
@collection
class AudioPreferences {
  Id id = Isar.autoIncrement;

  double voiceVolume = 0.8;
  double whiteNoiseVolume = 0.0;
  double oceanVolume = 0.0;
  double rainVolume = 0.0;
  double lofiVolume = 0.0;

  int sleepTimerDurationMinutes = 30;

  final mediaHistory = IsarLink<MediaHistory>();
}

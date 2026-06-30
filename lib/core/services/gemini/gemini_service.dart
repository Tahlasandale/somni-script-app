import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Plan structuré retourné par l'Agent Planner.
class NarrativePlan {
  final String title;
  final List<Chapter> chapters;

  NarrativePlan({required this.title, required this.chapters});

  factory NarrativePlan.fromJson(Map<String, dynamic> json) {
    return NarrativePlan(
      title: json['title'] as String? ?? 'Session sans titre',
      chapters: (json['chapters'] as List<dynamic>?)
              ?.map((c) => Chapter.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'chapters': chapters.map((c) => c.toJson()).toList(),
      };

  String get jsonString => const JsonEncoder.withIndent('  ').convert(toJson());
}

class Chapter {
  final int id;
  final String focus;
  final String tone;

  Chapter({required this.id, required this.focus, required this.tone});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] as int? ?? 0,
      focus: json['focus'] as String? ?? '',
      tone: json['tone'] as String? ?? 'apaisant',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'focus': focus, 'tone': tone};
}

/// Pipeline multi-agents Gemini : Planner → Writers → Editor.
class GeminiService {
  final GenerativeModel _model;

  GeminiService({required String secretKey, String modelName = 'gemini-2.5-flash'})
      : _model = GenerativeModel(
          model: modelName,
          apiKey: secretKey,
          generationConfig: GenerationConfig(
            temperature: 0.8,
            topP: 0.9,
            maxOutputTokens: 8192,
          ),
        );

  String _lastLog = '';

  /// Retourne le dernier message de log (pour la console UI).
  String get lastLog => _lastLog;

  // ──────────────────────────────────────────────
  // Agent 1 : Planner — génère un plan JSON
  // ──────────────────────────────────────────────
  Future<NarrativePlan> planNarrative({
    required String userPrompt,
    bool isPodcast = false,
  }) async {
    _lastLog = '📋 Planification en cours...';
    final mediaType = isPodcast ? 'podcast' : 'récit';

    final prompt = '''
Tu es un scénariste expert en hypnose éricksonienne et relaxation.
L'utilisateur décrit l'ambiance de son $mediaType :

"$userPrompt"

Génère un plan structuré EXCLUSIVEMENT au format JSON valide, sans aucun texte autour :

{
  "title": "titre accrocheur et évocateur",
  "chapters": [
    {
      "id": 1,
      "focus": "focus du chapitre 1",
      "tone": "ton émotionnel"
    },
    {
      "id": 2,
      "focus": "focus du chapitre 2",
      "tone": "ton émotionnel"
    }
  ]
}

Entre 3 et 6 chapitres. Le premier chapitre doit installer l'ambiance de relaxation.
Le dernier chapitre doit conduire progressivement à l'endormissement.
Les tons possibles : apaisant, immersif, sensoriel, onirique, profond, suggestif.
Ne retourne QUE le JSON brut, rien d'autre.
''';

    final response = await _model.generateContent([Content.text(prompt)]);
    final text = response.text ?? '';

    // Extraction du JSON depuis la réponse (peut être entouré de ```json ... ```)
    final jsonStr = _extractJson(text);
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    final plan = NarrativePlan.fromJson(map);

    _lastLog = '📋 Plan généré : "${plan.title}" (${plan.chapters.length} chapitres)';
    return plan;
  }

  // ──────────────────────────────────────────────
  // Agent 2 : Writers — rédige chaque chapitre en parallèle
  // ──────────────────────────────────────────────
  Future<List<String>> writeChapters({
    required NarrativePlan plan,
    bool isPodcast = false,
  }) async {
    final mediaType = isPodcast ? 'podcast' : 'récit';
    final results = <String>[];

    for (final chapter in plan.chapters) {
      _lastLog = '✍️ Rédaction du chapitre ${chapter.id}/${plan.chapters.length}...';

      final prompt = '''
Tu es un écrivain spécialisé dans les $mediaType audio pour l'endormissement.
Tu rédiges le chapitre ${chapter.id} : "${chapter.focus}"
Ton : $chapter.tone

CONTEXTE GLOBAL (plan complet du $mediaType) :
${plan.jsonString}

Consignes :
- Rédige UNIQUEMENT le texte parlé pour ce chapitre.
- Utilise un vocabulaire riche en suggestions hypnotiques douces.
- Alterne phrases courtes et longues pour créer un rythme relaxant.
- Environ 300-500 mots par chapitre.
- Termine par une transition vers le chapitre suivant.
- Ne mets PAS de titre de chapitre dans le texte parlé.
- Ne retourne QUE le texte du chapitre, rien d'autre.
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      results.add(response.text ?? '');
    }

    _lastLog = '✍️ ${plan.chapters.length} chapitres rédigés';
    return results;
  }

  // ──────────────────────────────────────────────
  // Agent 3 : Editor — lisse les transitions et valide
  // ──────────────────────────────────────────────
  Future<String> editNarrative({
    required NarrativePlan plan,
    required List<String> chapters,
    bool isPodcast = false,
  }) async {
    _lastLog = '🔍 Validation de la cohérence...';
    final mediaType = isPodcast ? 'podcast' : 'récit';

    final fullText = chapters.asMap().entries.map((e) {
      final ch = plan.chapters[e.key];
      return '--- Chapitre ${ch.id} : ${ch.focus} ---\n${e.value}';
    }).join('\n\n');

    final prompt = '''
Tu es un correcteur de fin de chaîne pour $mediaType audio thérapeutique.
Reçois le texte complet ci-dessous.

TÂCHES :
1. Analyse les discontinuités narratives entre les chapitres.
2. Ajuste les transitions pour un flux fluide et cohérent.
3. Élimine les redondances.
4. Harmonise le ton général.
5. Ajoute une courte introduction apaisante et une conclusion qui guide vers le sommeil.
6. Conserve un format adapté à la synthèse vocale (pas de markdown, pas de titres, pas de parenthèses avec instructions).

Retourne UNIQUEMENT le texte final nettoyé et harmonisé.

TEXTE À CORRIGER :
$fullText
''';

    final response = await _model.generateContent([Content.text(prompt)]);
    final edited = response.text ?? fullText;

    _lastLog = '✅ Script final validé (${edited.length} caractères)';
    return edited;
  }

  // ──────────────────────────────────────────────
  // Orchestrateur : exécute les 3 agents en séquence
  // ──────────────────────────────────────────────
  Future<String> generateFullScript({
    required String userPrompt,
    bool isPodcast = false,
  }) async {
    _lastLog = '🚀 Démarrage du pipeline de génération...';

    // Agent 1: Planification
    final plan = await planNarrative(userPrompt: userPrompt, isPodcast: isPodcast);

    // Agent 2: Rédaction parallèle des chapitres
    final chapters = await writeChapters(plan: plan, isPodcast: isPodcast);

    // Agent 3: Édition finale
    final finalScript = await editNarrative(
      plan: plan,
      chapters: chapters,
      isPodcast: isPodcast,
    );

    _lastLog = '🎉 Génération terminée !';

    return finalScript;
  }

  /// Extrait du JSON depuis une réponse qui peut contenir ```json ... ```
  String _extractJson(String text) {
    final match = RegExp(r'```(?:json)?\s*([\s\S]*?)\s*```').firstMatch(text);
    if (match != null) return match.group(1)!.trim();

    // Sinon on prend tout et on tente de parser
    return text.trim();
  }
}

## Architecture Design Document
### 1.1 Executive Summary
SommeilIA est une application mobile Android native conçue pour faciliter l'endormissement des utilisateurs grâce à la génération automatisée et locale de récits et de podcasts personnalisés. En exploitant la puissance du SDK Google AI Edge et de l'architecture multi-agents s'exécutant entièrement côté client, l'application élimine les coûts d'infrastructure serveur tout en garantissant une confidentialité absolue des données utilisateur (Zero-Knowledge Architecture).
### 1.2 Core Value Proposition
 * **Hyper-Personnalisation :** Génération de contenu audio à la demande à partir de requêtes textuelles libres (prompts).
 * **Souveraineté des Données :** Exécution 100 % client-side (Edge) ; la clé API Gemini et l'historique restent confinés dans le stockage chiffré de l'appareil.
 * **Immersion Acoustique Terne :** Interface en noir profond (OLED #000000) et moteur de mixage audio multi-pistes persistant en arrière-plan, optimisés pour un usage nocturne sans perturbation lumineuse ni interruption système.
## 2. Detailed Technical Stack
```
+-----------------------------------------------------------------------+
|                           Flutter UI Layer                            |
|             (Theme: AMOLED #000000 | State: Riverpod)                 |
+-----------------------------------------------------------------------+
|                                                                       |
|   +-----------------------+                    +------------------+   |
|   |   Orchestrator Loop   |                    |  Audio Pipeline  |   |
|   |  (Google AI Edge SDK) |                    |  (audio_service) |   |

| +-----------+-----------+                    +--------+---------+ |
| :--- | :--- | :--- |
| v                                         v |
| +-----------------------+                    +------------------+ |
|  | Multi-Agent System |  | Text-To-Speech |  |
|  | (Planner/Writer/Ed.) |  | (Native/REST) |  |
| +-----------------------+                    +------------------+ |
| :--- | <br> +-----------------------------------------------------------------------+
| Storage Layer |
| (Isar DB NoSQL | flutter_secure_storage [AES-256]) |

+-----------------------------------------------------------------------+
```
### 2.1 Frontend Infrastructure
 * **Framework :** Flutter 3.x / Dart 3.x. Target Android SDK API Level 34+ (Android 14+).
 * **State Management & DI :** flutter_riverpod avec riverpod_generator pour une architecture réactive, typée et découplée des couches de présentation.
 * **Local Database :** isar (NoSQL Object Store synchrone/asynchrone à haute performance, optimisé pour les architectures embarquées).
 * **Sensitive Data Encryption :** flutter_secure_storage utilisant les primitives matérielles Android Keystore (chiffrement AES-256 des clés API).
### 2.2 Artificial Intelligence & Processing Edge
 * **LLM Integration :** SDK officiel google_generative_ai pour Dart, interfaçant directement l'API Gemini 1.5/2.0 Flash (modèles sélectionnés pour leur faible latence et leur capacité à traiter de longs contextes en streaming).
### 2.3 Audio Stack & Foreground Processing
 * **Background Execution & Session Audio :** audio_service combiné avec just_audio et just_audio_background. Cette suite permet l'encapsulation de l'audio dans un Foreground Service Android natif persistant avec affichage des contrôles de lecture dans le volet de notification système, résistant aux mécanismes agressifs de gestion de la mémoire du système d'exploitation (OOM Killer).
 * **Speech Synthesis :** flutter_tts pour l'intégration des voix de synthèse locales de l'appareil Android, avec interface d'extension REST vers des moteurs TTS externes (ElevenLabs / OpenAI TTS) via requêtes HTTP en mode streaming.
## 3. Data Architecture & Schema Models
La persistance locale s'appuie sur le moteur Isar DB avec des relations relationnelles typées et une indexation optimisée pour les requêtes chronologiques.
### 3.1 Data Models (Dart Definitions)
```dart
import 'package:isar/isar.dart';
part 'app_models.g.dart';
@collection
class UserConfig {
  Id id = Isar.autoIncrement;
  
  @Index(unique: true)
  String userId = 'default_user';
  
  String appTheme = 'AMOLED_BLACK'; // #000000 compliance
  DateTime lastModified = DateTime.now();
}
@collection
class MediaHistory {
  Id id = Isar.autoIncrement;
  
  late String title;
  late String userPrompt;
  late String generatedPlanJson; // Stockage brut du plan structuré JSON
  late String fullNarrativeText;
  
  @Index()
  late String mediaType; // 'STORY' | 'PODCAST'
  
  @Index(type: IndexType.value)
  late DateTime createdAt;
  
  final audioPreferences = IsarLink<AudioPreferences>();
}
@collection
class AudioPreferences {
  Id id = Isar.autoIncrement;
  
  double voiceVolume = 0.8;       // Range: 0.0 -> 1.0
  double whiteNoiseVolume = 0.0;   // Range: 0.0 -> 1.0
  double oceanVolume = 0.0;        // Range: 0.0 -> 1.0
  double rainVolume = 0.0;         // Range: 0.0 -> 1.0
  double lofiVolume = 0.0;         // Range: 0.0 -> 1.0
  
  int sleepTimerDurationMinutes = 30;
  
  final mediaHistory = IsarLink<MediaHistory>();
}
```
## 4. Functional Requirements & Interfaces
L'interface se structure autour d'un système de navigation par onglets (BottomNavigationBar) arborant une charte graphique sombre stricte (fond hexadécimal #000000, textes gris neutre et contrastes limités pour éviter la fatigue oculaire nocturne).
### 4.1 Interface Architecture
#### Onglet 1 : Générateur IA (GenerationView)
 * **Composants graphiques :** Zone de saisie textuelle (TextField multi-lignes), commutateur de mode (Histoire / Podcast), bouton d'action principal de génération.
 * **Composant de traçabilité :** Console de logs asynchrones affichant l'état d'avancement du réseau multi-agents (ex.: *"Planification en cours..."*, *"Rédaction du chapitre 3/5..."*, *"Validation de la cohérence..."*).
#### Onglet 2 : Lecteur & Mixeur Immersif (AudioPlayerView)
 * **Composants graphiques :** Contrôles de lecture standard (Play/Pause/Stop), indicateur de progression circulaire discret, sélecteur de minuteur d'endormissement (15, 30, 45, 60 minutes).
 * **Matrice de mixage :** Groupe de quatre curseurs linéaires virtuels (Slider) contrôlant indépendamment le volume des canaux d'arrière-plan (just_audio Player Instances) superposés dynamiquement au canal de la voix principale.
#### Onglet 3 : Bibliothèque & Paramètres (SettingsHistoryView)
 * **Composants graphiques :** ListView chronologique affichant l'historique des récits. Un clic sur un élément recharge instantanément le texte généré et restaure la configuration exacte du mixeur audio associé. Champ textuel sécurisé masqué pour la saisie et la mise à jour de la clé API Gemini.
### 4.2 Multi-Agent Execution Pipeline
```
[User Input Prompt]
         |
         v
+------------------+
| Agent 1: Planner | -> Prompts system directifs pour génération stricte JSON
+------------------+
         |
         v [Structured JSON Plan File]
         |
         +-----> Split into N Segments (Parallel Asynchronous Workers)
         |
         v
+------------------+
| Agent 2: Writers | -> N instances de sous-agents développant le contenu
+------------------+
         |
         v [Assembled Raw Text String]
         |
+------------------+
| Agent 3: Editor  | -> Analyse globale, lissage des transitions, élimination des redondances
+------------------+
         |
         v [Final Validated Script]
         |
   Text-to-Speech Engine --> Audio Background Service
```
#### Étape A : Planification Éléments Structurés (Planner Agent)
 * **Prompt Système :** Consigne d'agir en tant que scénariste expert en techniques de relaxation et d'hypnose éricksonienne. Obligation d'émettre une structure exclusive au format JSON valide selon un schéma strict : {"title": "string", "chapters": [{"id": 1, "focus": "string", "tone": "string"}]}.
#### Étape B : Production de Contenu Segmenté (Writer Agents)
 * Orchestration asynchrone via des futurs de Dart (Future.wait). Chaque segment du plan JSON fait l'objet d'un appel API indépendant contenant l'historique du plan global et le focus spécifique du chapitre afin de paralléliser la génération du texte sans heurter les limites de fenêtres de jetons (tokens).
#### Étape C : Vérification de Cohérence (Editor Agent)
 * **Prompt Système :** Reçoit le texte agrégé complet. Rôle de correcteur de fin de chaîne. Analyse des discontinuités narratives et ajustement sémantique pour l'harmonisation du ton global avant de soumettre le script final au buffer de traitement TTS.
### 4.3 Background Audio Mechanics & Timer Management
 * **Android Intent Integration :** Le service audio lève un verrou matériel d'exécution partielle (PowerManager.PARTIAL_WAKE_LOCK) permettant au processeur de finaliser les calculs d'orchestration IA et de maintenir la lecture audio active lorsque l'écran passe à l'état de veille.
 * **Moteur de Mixage Multi-Pistes :** Initialisation d'une instance principale AudioPlayer pour le flux TTS et de quatre instances secondaires configurées en mode boucle (setLoopMode(LoopMode.one)). L'atténuation ou l'amplification s'effectuent par modification du gain matériel direct via setVolume(double).
 * **Sleep Timer System :** Implémentation d'un minuteur logiciel Dart Timer couplé à la méthode stop() du service audio. À l'expiration du temps imparti, le service invoque un fondu enchaîné descendant (*fade-out*) sur une durée de 30 secondes pour éviter un arrêt brutal susceptible de réveiller l'utilisateur, suivi d'un appel à stopSelf() pour libérer les ressources système et désactiver le Foreground Service.
## 5. Development Lifecycle
### 5.1 Team & AI Workspace
 * **Structure d'équipe :** Développeur unique opérant comme Product Owner et intégrateur en chef.
 * **Méthodologie Multi-Agent IA :** Utilisation intensive d'environnements de développement assistés par IA (Cursor, GitHub Copilot) configurés avec des règles strictes d'architecture logicielle (.cursorrules).
 * **Validation Continue :** Utilisation d'agents IA secondaires programmés sous forme de scripts pour simuler des retours d'API Gemini erronés, mal formés ou tronqués afin de valider automatiquement la robustesse du parseur de l'application (Robustness Testing via Agent-Driven QA).
### 5.2 Architectural Patterns
 * **Clean Architecture (Feature-First Layout) :** Découpage du projet par domaine fonctionnel (ex: features/generation, features/audio_player, features/history). Chaque module est strictement cloisonné en trois couches indépendantes :
   1. **Data Layer :** Data sources (Isar, Gemini SDK) et implémentation des répertoires (*repositories*).
   2. **Domain Layer :** Entités métiers pures, cas d'usage (*use cases*) et interfaces.
   3. **Presentation Layer :** State providers (Riverpod AsyncNotifier) et composants UI d'affichage.
## 6. Deployment & Scalability Strategy
### 6.1 GitHub Repository Management & CI Pipeline
 * **Gestion des Sources :** Dépôt privé hébergé sur GitHub. Stratégie de branches simplifiée de type Feature Branch Workflow fusionnant vers une branche principale main.
 * **Automatisation CI (GitHub Actions) :** Configuration d'un workflow d'intégration continue déclenché à chaque mise à jour. Le pipeline exécute l'analyse statique du code (flutter analyze) et s'assure du succès de la compilation des générateurs de code Isar et Riverpod.
### 6.2 Target Deliverable & Launch Platform
 * **Production Release Target :** Le livrable final consiste exclusivement en la compilation d'un package Android universel au format APK (app-release.apk) signé numériquement.
 * **Web Landing Page :** Déploiement via GitHub Pages d'une page vitrine statique (Single Page HTML5/CSS3) hébergée sur l'adresse du dépôt. Cette page assure le rôle de portail d'information corporate, présentant les fonctionnalités clés, les engagements de confidentialité et les instructions d'installation manuelle de l'application (Sideloading via APK), sans aucun déploiement immédiat sur la plateforme Google Play Store.
### 6.3 Cost & Scaling Metrics
 * **Coût d'infrastructure :** $0.00 USD.
 * **Évolutivité :** Infinie. L'architecture décentralisée déporte la charge de traitement algorithmique (génération de texte, traitement du langage naturel, synthèse vocale, mixage audio de flux binaires) sur le matériel终端 de l'utilisateur final. La scalabilité de l'application n'est corrélée à aucune contrainte d'allocation de serveurs cloud ou de provisionnement de bases de données distribuées.
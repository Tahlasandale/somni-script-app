import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:somni_script_app/config/app_theme.dart';
import 'package:somni_script_app/home_shell.dart';
import 'package:somni_script_app/core/services/audio/audio_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Barre de statut transparente sur fond noir pour immersion nocturne
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.amoledBlack,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialise audio_service pour le background playback et la notification
  // Le TTS est partagé avec le service UI via le provider
  await AudioService.init(
    builder: () => SomniAudioHandler(tts: FlutterTts()),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.somniscript.somni_script_app.playback',
      androidNotificationChannelName: 'Lecture SomniScript',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
      androidNotificationIcon: 'mipmap/ic_launcher',
    ),
  );

  runApp(const ProviderScope(child: SomniScriptApp()));
}

class SomniScriptApp extends ConsumerWidget {
  const SomniScriptApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'SomniScript',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeShell(),
    );
  }
}

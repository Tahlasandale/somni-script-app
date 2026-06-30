import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:somni_script_app/config/app_theme.dart';
import 'package:somni_script_app/home_shell.dart';

void main() {
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

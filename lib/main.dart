import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  runApp(const SomniScriptApp());
}

class SomniScriptApp extends StatelessWidget {
  const SomniScriptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SomniScript',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeShell(),
    );
  }
}

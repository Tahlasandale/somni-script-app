import 'package:flutter/material.dart';
import 'package:somni_script_app/features/generation/presentation/generation_screen.dart';
import 'package:somni_script_app/features/audio_player/presentation/audio_player_screen.dart';
import 'package:somni_script_app/features/history/presentation/history_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    GenerationScreen(),
    AudioPlayerScreen(),
    HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'Générer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.headphones),
            label: 'Lecture',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Bibliothèque',
          ),
        ],
      ),
    );
  }
}

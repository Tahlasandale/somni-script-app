import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:somni_script_app/core/providers/navigation_provider.dart';
import 'package:somni_script_app/features/generation/presentation/generation_screen.dart';
import 'package:somni_script_app/features/audio_player/presentation/audio_player_screen.dart';
import 'package:somni_script_app/features/history/presentation/history_screen.dart';

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(tabIndexProvider);

    final screens = <Widget>[
      const GenerationScreen(),
      const AudioPlayerScreen(),
      const HistoryScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => ref.read(tabIndexProvider.notifier).state = i,
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

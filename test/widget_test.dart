import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somni_script_app/home_shell.dart';

/// Widget test du shell principal.
///
/// On n'utilise PAS pumpAndSettle() car les providers async (isarProvider,
/// geminiServiceProvider) ne se résolvent jamais en environnement de test,
/// ce qui ferait timeout indéfiniment. On pompe manuellement avec des
/// durations pour laisser l'UI s'initialiser.
void main() {
  testWidgets('Home shell affiche les 3 onglets de navigation', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: HomeShell())),
    );

    // Laisser Riverpod initialiser ses providers synchrones
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Les 3 labels de la BottomNavigationBar doivent être présents
    // Note: "Générer" apparaît aussi dans l'AppBar et le bouton, donc 3 occurrences
    expect(find.text('Lecture'), findsOneWidget);
    expect(find.text('Bibliothèque'), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // L'onglet 0 est actif par défaut — on vérifie un élément distinctif
    expect(find.byIcon(Icons.auto_awesome), findsWidgets);
  });
}

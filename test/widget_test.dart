import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somni_script_app/home_shell.dart';

void main() {
  testWidgets('App renders bottom navigation with 3 tabs', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: HomeShell())),
    );
    // Provider async loading → pumpAndSettle timeout
    // On utilise pump avec un délai pour laisser Riverpod s'initialiser
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    // "Générer" apparaît dans l'AppBar ET dans la BottomNav → au moins 1
    expect(find.text('Lecture'), findsOneWidget);
    expect(find.text('Bibliothèque'), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Vérifie que l'écran en cours est l'onglet Générer (trouvé au moins une fois)
    expect(
      find.text('Générer'),
      findsAtLeastNWidgets(1),
      reason: 'Le titre de l\'AppBar ou l\'item BottomNav doit afficher Générer',
    );
  });
}

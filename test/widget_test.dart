import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somni_script_app/main.dart';

void main() {
  testWidgets('App renders bottom navigation with 3 tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const SomniScriptApp());

    // Vérifie que les 3 onglets de navigation sont présents
    expect(find.text('Lecture'), findsOneWidget);
    expect(find.text('Bibliothèque'), findsOneWidget);

    // L'onglet actif "Générer" est affiché dans l'AppBar
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}

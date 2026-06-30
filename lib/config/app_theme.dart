import 'package:flutter/material.dart';

/// Thème AMOLED #000000 strict — conçu pour un usage nocturne
/// sans perturbation lumineuse ni fatigue oculaire.
class AppTheme {
  AppTheme._();

  // --- Couleurs fixes ---
  static const Color amoledBlack = Color(0xFF000000);
  static const Color nearBlack = Color(0xFF0A0A0A);
  static const Color surfaceDark = Color(0xFF111111);
  static const Color surfaceCard = Color(0xFF1A1A1A);
  static const Color textPrimary = Color(0xFFE0E0E0);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentBlue = Color(0xFF42A5F5);
  static const Color accentOrange = Color(0xFFFFA726);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: amoledBlack,

      colorScheme: const ColorScheme.dark(
        primary: accentGreen,
        secondary: accentBlue,
        surface: surfaceDark,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: textPrimary,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: amoledBlack,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: amoledBlack,
        selectedItemColor: accentGreen,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: textSecondary),
      ),

      sliderTheme: const SliderThemeData(
        activeTrackColor: accentGreen,
        inactiveTrackColor: surfaceCard,
        thumbColor: accentGreen,
        overlayColor: Color(0x294CAF50),
      ),

      dividerTheme: const DividerThemeData(
        color: surfaceCard,
        thickness: 1,
      ),
    );
  }
}

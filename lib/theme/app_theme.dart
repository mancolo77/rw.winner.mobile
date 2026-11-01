import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF121212);
  static const Color darkNav = Color(0xFF000000);
  static const Color surfaceCard = Color(0xFF232323);
  static const Color filterBg = Color(0xFF333333);
  static const Color border = Color(0xFF606060);
  static const Color primary = Color(0xFFFFF000); // Yellow
  static const Color accentRed = Color(0xFFED2433); // LIVE red
  static const Color textMain = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color buttonTextDark = Color(0xFF121212);

  static const double cardRadius = 16.0;
  static const double buttonRadius = 12.0;
  static const double buttonHeight = 48.0;
  static const double screenPadding = 16.0;

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        surface: surfaceCard,
        
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: buttonTextDark,
          elevation: 0,
          minimumSize: const Size(0, buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Compatibility getters
  static const Color surface = surfaceCard;
  static const Color surfaceElevated = surfaceCard;
  static const Color surfaceBorder = border;
  static const Color textPrimary = textMain;
  static const Color textMuted = textSecondary;
  static const Color secondary = primary;
  static const Color accentYellow = primary;
  static const Color accentGold = primary;
  static const Color accentRose = Color(0xFFED2433);

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withAlpha(20),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get neonGlow => [
        BoxShadow(
          color: primary.withAlpha(50),
          blurRadius: 16,
          spreadRadius: 1,
        ),
      ];

  static ThemeData get darkTheme => theme;
  static ThemeData get lightTheme => theme;
}

import 'package:flutter/material.dart';

class AppTheme {
  // Notebook/Paper styling colors
  static const Color paperBackground = Color(0xFFFAF7F0); // Off-white paper color
  static const Color primaryText = Color(0xFF333333); // Dark pencil/ink color
  static const Color accentColor = Color(0xFFE89A3D); // Orange-ish accent for lightbulbs, etc.
  static const Color lineColor = Color(0xFFE0E0E0); // Light gray for notebook lines
  static const Color redLineColor = Color(0xFFFFCCCC); // Light red for notebook margin
  
  static const Color successGreen = Color(0xFF9CCC65);
  static const Color errorRed = Color(0xFFEF5350);

  // Text Styles
  static const TextStyle notebookText = TextStyle(
    fontFamily: 'Comic Sans MS', // Fallback, would normally use a custom handwriting font like 'Permanent Marker' or 'Architects Daughter'
    fontSize: 24,
    color: primaryText,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle headerText = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: primaryText,
    letterSpacing: 1.2,
  );

  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryText,
      scaffoldBackgroundColor: paperBackground,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: accentColor,
      ),
      textTheme: const TextTheme(
        bodyMedium: notebookText,
        titleLarge: headerText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: paperBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryText),
        titleTextStyle: headerText,
      ),
    );
  }
}

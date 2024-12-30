import 'package:flutter/material.dart';

class AppTheme {
  // Couleurs principales inspirées de Pictionary
  static const Color primaryBlue = Color(0xFF1C5D99); // Bleu principal
  static const Color secondaryYellow = Color(0xFFFFD700); // Jaune vif
  static const Color backgroundLight = Color(0xFFB60AF8); // Fond bleu clair pastel
  static const Color backgroundDark = Color(0xFF0D0D0D); // Fond noir

  // Définition du thème clair
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryBlue,
    scaffoldBackgroundColor: backgroundLight, // Fond uni bleu clair
    colorScheme: ColorScheme.light(
      primary: primaryBlue,
      secondary: secondaryYellow,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryBlue),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryBlue,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
    ),
  );

  // Définition du thème sombre (optionnel)
  static ThemeData darkTheme = ThemeData(
    primaryColor: primaryBlue,
    scaffoldBackgroundColor: backgroundDark, // Fond uni noir
    colorScheme: ColorScheme.dark(
      primary: primaryBlue,
      secondary: secondaryYellow,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
    ),
  );
}

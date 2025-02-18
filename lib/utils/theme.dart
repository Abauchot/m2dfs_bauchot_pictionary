import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Couleurs principales
  static const Color primaryBlue = Color(0xFF1C5D99); // Bleu principal
  static const Color secondaryYellow = Color(0xFFFFD700); // Jaune vif
  static const Color backgroundLight = Color(0xFFB60AF8); // Fond clair
  static const Color backgroundDark = Color(0xFF0D0D0D); // Fond sombre
  static const Color whiteText = Color(0xFFFFFFFF); // Texte blanc

  // Thème clair
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryBlue,
    scaffoldBackgroundColor: backgroundLight,
    colorScheme: ColorScheme.light(
      primary: primaryBlue,
      secondary: secondaryYellow,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: whiteText),
      bodyLarge: GoogleFonts.poppins(fontSize: 16, color: whiteText),
      bodyMedium: GoogleFonts.poppins(fontSize: 14, color: whiteText),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return secondaryYellow;
            }
            return primaryBlue;
          },
        ),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        )),
      ),
    ),
  );

  // Thème sombre
  static ThemeData darkTheme = ThemeData(
    primaryColor: primaryBlue,
    scaffoldBackgroundColor: backgroundDark,
    colorScheme: ColorScheme.dark(
      primary: primaryBlue,
      secondary: secondaryYellow,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
      bodyMedium: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
    ),
  );
}

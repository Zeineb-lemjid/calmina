import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const primaryColor = Color(0xFF81D8D0);
  static const secondaryColor = Color(0xFFD99E82);
  static const tertiaryColor = Color(0xFFD7D982);
  static const accentColor = Color(0xFFAE82D9);

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      surface: Colors.white,
      background: Colors.grey[50]!,
      error: Colors.red[700]!,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
        color: Colors.black87,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
        color: Colors.black87,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: GoogleFonts.playfairDisplay(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red[700]!),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      surface: Colors.grey[900]!,
      background: Colors.black87,
      error: Colors.red[700]!,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
        color: Colors.white,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: GoogleFonts.playfairDisplay(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[600]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red[700]!),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}

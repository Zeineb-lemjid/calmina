import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primary = Color(0xFF6B5B95);      // Purple color from design
  static const Color peachLight = Color(0xFFF0F4FF);   // Light background color
  static const Color peach = Color(0xFFFFB6C1);        // Pink color for brain illustrations
  static const Color teal = Color(0xFF40E0D0);         // Teal color for landscape
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;

  // Text Styles
  static final TextStyle titleLarge = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: black,
    letterSpacing: -0.5,
    height: 1.3,
  );

  static final TextStyle titleMedium = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: black,
    letterSpacing: -0.5,
    height: 1.3,
  );

  static final TextStyle subtitleLarge = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: black,
    letterSpacing: -0.25,
    height: 1.4,
  );

  static final TextStyle subtitleMedium = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: black,
    letterSpacing: -0.25,
    height: 1.4,
  );

  static final TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: black,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static final TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: black,
    letterSpacing: 0.25,
    height: 1.5,
  );

  // Theme Data
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: peachLight,
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: black),
      titleTextStyle: GoogleFonts.poppins(
        color: black,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: GoogleFonts.poppins(color: grey),
      hintStyle: GoogleFonts.poppins(color: grey),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: Colors.grey[900],
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: white),
      titleTextStyle: GoogleFonts.poppins(
        color: white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red[700]!),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: GoogleFonts.poppins(color: Colors.grey[400]),
      hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _primaryColor = Color(0xFF6200EE);
  static const _secondaryColor = Color(0xFF03DAC6);
  static const _backgroundColor = Color(0xFFF5F5F5);
  static const _errorColor = Color(0xFFB00020);
  static const _surfaceColor = Color(0xFFFFFFFF);
  static const _onPrimaryColor = Color(0xFFFFFFFF);
  static const _onSecondaryColor = Color(0xFF000000);
  static const _onBackgroundColor = Color(0xFF000000);
  static const _onSurfaceColor = Color(0xFF000000);
  static const _onErrorColor = Color(0xFFFFFFFF);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: _primaryColor,
        secondary: _secondaryColor,
        background: _backgroundColor,
        error: _errorColor,
        surface: _surfaceColor,
        onPrimary: _onPrimaryColor,
        onSecondary: _onSecondaryColor,
        onBackground: _onBackgroundColor,
        onSurface: _onSurfaceColor,
        onError: _onErrorColor,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: _primaryColor,
        foregroundColor: _onPrimaryColor,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: _onPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _errorColor),
        ),
      ),
    );
  }
}

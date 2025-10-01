import 'package:flutter/material.dart';

class AppTheme {
  // Colores del tema "Noche de Cine"
  static const Color midnightBlue = Color(0xFF0D1117);    // Fondo principal
  static const Color softCharcoal = Color(0xFF161B22);    // Elementos secundarios
  static const Color vibrantAmber = Color(0xFFFFC107);    // Color de acento
  static const Color pureWhite = Color(0xFFFFFFFF);       // Texto principal
  static const Color lightGray = Color(0xFF8B949E);       // Texto secundario

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: midnightBlue,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: midnightBlue,
        foregroundColor: pureWhite,
        elevation: 0,
        centerTitle: true,
      ),

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: vibrantAmber,
        secondary: vibrantAmber,
        surface: softCharcoal,
        onSurface: pureWhite,
        onPrimary: midnightBlue,
        outline: lightGray,
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        color: softCharcoal,
        elevation: 4,
        margin: EdgeInsets.all(8),
      ),

      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: pureWhite,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: pureWhite,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: pureWhite,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: lightGray,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: lightGray,
          fontSize: 12,
        ),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: vibrantAmber,
          foregroundColor: midnightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
      ),

      // Input Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: softCharcoal,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: lightGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: vibrantAmber),
        ),
        labelStyle: const TextStyle(color: lightGray),
        hintStyle: const TextStyle(color: lightGray),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: lightGray,
      ),
    );
  }
}
import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: const Color(0xFF2E3B62),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2E3B62),
      secondary: Color(0xFFFFA726),
      background: Color(0xFFF8F9FA),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2E3B62),
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    primaryColor: const Color(0xFF2E3B62),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF2E3B62),
      secondary: Color(0xFFFFA726),
      background: Color(0xFF121212),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2E3B62),
      elevation: 2,
    ),
  );
}
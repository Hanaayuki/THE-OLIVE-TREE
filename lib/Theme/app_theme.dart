import 'package:flutter/material.dart';

class AppTheme {
  static const Color olive = Color(0xFF556B2F);
  static const Color oliveLight = Color(0xFF8AA05B);
  static const Color cream = Color(0xFFF5F1E8);
  static const Color brown = Color(0xFF3E2C1C);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: cream,

    colorScheme: ColorScheme.fromSeed(
      seedColor: olive,
      brightness: Brightness.light,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: cream,
      foregroundColor: brown,
      elevation: 0,
      centerTitle: true,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: olive,
      foregroundColor: Colors.white,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: olive,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
    ),

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: brown,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        color: Colors.black87,
      ),
    ),
  );
}
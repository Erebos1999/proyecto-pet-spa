import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff7fd8e7),
      primary: const Color(0xff66c7d8),
      secondary: const Color(0xffb8eef5),
      surface: Colors.white,
    ),

    scaffoldBackgroundColor: const Color(
      0xfff8fdff,
    ),

    fontFamily: 'Nunito',

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Color(0xff1f4e5f),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Color(0xffdceff3),
        ),
      ),
    ),

    elevatedButtonTheme:
        ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize:
            const Size(double.infinity, 55),
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(18),
        ),
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 4,
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(24),
      ),
      color: Colors.white,
    ),
  );
}
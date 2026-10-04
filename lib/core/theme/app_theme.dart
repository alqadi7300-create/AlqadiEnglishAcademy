import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color(0xFF175A7A),
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF6F8FA),
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
    cardTheme: const CardThemeData(margin: EdgeInsets.symmetric(vertical: 6), elevation: 1),
  );
}

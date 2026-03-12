import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1D4ED8); // CampusHub Mavisi
  static const Color backgroundColor = Color(0xFFF8FAFC); // Açık gri arka plan

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
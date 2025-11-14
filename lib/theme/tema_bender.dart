import 'package:flutter/material.dart';

class TemaBender {
  static const Color fondo = Color(0xFF0D0D0D);
  static const Color tarjeta = Color(0xFF1E1E1E);
  static const Color acento = Color(0xFFFFC107);
  static const Color secundario = Color(0xFF00BCD4);
  static const Color borde = Color(0xFF2E2E2E);

  static ThemeData tema() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: fondo,
      colorScheme: const ColorScheme.dark(
        surface: fondo,
        primary: acento,
        secondary: secundario,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1C1C1C),
        selectedItemColor: acento,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
      cardTheme: CardThemeData(
        color: tarjeta,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: borde),
        ),
      ),
      iconTheme: const IconThemeData(color: acento),
    );
  }
}

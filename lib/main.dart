import 'package:flutter/material.dart';
import 'ekranlar/home.dart';

void main() {
  runApp(const MarineApp());
}

// ─── Global Renk Paleti ───────────────────────────────────────────────────────
class AppColors {
  static const background = Color(0xFF0B1622); // Derin okyanus siyahı
  static const surface = Color(0xFF152033); // Koyu lacivert kart
  static const surfaceLight = Color(0xFF1E2E45); // Biraz daha açık kart
  static const accent = Color(0xFF00C8E8); // Parlak cyan
  static const accentDark = Color(0xFF0077B6); // Okyanus mavisi
  static const safe = Color(0xFF06D6A0); // Yeşil (uygun)
  static const warning = Color(0xFFFFB703); // Altın sarısı (dikkat)
  static const danger = Color(0xFFEF233C); // Kırmızı (tehlike)
  static const textPrimary = Color(0xFFE8F4F8); // Açık beyaz
  static const textSecondary = Color(0xFF7A9CC0); // Soluk mavi-gri
  static const divider = Color(0xFF1E3554); // Bölücü çizgi
}

class MarineApp extends StatelessWidget {
  const MarineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Marine Rehber',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.accent,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accent,
          secondary: AppColors.accentDark,
          surface: AppColors.surface,
          background: AppColors.background,
        ),

        // AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: AppColors.textPrimary,
          ),
        ),

        // Butonlar
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.background,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
        ),

        // Kartlar
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        dividerColor: AppColors.divider,
        iconTheme: const IconThemeData(color: AppColors.accent),
      ),
      home: const HomePage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Color Palette
  static const Color primaryColor = Color(0xFF6366F1); // Modern Indigo
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color secondaryColor = Color(0xFF06B6D4); // Vibrant Cyan
  static const Color accentColor = Color(0xFF10B981); // Emerald Green
  static const Color warningColor = Color(0xFFF59E0B); // Amber Accent
  static const Color dangerColor = Color(0xFFF43F5E); // Vivid Rose

  // Neutral Colors - Light Mode
  static const Color lightBackground = Color(0xFFF1F5F9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFE2E8F0);
  static const Color lightOnSurface = Color(0xFF0F172A);

  // Neutral Colors - Dark Mode
  static const Color darkBackground = Color(0xFF080C14);
  static const Color darkSurface = Color(0xFF0F172A);
  static const Color darkSurfaceVariant = Color(0xFF1E293B);
  static const Color darkOnSurface = Color(0xFFF8FAFC);

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient roseGradient = LinearGradient(
    colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient amberGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient ambientGlowGradient = LinearGradient(
    colors: [Color(0x336366F1), Color(0x1906B6D4)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Light Theme Configuration
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.interTextTheme();
    final outfitTextTheme = GoogleFonts.outfitTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        error: dangerColor,
        surface: lightSurface,
        onSurface: lightOnSurface,
      ),
      scaffoldBackgroundColor: lightBackground,
      textTheme: baseTextTheme.copyWith(
        displayLarge: outfitTextTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold, color: lightOnSurface),
        displayMedium: outfitTextTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, color: lightOnSurface),
        headlineLarge: outfitTextTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: lightOnSurface),
        headlineMedium: outfitTextTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: lightOnSurface),
        titleLarge: outfitTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: lightOnSurface),
        titleMedium: outfitTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: lightOnSurface),
      ).apply(
        bodyColor: lightOnSurface,
        displayColor: lightOnSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: lightOnSurface),
        iconTheme: const IconThemeData(color: lightOnSurface),
      ),
      cardTheme: CardTheme(
        color: lightSurface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: primaryColor.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: dangerColor, width: 1.5),
        ),
      ),
    );
  }

  // Dark Theme Configuration
  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);
    final outfitTextTheme = GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        error: dangerColor,
        surface: darkSurface,
        onSurface: darkOnSurface,
      ),
      scaffoldBackgroundColor: darkBackground,
      textTheme: baseTextTheme.copyWith(
        displayLarge: outfitTextTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold, color: darkOnSurface),
        displayMedium: outfitTextTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, color: darkOnSurface),
        headlineLarge: outfitTextTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: darkOnSurface),
        headlineMedium: outfitTextTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: darkOnSurface),
        titleLarge: outfitTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: darkOnSurface),
        titleMedium: outfitTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: darkOnSurface),
      ).apply(
        bodyColor: darkOnSurface,
        displayColor: darkOnSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: darkOnSurface),
        iconTheme: const IconThemeData(color: darkOnSurface),
      ),
      cardTheme: CardTheme(
        color: darkSurface,
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.08), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 6,
          shadowColor: primaryColor.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceVariant.withOpacity(0.8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.12), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.12), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: dangerColor, width: 1.5),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';

class ThemeColors {
  // Constructor to allow inheritance
  ThemeColors();

  // Primary Colors
  Color get primary => const Color(0xFF0066CC);
  Color get secondary => const Color(0xFF00CC99);

  // Background Colors
  Color get backgroundPrimary => const Color(0xFFF4F4F4);
  Color get backgroundSecondary => const Color(0xFFFFFFFF);
  Color get backgroundTertiary => const Color(0xFFEFEFEF);

  // Text Colors
  Color get textPrimary => const Color(0xFF212121);
  Color get textSecondary => const Color(0xFF757575);

  // State Colors
  Color get active => const Color(0xFF0066CC);
  Color get inactive => const Color(0xFFB0BEC5);
  Color get error => const Color(0xFFD32F2F);

  // Gradients
  LinearGradient get primaryGradient =>
      const LinearGradient(colors: [Color(0xFF0066CC), Color(0xFF33A1FF)]);
}

class LightThemeColors extends ThemeColors {
  LightThemeColors();

  @override
  Color get primary => const Color(0xFF0066CC);
  @override
  Color get secondary => const Color(0xFF00CC99);

  @override
  Color get backgroundPrimary => const Color(0xFFFFFFFF);
  @override
  Color get backgroundSecondary => const Color(0xFFF5F5F5);
  @override
  Color get backgroundTertiary => const Color(0xFFE0E0E0);

  @override
  Color get textPrimary => const Color(0xFF212121);
  @override
  Color get textSecondary => const Color(0xFF757575);

  @override
  Color get active => const Color(0xFF0066CC);
  @override
  Color get inactive => const Color(0xFFB0BEC5);

  @override
  LinearGradient get primaryGradient =>
      const LinearGradient(colors: [Color(0xFF33A1FF), Color(0xFF0066CC)]);
}

class DarkThemeColors extends ThemeColors {
  DarkThemeColors();

  @override
  Color get primary => const Color(0xFF33A1FF);
  @override
  Color get secondary => const Color(0xFF66FFB2);

  @override
  Color get backgroundPrimary => const Color(0xFF121212);
  @override
  Color get backgroundSecondary => const Color(0xFF1E1E1E);
  @override
  Color get backgroundTertiary => const Color(0xFF292929);

  @override
  Color get textPrimary => const Color(0xFFFFFFFF);
  @override
  Color get textSecondary => const Color(0xFFB0BEC5);

  @override
  Color get active => const Color(0xFF33A1FF);
  @override
  Color get inactive => const Color(0xFF616161);

  @override
  LinearGradient get primaryGradient =>
      const LinearGradient(colors: [Color(0xFF33A1FF), Color(0xFF0066CC)]);
}

import 'package:flutter/material.dart';

/// [AppColors] - Core color constants for the Astro Iztro app
/// Following Apple Human Interface Guidelines with deep purple and gold theme
class AppColors {
  // Primary Colors - Deep purple and gold theme
  static const Color primaryPurple = Color(0xFF6B46C1);
  static const Color primaryGold = Color(0xFFF59E0B);

  // Purple variants
  static const Color lightPurple = Color(0xFF8B5CF6);
  static const Color darkPurple = Color(0xFF4C1D95);
  static const Color ultraLightPurple = Color(0xFFE0E7FF);

  // Gold variants
  static const Color lightGold = Color(0xFFFBBF24);
  static const Color darkGold = Color(0xFFD97706);
  static const Color ultraLightGold = Color(0xFFFEF3C7);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color.fromRGBO(249, 250, 251, 1);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Traditional Chinese colors for astrology
  static const Color cinnabar = Color(0xFFE34234); // 朱砂色
  static const Color emerald = Color(0xFF50C878); // 翡翠色
  static const Color jade = Color(0xFF00A86B); // 玉色
  static const Color amber = Color(0xFFFFBF00); // 琥珀色

  // Dark mode colors
  static const Color darkBackground = Color(0xFF0F0F23);
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color darkCard = Color(0xFF16213E);

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, primaryGold],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkBackground, darkSurface],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [ultraLightPurple, white],
  );
}

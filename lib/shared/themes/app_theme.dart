import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// [AppTheme] - Comprehensive theme configuration following Apple Human Interface Guidelines
/// Creates beautiful, modern themes with deep purple and gold accents
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      fontFamily: AppConstants.primaryFont,

      // AppBar theme - sleek and minimal
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontFamily: AppConstants.primaryFont,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        iconTheme: IconThemeData(
          color: AppColors.primaryPurple,
          size: 24,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      // Card theme - modern with subtle shadows
      cardTheme: CardThemeData(
        elevation: AppConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        color: AppColors.white,
        surfaceTintColor: AppColors.ultraLightPurple,
      ),

      // Elevated button theme - Apple-style buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: AppColors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          textStyle: const TextStyle(
            fontFamily: AppConstants.primaryFont,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryPurple,
          textStyle: const TextStyle(
            fontFamily: AppConstants.primaryFont,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Input decoration theme - clean and modern
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: AppColors.grey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: AppColors.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(
            color: AppColors.primaryPurple,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: const TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: AppColors.grey600,
        ),
        hintStyle: const TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: AppColors.grey400,
        ),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primaryPurple,
        unselectedItemColor: AppColors.grey400,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryGold,
        foregroundColor: AppColors.white,
        elevation: 6,
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        elevation: 8,
        backgroundColor: AppColors.white,
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.grey200,
        thickness: 1,
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      fontFamily: AppConstants.primaryFont,

      // AppBar theme for dark mode
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontFamily: AppConstants.primaryFont,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
        iconTheme: IconThemeData(
          color: AppColors.lightPurple,
          size: 24,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // Card theme for dark mode
      cardTheme: CardThemeData(
        elevation: AppConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        color: AppColors.darkCard,
        surfaceTintColor: AppColors.darkPurple,
      ),

      // Elevated button theme for dark mode
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPurple,
          foregroundColor: AppColors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          textStyle: const TextStyle(
            fontFamily: AppConstants.primaryFont,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input decoration theme for dark mode
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey800,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: AppColors.grey600),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: AppColors.grey600),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: AppColors.lightPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: const TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: AppColors.grey300,
        ),
        hintStyle: const TextStyle(
          fontFamily: AppConstants.primaryFont,
          color: AppColors.grey500,
        ),
      ),

      // Bottom navigation bar theme for dark mode
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.lightPurple,
        unselectedItemColor: AppColors.grey500,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Dialog theme for dark mode
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        elevation: 8,
        backgroundColor: AppColors.darkCard,
      ),
    );
  }

  /// Light color scheme
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryPurple,
    onPrimary: AppColors.white,
    secondary: AppColors.primaryGold,
    onSecondary: AppColors.white,
    tertiary: AppColors.lightPurple,
    onTertiary: AppColors.white,
    error: AppColors.error,
    onError: AppColors.white,
    surface: AppColors.white,
    onSurface: AppColors.grey900,
    surfaceContainerHighest: AppColors.grey100,
    onSurfaceVariant: AppColors.grey600,
    outline: AppColors.grey300,
  );

  /// Dark color scheme
  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.lightPurple,
    onPrimary: AppColors.white,
    secondary: AppColors.lightGold,
    onSecondary: AppColors.black,
    tertiary: AppColors.primaryGold,
    onTertiary: AppColors.black,
    error: AppColors.error,
    onError: AppColors.white,
    surface: AppColors.darkSurface,
    onSurface: AppColors.white,
    surfaceContainerHighest: AppColors.darkCard,
    onSurfaceVariant: AppColors.grey300,
    outline: AppColors.grey600,
  );

  /// Text styles for consistent typography
  static TextStyle get headingLarge => const TextStyle(
    fontFamily: AppConstants.primaryFont,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static TextStyle get headingMedium => const TextStyle(
    fontFamily: AppConstants.primaryFont,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
  );

  static TextStyle get headingSmall => const TextStyle(
    fontFamily: AppConstants.primaryFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get bodyLarge => const TextStyle(
    fontFamily: AppConstants.primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get bodyMedium => const TextStyle(
    fontFamily: AppConstants.primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle get caption => const TextStyle(
    fontFamily: AppConstants.primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.grey500,
  );

  static TextStyle get chineseText => const TextStyle(
    fontFamily: AppConstants.chineseFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get decorativeText => const TextStyle(
    fontFamily: AppConstants.decorativeFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
}

import 'package:astro_iztro/core/services/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// [LanguageService] - Manages app language and locale settings
/// Provides methods to change language and persist user preferences
/// Following clean architecture principles for service layer
class LanguageService extends GetxController {
  // Observable current locale
  final Rx<Locale> currentLocale = const Locale('en', 'US').obs;

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('tr', 'TR'), // Turkish
    Locale('zh', 'CN'), // Chinese Simplified
    Locale('ja', 'JP'), // Japanese
  ];

  // Language names for display
  static const Map<String, String> languageNames = {
    'en': 'English',
    'tr': 'Türkçe',
    'zh': '中文',
    'ja': '日本語',
  };

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  /// [loadSavedLanguage] - Load saved language preference from storage
  /// Falls back to English if no preference is saved
  Future<void> _loadSavedLanguage() async {
    try {
      final storageService = Get.find<StorageService>();
      final savedLanguage = storageService.loadLanguage();

      if (savedLanguage.isNotEmpty) {
        final locale = Locale(savedLanguage);
        if (supportedLocales.contains(locale)) {
          currentLocale.value = locale;
        }
      }
    } on Exception catch (e) {
      // If there's an error, keep default English locale
      if (kDebugMode) {
        print('[LanguageService] Error loading saved language: $e');
      }
    }
  }

  /// [changeLanguage] - Change app language and save preference
  /// Updates the current locale and persists the choice
  Future<void> changeLanguage(Locale locale) async {
    try {
      if (supportedLocales.contains(locale)) {
        currentLocale.value = locale;

        // Save to storage using StorageService
        final storageService = Get.find<StorageService>();
        await storageService.saveLanguage(locale.languageCode);

        // Update GetX locale
        await Get.updateLocale(locale);
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[LanguageService] Error changing language: $e');
      }
    }
  }

  /// [getCurrentLanguageName] - Get display name for current language
  String getCurrentLanguageName() {
    return languageNames[currentLocale.value.languageCode] ?? 'English';
  }

  /// [isCurrentLanguage] - Check if given locale is currently selected
  bool isCurrentLanguage(Locale locale) {
    return currentLocale.value.languageCode == locale.languageCode;
  }
}

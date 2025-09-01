import 'package:astro_iztro/core/services/storage_service.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// [SettingsController] - Manages app settings and preferences
class SettingsController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  // Reactive settings
  final RxString themeMode = 'system'.obs;
  final RxString languageCode = 'en'.obs;
  final RxBool useTrueSolarTime = true.obs;
  final RxBool showBrightness = true.obs;
  final RxBool showTransformations = true.obs;
  final RxBool preferTraditionalChinese = false.obs;
  final RxBool autoSaveCalculations = true.obs;
  final RxBool showAdvancedAnalysis = false.obs;
  final RxBool enableDetailedStarAnalysis = true.obs;
  final RxBool autoSavePalaceAnalysis = true.obs;
  final RxBool showTransformationEffects = true.obs;
  final RxBool enableFortuneTiming = true.obs;

  // Storage info
  final RxInt storageSize = 0.obs;
  final RxInt totalProfiles = 0.obs;
  final RxInt totalCalculations = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _updateStorageInfo();
  }

  /// [loadSettings] - Load all settings from storage
  Future<void> _loadSettings() async {
    try {
      final preferences = _storageService.loadCalculationPreferences();

      themeMode.value = _storageService.loadThemeMode();
      languageCode.value = _storageService.loadLanguage();

      useTrueSolarTime.value =
          preferences['use_true_solar_time'] as bool? ?? true;
      showBrightness.value = preferences['show_brightness'] as bool? ?? true;
      showTransformations.value =
          preferences['show_transformations'] as bool? ?? true;
      preferTraditionalChinese.value =
          preferences['prefer_traditional_chinese'] as bool? ?? false;
      autoSaveCalculations.value =
          preferences['auto_save_calculations'] as bool? ?? true;
      showAdvancedAnalysis.value =
          preferences['show_advanced_analysis'] as bool? ?? false;
      enableDetailedStarAnalysis.value =
          preferences['enable_detailed_star_analysis'] as bool? ?? true;
      autoSavePalaceAnalysis.value =
          preferences['auto_save_palace_analysis'] as bool? ?? true;
      showTransformationEffects.value =
          preferences['show_transformation_effects'] as bool? ?? true;
      enableFortuneTiming.value =
          preferences['enable_fortune_timing'] as bool? ?? true;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[SettingsController] Error loading settings: $e');
      }
    }
  }

  /// [updateStorageInfo] - Update storage information
  void _updateStorageInfo() {
    try {
      storageSize.value = _storageService.getStorageSize();
      totalProfiles.value = _storageService.loadUserProfiles().length;
      totalCalculations.value = _storageService.loadRecentCalculations().length;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[SettingsController] Error updating storage info: $e');
      }
    }
  }

  /// [setThemeMode] - Change theme mode
  Future<void> setThemeMode(String mode) async {
    try {
      themeMode.value = mode;
      await _storageService.saveThemeMode(mode);

      // Apply theme change
      switch (mode) {
        case 'light':
          Get.changeThemeMode(ThemeMode.light);
        case 'dark':
          Get.changeThemeMode(ThemeMode.dark);
        case 'system':
        default:
          Get.changeThemeMode(ThemeMode.system);
      }

      Get.snackbar(
        'Theme Updated',
        'Theme changed to $mode mode',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[SettingsController] Error setting theme: $e');
      }
    }
  }

  /// [setLanguage] - Change app language
  Future<void> setLanguage(String code) async {
    try {
      languageCode.value = code;
      await _storageService.saveLanguage(code);

      // Apply language change
      final locale = _getLocaleFromCode(code);
      await Get.updateLocale(locale);

      Get.snackbar(
        'Language Updated',
        'Language changed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[SettingsController] Error setting language: $e');
      }
    }
  }

  /// [saveCalculationPreferences] - Save calculation preferences
  Future<void> saveCalculationPreferences() async {
    try {
      final preferences = {
        'use_true_solar_time': useTrueSolarTime.value,
        'show_brightness': showBrightness.value,
        'show_transformations': showTransformations.value,
        'default_language': languageCode.value,
        'prefer_traditional_chinese': preferTraditionalChinese.value,
        'auto_save_calculations': autoSaveCalculations.value,
        'show_advanced_analysis': showAdvancedAnalysis.value,
        'enable_detailed_star_analysis': enableDetailedStarAnalysis.value,
        'auto_save_palace_analysis': autoSavePalaceAnalysis.value,
        'show_transformation_effects': showTransformationEffects.value,
        'enable_fortune_timing': enableFortuneTiming.value,
      };

      await _storageService.saveCalculationPreferences(preferences);

      Get.snackbar(
        'Settings Saved',
        'Calculation preferences saved successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[SettingsController] Error saving preferences: $e');
      }
      Get.snackbar(
        'Error',
        'Failed to save settings',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// [clearUserData] - Clear all user data
  Future<void> clearUserData() async {
    try {
      final result = await Get.dialog<bool?>(
        AlertDialog(
          title: const Text('Clear User Data'),
          content: const Text(
            'This will delete all profiles, calculations, and analysis data. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Clear All'),
            ),
          ],
        ),
      );

      if (result ?? false) {
        await _storageService.clearUserData();
        _updateStorageInfo();

        Get.snackbar(
          'Data Cleared',
          'All user data has been cleared',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[SettingsController] Error clearing user data: $e');
      }
      Get.snackbar(
        'Error',
        'Failed to clear user data',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// [exportUserData] - Export user data
  Future<void> exportUserData() async {
    try {
      final exportData = _storageService.exportUserData();

      // For now, just show the data in a dialog
      await Get.dialog<void>(
        AlertDialog(
          title: const Text('Export Data'),
          content: SingleChildScrollView(
            child: SelectableText(
              exportData,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back<void>(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[SettingsController] Error exporting data: $e');
      }
      Get.snackbar(
        'Error',
        'Failed to export data',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// [resetToDefaults] - Reset all settings to defaults
  Future<void> resetToDefaults() async {
    try {
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Reset Settings'),
          content: const Text(
            'This will reset all settings to their default values.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Reset'),
            ),
          ],
        ),
      );

      if (result ?? false) {
        // Reset to defaults
        themeMode.value = 'system';
        languageCode.value = 'en';
        useTrueSolarTime.value = true;
        showBrightness.value = true;
        showTransformations.value = true;
        preferTraditionalChinese.value = false;
        autoSaveCalculations.value = true;
        showAdvancedAnalysis.value = false;
        enableDetailedStarAnalysis.value = true;
        autoSavePalaceAnalysis.value = true;
        showTransformationEffects.value = true;
        enableFortuneTiming.value = true;

        // Save defaults
        await setThemeMode('system');
        await setLanguage('en');
        await saveCalculationPreferences();

        Get.snackbar(
          'Settings Reset',
          'All settings have been reset to defaults',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[SettingsController] Error resetting settings: $e');
      }
    }
  }

  /// Get locale from language code
  Locale _getLocaleFromCode(String code) {
    switch (code) {
      case 'zh':
        return const Locale('zh', 'CN');
      case 'ja':
        return const Locale('ja', 'JP');
      case 'ko':
        return const Locale('ko', 'KR');
      case 'th':
        return const Locale('th', 'TH');
      case 'vi':
        return const Locale('vi', 'VN');
      default:
        return const Locale('en', 'US');
    }
  }

  /// Format storage size for display
  String get formattedStorageSize {
    final bytes = storageSize.value;
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Get supported languages
  List<Map<String, String>> get supportedLanguages => [
    {'code': 'en', 'name': 'English'},
    {'code': 'zh', 'name': '中文'},
    {'code': 'ja', 'name': '日本語'},
    {'code': 'ko', 'name': '한국어'},
    {'code': 'th', 'name': 'ไทย'},
    {'code': 'vi', 'name': 'Tiếng Việt'},
  ];

  /// Get theme modes
  List<Map<String, String>> get themeModes => [
    {'code': 'system', 'name': 'System'},
    {'code': 'light', 'name': 'Light'},
    {'code': 'dark', 'name': 'Dark'},
  ];

  /// [resetOnboarding] - Reset onboarding status for testing
  /// This method allows users to see the onboarding again
  Future<void> resetOnboarding() async {
    try {
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Reset Onboarding'),
          content: const Text(
            'This will reset the onboarding status. You will see the onboarding screens again on the next app launch.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Reset'),
            ),
          ],
        ),
      );

      if (result ?? false) {
        await _storageService.resetOnboarding();
        Get.snackbar(
          'Onboarding Reset',
          'Onboarding has been reset. Restart the app to see it again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[SettingsController] Error resetting onboarding: $e');
      }
      Get.snackbar(
        'Error',
        'Failed to reset onboarding: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

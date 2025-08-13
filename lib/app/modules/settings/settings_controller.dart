import 'package:astro_iztro/core/services/storage_service.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// [SettingsController] - Controller for app settings and preferences
class SettingsController extends GetxController {
  // Services
  final StorageService _storageService = Get.find<StorageService>();

  // Theme and appearance
  final RxString selectedTheme = 'system'.obs;
  final RxString selectedLanguage = 'en'.obs;
  final RxBool useSystemTheme = true.obs;

  // Calculation preferences
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

  // Privacy and data
  final RxBool enableAnalytics = false.obs;
  final RxBool enableCrashReporting = true.obs;
  final RxBool enableDataBackup = true.obs;

  // Notification preferences
  final RxBool enableNotifications = true.obs;
  final RxBool enableDailyFortune = false.obs;
  final RxBool enableAnalysisReminders = true.obs;

  // Storage info
  final RxString storageSize = '0 B'.obs;
  final RxInt profileCount = 0.obs;
  final RxInt calculationCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _updateStorageInfo();
  }

  /// Load settings from storage
  void _loadSettings() {
    try {
      // Load theme and language
      selectedTheme.value = _storageService.loadThemeMode();
      selectedLanguage.value = _storageService.loadLanguage();

      // Load calculation preferences
      final prefs = _storageService.loadCalculationPreferences();
      useTrueSolarTime.value = prefs['use_true_solar_time'] as bool? ?? true;
      showBrightness.value = prefs['show_brightness'] as bool? ?? true;
      showTransformations.value =
          prefs['show_transformations'] as bool? ?? true;
      preferTraditionalChinese.value =
          prefs['prefer_traditional_chinese'] as bool? ?? false;
      autoSaveCalculations.value =
          prefs['auto_save_calculations'] as bool? ?? true;
      showAdvancedAnalysis.value =
          prefs['show_advanced_analysis'] as bool? ?? false;
      enableDetailedStarAnalysis.value =
          prefs['enable_detailed_star_analysis'] as bool? ?? true;
      autoSavePalaceAnalysis.value =
          prefs['auto_save_palace_analysis'] as bool? ?? true;
      showTransformationEffects.value =
          prefs['show_transformation_effects'] as bool? ?? true;
      enableFortuneTiming.value =
          prefs['enable_fortune_timing'] as bool? ?? true;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[SettingsController] Error loading settings: $e');
      }
    }
  }

  /// Update storage information
  void _updateStorageInfo() {
    try {
      final size = _storageService.getStorageSize();
      storageSize.value = _formatBytes(size);

      final profiles = _storageService.loadUserProfiles();
      profileCount.value = profiles.length;

      final calculations = _storageService.loadRecentCalculations();
      calculationCount.value = calculations.length;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[SettingsController] Error updating storage info: $e');
      }
    }
  }

  /// Change theme mode
  Future<void> changeTheme(String theme) async {
    try {
      selectedTheme.value = theme;
      await _storageService.saveThemeMode(theme);

      // Apply theme change
      switch (theme) {
        case 'light':
          Get.changeThemeMode(ThemeMode.light);
        case 'dark':
          Get.changeThemeMode(ThemeMode.dark);
        case 'system':
        default:
          Get.changeThemeMode(ThemeMode.system);
      }

      _showSuccessMessage('Theme updated');
    } on Exception catch (e) {
      _showErrorMessage('Failed to update theme: $e');
    }
  }

  /// Change language
  Future<void> changeLanguage(String languageCode) async {
    try {
      selectedLanguage.value = languageCode;
      await _storageService.saveLanguage(languageCode);

      // TODO: Update app locale
      // Get.updateLocale(Locale(languageCode));

      _showSuccessMessage('Language updated');
    } on Exception catch (e) {
      _showErrorMessage('Failed to update language: $e');
    }
  }

  /// Save calculation preferences
  Future<void> saveCalculationPreferences() async {
    try {
      final prefs = {
        'use_true_solar_time': useTrueSolarTime.value,
        'show_brightness': showBrightness.value,
        'show_transformations': showTransformations.value,
        'prefer_traditional_chinese': preferTraditionalChinese.value,
        'auto_save_calculations': autoSaveCalculations.value,
        'show_advanced_analysis': showAdvancedAnalysis.value,
        'enable_detailed_star_analysis': enableDetailedStarAnalysis.value,
        'auto_save_palace_analysis': autoSavePalaceAnalysis.value,
        'show_transformation_effects': showTransformationEffects.value,
        'enable_fortune_timing': enableFortuneTiming.value,
      };

      await _storageService.saveCalculationPreferences(prefs);
      _showSuccessMessage('Preferences saved');
    } on Exception catch (e) {
      _showErrorMessage('Failed to save preferences: $e');
    }
  }

  /// Clear user data
  Future<void> clearUserData() async {
    try {
      final confirm = await _showConfirmDialog(
        'Clear User Data',
        'This will delete all profiles and calculations. Are you sure?',
      );

      if (!confirm) return;

      await _storageService.clearUserData();
      _updateStorageInfo();
      _showSuccessMessage('User data cleared');
    } on Exception catch (e) {
      _showErrorMessage('Failed to clear user data: $e');
    }
  }

  /// Clear all app data
  Future<void> clearAllData() async {
    try {
      final confirm = await _showConfirmDialog(
        'Clear All Data',
        'This will reset the app to its initial state. All data will be lost. Are you sure?',
      );

      if (!confirm) return;

      await _storageService.clearAppData();
      _loadSettings(); // Reload default settings
      _updateStorageInfo();
      _showSuccessMessage('All data cleared');
    } on Exception catch (e) {
      _showErrorMessage('Failed to clear all data: $e');
    }
  }

  /// Export user data
  Future<void> exportUserData() async {
    try {
      final data = _storageService.exportUserData();

      // TODO: Implement actual export functionality
      _showSuccessMessage('Export feature coming soon');

      if (kDebugMode) {
        print('[SettingsController] Export data length: ${data.length}');
      }
    } on Exception catch (e) {
      _showErrorMessage('Failed to export data: $e');
    }
  }

  /// Import user data
  Future<void> importUserData(String jsonData) async {
    try {
      await _storageService.importUserData(jsonData);
      _loadSettings();
      _updateStorageInfo();
      _showSuccessMessage('Data imported successfully');
    } on Exception catch (e) {
      _showErrorMessage('Failed to import data: $e');
    }
  }

  /// Reset to default settings
  Future<void> resetToDefaults() async {
    try {
      final confirm = await _showConfirmDialog(
        'Reset Settings',
        'This will reset all settings to their default values. Continue?',
      );

      if (!confirm) return;

      // Reset all settings to defaults
      selectedTheme.value = 'system';
      selectedLanguage.value = 'en';
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
      await changeTheme('system');
      await changeLanguage('en');
      await saveCalculationPreferences();

      _showSuccessMessage('Settings reset to defaults');
    } on Exception catch (e) {
      _showErrorMessage('Failed to reset settings: $e');
    }
  }

  /// Show app info dialog
  void showAppInfo() {
    Get.dialog<void>(
      AlertDialog(
        title: const Text('About Astro Iztro'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('Purple Star Astrology & BaZi Analysis'),
            SizedBox(height: 8),
            Text('Built with Flutter & dart_iztro'),
            SizedBox(height: 16),
            Text(
              'This app provides comprehensive Purple Star Astrology (Zi Wei Dou Shu) and Four Pillars BaZi analysis.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back<void>(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Helper methods
  void _showSuccessMessage(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _showErrorMessage(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  Future<bool> _showConfirmDialog(String title, String message) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Get language display name
  String getLanguageDisplayName(String code) {
    const languages = {
      'en': 'English',
      'zh': 'Chinese (Simplified)',
      'ja': 'Japanese',
      'ko': 'Korean',
      'th': 'Thai',
      'vi': 'Vietnamese',
    };
    return languages[code] ?? code;
  }

  /// Get theme display name
  String getThemeDisplayName(String theme) {
    const themes = {
      'system': 'System Default',
      'light': 'Light',
      'dark': 'Dark',
    };
    return themes[theme] ?? theme;
  }
}

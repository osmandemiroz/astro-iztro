import 'package:astro_iztro/core/models/bazi_data.dart';
import 'package:astro_iztro/core/models/chart_data.dart';
import 'package:astro_iztro/core/models/user_profile.dart';
import 'package:astro_iztro/core/services/iztro_service.dart';
import 'package:astro_iztro/core/services/storage_service.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';

/// [HomeController] - Main dashboard controller managing app state and navigation
/// Handles user profiles, recent calculations, and quick access features
class HomeController extends GetxController {
  // Services
  final StorageService _storageService = Get.find<StorageService>();
  final IztroService _iztroService = Get.find<IztroService>();

  // Reactive state variables
  final Rx<UserProfile?> currentProfile = Rx<UserProfile?>(null);
  final RxList<UserProfile> savedProfiles = <UserProfile>[].obs;
  final RxList<Map<String, dynamic>> recentCalculations =
      <Map<String, dynamic>>[].obs;
  final RxList<String> favoriteCharts = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedLanguage = 'en'.obs;
  final RxString selectedTheme = 'system'.obs;

  // Navigation tracking
  final RxInt selectedBottomNavIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // [HomeController.onInit] - Loading user data and preferences on app start
    _loadUserData();
    _loadAppPreferences();
  }

  /// [loadUserData] - Load all saved user data from storage
  Future<void> _loadUserData() async {
    try {
      isLoading.value = true;

      // Load current user profile
      final profile = _storageService.loadUserProfile();
      currentProfile.value = profile;

      // Load all saved profiles
      final profiles = _storageService.loadUserProfiles();
      savedProfiles.assignAll(profiles);

      // Load recent calculations
      final recent = _storageService.loadRecentCalculations();
      recentCalculations.assignAll(recent);

      // Load favorite charts
      final favorites = _storageService.loadFavoriteCharts();
      favoriteCharts.assignAll(favorites);

      if (kDebugMode) {
        print('[HomeController] Loaded user data successfully');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[HomeController] Error loading user data: $e');
      }
      Get.snackbar(
        'Error',
        'Failed to load user data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// [loadAppPreferences] - Load app preferences and settings
  Future<void> _loadAppPreferences() async {
    try {
      // Load language preference
      selectedLanguage.value = _storageService.loadLanguage();

      // Load theme preference
      selectedTheme.value = _storageService.loadThemeMode();

      if (kDebugMode) {
        print('[HomeController] Loaded app preferences successfully');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[HomeController] Error loading app preferences: $e');
      }
    }
  }

  /// [setCurrentProfile] - Set and save current user profile
  Future<void> setCurrentProfile(UserProfile profile) async {
    try {
      currentProfile.value = profile;
      await _storageService.saveUserProfile(profile);

      // Add to saved profiles if not already present
      if (!savedProfiles.any((p) => p.hashCode == profile.hashCode)) {
        savedProfiles.add(profile);
        await _storageService.saveUserProfiles(savedProfiles);
      }

      if (kDebugMode) {
        print(
          '[HomeController] Set current profile: ${profile.name ?? 'Unknown'}',
        );
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[HomeController] Error setting current profile: $e');
      }
      Get.snackbar(
        'Error',
        'Failed to save profile: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// [calculateChart] - Calculate and save Purple Star chart
  Future<ChartData?> calculateChart({UserProfile? profile}) async {
    try {
      isLoading.value = true;

      final targetProfile = profile ?? currentProfile.value;
      if (targetProfile == null) {
        throw Exception('No user profile available for calculation');
      }

      // Validate profile data
      if (!_iztroService.validateBirthData(targetProfile)) {
        throw Exception('Invalid birth data provided');
      }

      // Calculate chart
      final chartData = await _iztroService.calculateAstrolabe(targetProfile);

      // Save chart data
      final profileId = targetProfile.hashCode.toString();
      await _storageService.saveChartData(profileId, chartData);

      // Add to recent calculations
      await _addToRecentCalculations({
        'type': 'chart',
        'profile_id': profileId,
        'profile_name': targetProfile.name ?? 'Unknown',
        'calculated_at': DateTime.now().toIso8601String(),
        'birth_date': targetProfile.birthDate.toIso8601String(),
      });

      if (kDebugMode) {
        print(
          '[HomeController] Chart calculated successfully for ${targetProfile.name}',
        );
      }
      return chartData;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[HomeController] Error calculating chart: $e');
      }
      Get.snackbar(
        'Calculation Error',
        'Failed to calculate chart: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// [calculateBaZi] - Calculate and save BaZi chart
  Future<BaZiData?> calculateBaZi({UserProfile? profile}) async {
    try {
      isLoading.value = true;

      final targetProfile = profile ?? currentProfile.value;
      if (targetProfile == null) {
        throw Exception('No user profile available for calculation');
      }

      // Validate profile data
      if (!_iztroService.validateBirthData(targetProfile)) {
        throw Exception('Invalid birth data provided');
      }

      // Calculate BaZi
      final baziData = await _iztroService.calculateBaZi(targetProfile);

      // Save BaZi data
      final profileId = targetProfile.hashCode.toString();
      await _storageService.saveBaZiData(profileId, baziData);

      // Add to recent calculations
      await _addToRecentCalculations({
        'type': 'bazi',
        'profile_id': profileId,
        'profile_name': targetProfile.name ?? 'Unknown',
        'calculated_at': DateTime.now().toIso8601String(),
        'birth_date': targetProfile.birthDate.toIso8601String(),
      });

      if (kDebugMode) {
        print(
          '[HomeController] BaZi calculated successfully for ${targetProfile.name}',
        );
      }
      return baziData;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[HomeController] Error calculating BaZi: $e');
      }
      Get.snackbar(
        'Calculation Error',
        'Failed to calculate BaZi: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// [addToRecentCalculations] - Add calculation to recent history
  Future<void> _addToRecentCalculations(
    Map<String, dynamic> calculation,
  ) async {
    try {
      // Add to beginning of list
      recentCalculations.insert(0, calculation);

      // Keep only last 20 calculations
      if (recentCalculations.length > 20) {
        recentCalculations.removeRange(20, recentCalculations.length);
      }

      // Save to storage
      await _storageService.saveRecentCalculations(recentCalculations);
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[HomeController] Error saving recent calculation: $e');
      }
    }
  }

  /// [deleteProfile] - Delete a saved profile
  Future<void> deleteProfile(UserProfile profile) async {
    try {
      // Remove from saved profiles
      savedProfiles.removeWhere((p) => p.hashCode == profile.hashCode);
      await _storageService.saveUserProfiles(savedProfiles);

      // Clear current profile if it matches
      if (currentProfile.value?.hashCode == profile.hashCode) {
        currentProfile.value = null;
        await _storageService.clearUserData();
      }

      if (kDebugMode) {
        print('[HomeController] Profile deleted successfully');
      }
      Get.snackbar(
        'Profile Deleted',
        'Profile has been removed',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[HomeController] Error deleting profile: $e');
      }
      Get.snackbar(
        'Error',
        'Failed to delete profile: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// [toggleFavoriteChart] - Add/remove chart from favorites
  Future<void> toggleFavoriteChart(String chartId) async {
    try {
      if (favoriteCharts.contains(chartId)) {
        favoriteCharts.remove(chartId);
      } else {
        favoriteCharts.add(chartId);
      }

      await _storageService.saveFavoriteCharts(favoriteCharts);
      if (kDebugMode) {
        print('[HomeController] Favorite chart toggled: $chartId');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[HomeController] Error toggling favorite: $e');
      }
    }
  }

  /// [clearRecentCalculations] - Clear recent calculations history
  Future<void> clearRecentCalculations() async {
    try {
      recentCalculations.clear();
      await _storageService.saveRecentCalculations([]);

      Get.snackbar(
        'History Cleared',
        'Recent calculations have been cleared',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[HomeController] Error clearing recent calculations: $e');
      }
    }
  }

  /// [exportUserData] - Export all user data
  String exportUserData() {
    try {
      return _storageService.exportUserData();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[HomeController] Error exporting data: $e');
      }
      Get.snackbar(
        'Export Error',
        'Failed to export data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return '';
    }
  }

  /// [importUserData] - Import user data from JSON
  Future<bool> importUserData(String jsonData) async {
    try {
      final success = await _storageService.importUserData(jsonData);
      if (success) {
        // Reload all data
        await _loadUserData();
        await _loadAppPreferences();

        Get.snackbar(
          'Import Successful',
          'Data has been imported successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return success;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[HomeController] Error importing data: $e');
      }
      Get.snackbar(
        'Import Error',
        'Failed to import data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  /// [refreshData] - Refresh all user data
  Future<void> refreshData() async {
    await _loadUserData();
    await _loadAppPreferences();
  }

  /// [navigateToInput] - Navigate to input screen
  void navigateToInput() {
    Get.toNamed<void>('/input');
  }

  /// [navigateToChart] - Navigate to chart screen
  void navigateToChart() {
    if (currentProfile.value != null) {
      Get.toNamed<void>('/chart');
    } else {
      Get.snackbar(
        'No Profile',
        'Please create a profile first',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// [navigateToBaZi] - Navigate to BaZi screen
  void navigateToBaZi() {
    if (currentProfile.value != null) {
      Get.toNamed<void>('/bazi');
    } else {
      Get.snackbar(
        'No Profile',
        'Please create a profile first',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// [navigateToAnalysis] - Navigate to analysis screen
  void navigateToAnalysis() {
    if (currentProfile.value != null) {
      Get.toNamed<void>('/analysis');
    } else {
      Get.snackbar(
        'No Profile',
        'Please create a profile first',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// [navigateToSettings] - Navigate to settings screen
  void navigateToSettings() {
    Get.toNamed<void>('/settings');
  }

  /// [setBottomNavIndex] - Set bottom navigation index
  void setBottomNavIndex(int index) {
    if (index < 0 || index > 3) {
      return;
    }
    selectedBottomNavIndex.value = index;
  }

  /// Getters for computed values
  bool get hasCurrentProfile => currentProfile.value != null;
  bool get hasRecentCalculations => recentCalculations.isNotEmpty;
  bool get hasSavedProfiles => savedProfiles.isNotEmpty;
  int get storageSize => _storageService.getStorageSize();
}

// ignore_for_file: inference_failure_on_function_invocation, document_ignores

import 'package:astro_iztro/core/models/user_profile.dart';
import 'package:astro_iztro/core/services/iztro_service.dart';
import 'package:astro_iztro/core/services/storage_service.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// [AstroMatcherController] - Controller for Astro Matcher compatibility analysis
/// Manages profile selection, compatibility calculations, and result display
class AstroMatcherController extends GetxController {
  // Services
  final StorageService _storageService = Get.find<StorageService>();
  final IztroService _iztroService = Get.find<IztroService>();

  // Reactive state variables
  final Rx<UserProfile?> selectedProfile1 = Rx<UserProfile?>(null);
  final Rx<UserProfile?> selectedProfile2 = Rx<UserProfile?>(null);
  final RxList<UserProfile> availableProfiles = <UserProfile>[].obs;
  final Rx<Map<String, dynamic>?> compatibilityResult =
      Rx<Map<String, dynamic>?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasResult = false.obs;
  final RxString errorMessage = ''.obs;

  // Future insights (trends and timing)
  final Rx<Map<String, dynamic>?> trendData = Rx<Map<String, dynamic>?>(null);
  final Rx<Map<String, dynamic>?> timingData = Rx<Map<String, dynamic>?>(null);
  final RxInt trendStartYear = DateTime.now().year.obs;
  final RxInt trendEndYear = (DateTime.now().year + 5).obs;

  @override
  void onInit() {
    super.onInit();
    // [AstroMatcherController.onInit] - Loading available profiles on module initialization
    _loadAvailableProfiles();
  }

  @override
  void onReady() {
    super.onReady();
    // [AstroMatcherController.onReady] - Refresh profiles when screen becomes ready
    // This ensures we have the latest profiles when returning from other screens
    _refreshAvailableProfiles();
  }

  /// [loadAvailableProfiles] - Load all available user profiles for selection
  Future<void> _loadAvailableProfiles() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Load current user profile and set it as Profile 1 (this should never change)
      final currentProfile = _storageService.loadUserProfile();
      if (currentProfile != null) {
        selectedProfile1.value = currentProfile;
        if (kDebugMode) {
          print(
            '[AstroMatcherController] Set current profile as Profile 1: ${currentProfile.name ?? 'Unknown'}',
          );
        }
      }

      // Load all saved profiles for Profile 2 selection (excluding current profile)
      final allProfiles = _storageService.loadUserProfiles();
      final otherProfiles = allProfiles
          .where((profile) => profile.hashCode != currentProfile?.hashCode)
          .toList();

      availableProfiles.assignAll(otherProfiles);

      if (kDebugMode) {
        print(
          '[AstroMatcherController] Loaded ${otherProfiles.length} other profiles for Profile 2 selection',
        );
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AstroMatcherController] Error loading profiles: $e');
      }
      errorMessage.value = 'Failed to load profiles: $e';
      Get.snackbar(
        'Error',
        'Failed to load profiles: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// [setProfile2] - Set the second profile for compatibility analysis
  void setProfile2(UserProfile profile) {
    try {
      selectedProfile2.value = profile;

      if (kDebugMode) {
        print(
          '[AstroMatcherController] Set profile 2: ${profile.name ?? 'Unknown'}',
        );
      }

      // Clear previous results when profiles change
      _clearResults();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AstroMatcherController] Error setting profile 2: $e');
      }
      errorMessage.value = 'Failed to set profile 2: $e';
    }
  }

  /// [calculateCompatibility] - Calculate compatibility between selected profiles
  Future<void> calculateCompatibility() async {
    try {
      // Validate profile selection
      if (selectedProfile1.value == null || selectedProfile2.value == null) {
        errorMessage.value =
            'Please select both profiles for compatibility analysis';
        Get.snackbar(
          'Error',
          'Please select both profiles for compatibility analysis',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Check if profiles are different
      if (selectedProfile1.value == selectedProfile2.value) {
        errorMessage.value =
            'Please select different profiles for compatibility analysis';
        Get.snackbar(
          'Error',
          'Please select different profiles for compatibility analysis',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      isLoading.value = true;
      errorMessage.value = '';
      hasResult.value = false;

      if (kDebugMode) {
        print('[AstroMatcherController] Starting compatibility calculation...');
        print('  Profile 1: ${selectedProfile1.value!.name ?? 'Unknown'}');
        print('  Profile 2: ${selectedProfile2.value!.name ?? 'Unknown'}');
      }

      // Calculate compatibility using the IztroService
      final result = await _iztroService.calculateAstroCompatibility(
        selectedProfile1.value!,
        selectedProfile2.value!,
      );

      // Store the result
      compatibilityResult.value = result;
      hasResult.value = true;

      if (kDebugMode) {
        print(
          '[AstroMatcherController] Compatibility calculation completed successfully',
        );
        print('  Overall Score: ${result['overallScore']}%');
      }

      // Save to recent calculations
      await _saveToRecentCalculations(result);

      // Kick off future insights calculation (non-blocking)
      // [calculateCompatibility] -> computeFutureInsights
      // This enhances UX by presenting upcoming-year trends without changing core flow
      // ignore: unawaited_futures
      computeFutureInsights();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AstroMatcherController] Error calculating compatibility: $e');
      }
      errorMessage.value = 'Failed to calculate compatibility: $e';
      Get.snackbar(
        'Error',
        'Failed to calculate compatibility: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// [_saveToRecentCalculations] - Save compatibility result to recent calculations
  Future<void> _saveToRecentCalculations(Map<String, dynamic> result) async {
    try {
      final calculation = {
        'type': 'compatibility',
        'profile1_name': selectedProfile1.value?.name ?? 'Unknown',
        'profile2_name': selectedProfile2.value?.name ?? 'Unknown',
        'overall_score': result['overallScore'],
        'calculated_at': DateTime.now().toIso8601String(),
      };

      // Load existing recent calculations
      final recent = _storageService.loadRecentCalculations()
        ..insert(0, calculation);

      // Keep only last 20 calculations
      if (recent.length > 20) {
        recent.removeRange(20, recent.length);
      }

      // Save updated recent calculations
      await _storageService.saveRecentCalculations(recent);

      if (kDebugMode) {
        print(
          '[AstroMatcherController] Saved compatibility result to recent calculations',
        );
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(
          '[AstroMatcherController] Error saving to recent calculations: $e',
        );
      }
      // Don't show error to user for this non-critical operation
    }
  }

  /// [clearResults] - Clear current compatibility results
  void clearResults() {
    _clearResults();
  }

  /// [_clearResults] - Internal method to clear results
  void _clearResults() {
    compatibilityResult.value = null;
    hasResult.value = false;
    errorMessage.value = '';
    trendData.value = null;
    timingData.value = null;
  }

  /// [getCompatibilityScore] - Get formatted compatibility score
  String getCompatibilityScore() {
    final result = compatibilityResult.value;
    if (result == null) return 'N/A';

    final score = result['overallScore'] as double? ?? 0.0;
    return '${score.toStringAsFixed(1)}%';
  }

  /// [getCompatibilitySummary] - Get compatibility summary
  String getCompatibilitySummary() {
    final result = compatibilityResult.value;
    if (result == null) return 'No analysis available';

    final analysis = result['analysis'] as Map<String, dynamic>?;
    if (analysis == null) return 'No analysis available';

    return analysis['summary'] as String? ?? 'No summary available';
  }

  /// [getCompatibilityAnalysis] - Get detailed compatibility analysis
  Map<String, dynamic>? getCompatibilityAnalysis() {
    final result = compatibilityResult.value;
    if (result == null) return null;

    return result['analysis'] as Map<String, dynamic>?;
  }

  /// [getRecommendations] - Get compatibility recommendations
  List<String> getRecommendations() {
    final result = compatibilityResult.value;
    if (result == null) return [];

    final recommendations = result['recommendations'] as List<dynamic>?;
    if (recommendations == null) return [];

    return recommendations.map((r) => r.toString()).toList();
  }

  /// [canCalculate] - Check if compatibility can be calculated
  bool get canCalculate {
    return selectedProfile1.value != null &&
        selectedProfile2.value != null &&
        selectedProfile1.value != selectedProfile2.value;
  }

  /// [computeFutureInsights] - Calculate future-oriented insights (trends and timing)
  Future<void> computeFutureInsights() async {
    if (selectedProfile1.value == null || selectedProfile2.value == null) {
      return;
    }
    try {
      final start = DateTime.now().year;
      final end = start + 5;
      trendStartYear.value = start;
      trendEndYear.value = end;

      if (kDebugMode) {
        print(
          '[AstroMatcherController.computeFutureInsights] start=$start end=$end',
        );
      }

      final trends = await _iztroService.analyzeCompatibilityTrends(
        selectedProfile1.value!,
        selectedProfile2.value!,
        start,
        end,
      );
      trendData.value = trends;

      final timing = await _iztroService.calculateRelationshipTiming(
        selectedProfile1.value!,
        selectedProfile2.value!,
        start,
      );
      timingData.value = timing;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AstroMatcherController] Future insights error: $e');
      }
      // Soft-fail; keep compatibility result visible even if insights fail
    }
  }

  /// [getYearlyScores] - Extract year->score map from trend data in a typed way
  Map<int, double> getYearlyScores() {
    final data = trendData.value;
    if (data == null) return {};
    final raw = data['yearlyScores'];
    if (raw is Map) {
      return raw.map((key, value) {
        final year = int.tryParse(key.toString()) ?? 0;
        final score = (value as num).toDouble();
        return MapEntry(year, score);
      });
    }
    return {};
  }

  /// [getYearBreakdown] - Get full breakdown for a given year (scores, reasons)
  Map<String, dynamic>? getYearBreakdown(int year) {
    final data = trendData.value;
    if (data == null) return null;
    final map = data['yearlyBreakdown'];
    if (map is Map) {
      final entry = map['$year'];
      if (entry is Map) return entry.cast<String, dynamic>();
    }
    return null;
  }

  /// [getPredictionLabel] - Short prediction text for UI
  String getPredictionLabel() {
    final pred = trendData.value?['predictions'] as Map?;
    final p = pred?.cast<String, dynamic>();
    final text = p?['prediction']?.toString();
    final confidence = p?['confidence']?.toString();
    if (text == null) return 'No prediction available';
    return confidence == null ? text : '$text • $confidence confidence';
  }

  /// [_refreshAvailableProfiles] - Refresh available profiles for Profile 2 selection
  Future<void> _refreshAvailableProfiles() async {
    try {
      // Get current profile to maintain Profile 1
      final currentProfile = _storageService.loadUserProfile();

      // Load all saved profiles for Profile 2 selection (excluding current profile)
      final allProfiles = _storageService.loadUserProfiles();
      final otherProfiles = allProfiles
          .where((profile) => profile.hashCode != currentProfile?.hashCode)
          .toList();

      availableProfiles.assignAll(otherProfiles);

      if (kDebugMode) {
        print(
          '[AstroMatcherController] Refreshed available profiles: ${otherProfiles.length} profiles',
        );
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AstroMatcherController] Error refreshing profiles: $e');
      }
    }
  }

  /// [refreshProfiles] - Public method to refresh available profiles
  Future<void> refreshProfiles() async {
    await _refreshAvailableProfiles();
  }

  /// [navigateToInput] - Navigate to input screen to create new profile for other person
  Future<void> navigateToInput() async {
    try {
      // Navigate to input screen and wait for result
      // We need to pass a parameter to indicate this is for creating a profile for someone else
      final result = await Get.toNamed(
        '/input',
        arguments: {'isForOtherPerson': true},
      );

      // If we returned from input screen with a new profile, handle it
      if (result != null && result is UserProfile) {
        if (kDebugMode) {
          print(
            '[AstroMatcherController] New profile created for other person: ${result.name ?? 'Unknown'}',
          );
        }

        // Check if this is a different profile from the current one
        final currentProfile = _storageService.loadUserProfile();
        if (currentProfile != null &&
            result.hashCode != currentProfile.hashCode) {
          // Add the new profile to available profiles for Profile 2 selection
          if (!availableProfiles.any(
            (profile) => profile.hashCode == result.hashCode,
          )) {
            availableProfiles.add(result);
            if (kDebugMode) {
              print(
                '[AstroMatcherController] Added new profile to available profiles',
              );
            }
          }

          // Automatically select the new profile as Profile 2
          selectedProfile2.value = result;
          if (kDebugMode) {
            print(
              '[AstroMatcherController] Auto-selected new profile as Profile 2',
            );
          }

          // Clear any previous results since we have a new profile
          _clearResults();

          // Show success message
          Get.snackbar(
            'Profile Added',
            'New profile "${result.name ?? 'Unknown'}" has been added and selected for compatibility analysis',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          // Show error if trying to create a profile that's the same as current user
          Get.snackbar(
            'Error',
            'Cannot create a profile with the same details as your current profile',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AstroMatcherController] Error navigating to input: $e');
      }
    }
  }

  /// [navigateBack] - Navigate back to previous screen
  void navigateBack() {
    try {
      Get.back<UserProfile?>();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AstroMatcherController] Error navigating back: $e');
      }
    }
  }
}

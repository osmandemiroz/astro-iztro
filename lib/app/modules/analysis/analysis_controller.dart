// ignore_for_file: unused_local_variable, document_ignores

import 'package:astro_iztro/core/models/bazi_data.dart';
import 'package:astro_iztro/core/models/chart_data.dart';
import 'package:astro_iztro/core/models/user_profile.dart';
import 'package:astro_iztro/core/services/iztro_service.dart';
import 'package:astro_iztro/core/services/storage_service.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// [AnalysisController] - Controller for detailed astrological analysis
/// Manages combined Purple Star and BaZi analysis with fortune timing
class AnalysisController extends GetxController {
  // Services
  final StorageService _storageService = Get.find<StorageService>();
  final IztroService _iztroService = Get.find<IztroService>();

  // Reactive state
  final Rx<ChartData?> chartData = Rx<ChartData?>(null);
  final Rx<BaZiData?> baziData = Rx<BaZiData?>(null);
  final Rx<UserProfile?> currentProfile = Rx<UserProfile?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isCalculating = false.obs;
  final RxInt selectedYear = DateTime.now().year.obs;
  final RxString selectedAnalysisType = 'yearly'.obs;
  final Rx<Map<String, dynamic>?> fortuneData = Rx<Map<String, dynamic>?>(null);

  // Display options
  final RxString displayLanguage = 'en'.obs;
  final RxBool showChineseNames = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
    _loadAnalysisData();
  }

  /// [loadUserProfile] - Load current user profile
  Future<void> _loadUserProfile() async {
    try {
      final profile = _storageService.loadUserProfile();
      currentProfile.value = profile;
      displayLanguage.value = profile?.languageCode ?? 'en';
      showChineseNames.value = profile?.useTraditionalChinese ?? false;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AnalysisController] Error loading user profile: $e');
      }
    }
  }

  /// [loadAnalysisData] - Load chart and BaZi data
  Future<void> _loadAnalysisData() async {
    if (currentProfile.value == null) return;

    try {
      isLoading.value = true;

      // Load chart data
      final profileId = currentProfile.value!.hashCode.toString();
      final existingChartData = _storageService.loadChartDataJson(profileId);
      final existingBaZiData = _storageService.loadBaZiData(profileId);

      if (existingChartData != null && existingBaZiData != null) {
        // Recreate ChartData from JSON
        chartData.value = ChartData.fromJson(
          existingChartData,
          <String, dynamic>{},
        );
        baziData.value = existingBaZiData;
        if (kDebugMode) {
          print('[AnalysisController] Found existing analysis data');
        }
      } else {
        // Calculate new data
        await calculateAnalysis();
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AnalysisController] Error loading analysis data: $e');
      }
      Get.snackbar(
        'Error',
        'Failed to load analysis data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// [calculateAnalysis] - Calculate both chart and BaZi data
  Future<void> calculateAnalysis() async {
    if (currentProfile.value == null) {
      Get.snackbar(
        'No Profile',
        'Please create a profile first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isCalculating.value = true;

      // Calculate both chart and BaZi
      final chart = await _iztroService.calculateAstrolabe(
        currentProfile.value!,
      );
      final bazi = await _iztroService.calculateBaZi(currentProfile.value!);

      chartData.value = chart;
      baziData.value = bazi;

      if (kDebugMode) {
        print('[AnalysisController] Analysis calculated successfully');
      }
      Get.snackbar(
        'Success',
        'Analysis calculated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AnalysisController] Error calculating analysis: $e');
      }
      Get.snackbar(
        'Calculation Error',
        'Failed to calculate analysis: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isCalculating.value = false;
    }
  }

  /// [calculateFortuneForYear] - Calculate fortune for specific year using native engines
  Future<Map<String, dynamic>> calculateFortuneForYear(int year) async {
    if (currentProfile.value == null) {
      throw Exception('No user profile available');
    }

    try {
      if (kDebugMode) {
        print(
          '[AnalysisController] Calculating fortune for year $year using native engines...',
        );
      }

      // Use native IztroService to get comprehensive fortune data
      final fortuneData = await _iztroService.calculateFortuneForYear(
        currentProfile.value!,
        year,
      );

      if (kDebugMode) {
        print(
          '[AnalysisController] Fortune calculation completed: ${fortuneData['calculationMethod']}',
        );
      }

      return fortuneData;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AnalysisController] Error calculating fortune: $e');
      }
      rethrow;
    }
  }

  /// [calculateFortuneForSelectedYear] - Calculate fortune for the selected year
  Future<void> calculateFortuneForSelectedYear() async {
    if (currentProfile.value == null) {
      Get.snackbar(
        'No Profile',
        'Please create a profile first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isCalculating.value = true;
      final year = selectedYear.value;
      final fortuneData = await calculateFortuneForYear(year);
      this.fortuneData.value = fortuneData;

      if (kDebugMode) {
        print(
          '[AnalysisController] Fortune for year $year calculated successfully',
        );
      }
      Get.snackbar(
        'Success',
        'Fortune for year $year calculated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(
          '[AnalysisController] Error calculating fortune for selected year: $e',
        );
      }
      Get.snackbar(
        'Calculation Error',
        'Failed to calculate fortune for selected year: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isCalculating.value = false;
    }
  }

  /// [selectYear] - Select year for fortune analysis
  Future<void> selectYear(int year) async {
    selectedYear.value = year;
    // Clear previous fortune data when year changes
    fortuneData.value = null;
  }

  /// [selectAnalysisType] - Select analysis type (yearly/monthly/daily)
  void selectAnalysisType(String type) {
    if (type == selectedAnalysisType.value) return;
    selectedAnalysisType.value = type;
  }

  /// [toggleLanguage] - Toggle between English and Chinese names
  void toggleLanguage() {
    showChineseNames.value = !showChineseNames.value;
  }

  /// [refreshAnalysis] - Refresh all analysis data
  Future<void> refreshAnalysis() async {
    await calculateAnalysis();
  }

  /// [exportAnalysis] - Export analysis data (placeholder)
  Future<void> exportAnalysis() async {
    if (chartData.value == null || baziData.value == null) {
      Get.snackbar(
        'No Analysis Data',
        'Please calculate analysis first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // For now, just show success message
      Get.snackbar(
        'Export',
        'Analysis export feature coming soon!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.secondary,
        colorText: Get.theme.colorScheme.onSecondary,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AnalysisController] Error exporting analysis: $e');
      }
      Get.snackbar(
        'Export Error',
        'Failed to export analysis: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Getters for computed values
  bool get hasAnalysisData => chartData.value != null && baziData.value != null;
  String get analysisTitle =>
      showChineseNames.value ? '命盤分析' : 'Destiny Analysis';

  /// Get fortune cycle name based on language preference
  String getFortuneCycleName(String cycle) {
    final names = {
      'grand_limit': showChineseNames.value ? '大限' : 'Grand Limit',
      'small_limit': showChineseNames.value ? '小限' : 'Small Limit',
      'annual_fortune': showChineseNames.value ? '流年' : 'Annual Fortune',
      'monthly_fortune': showChineseNames.value ? '流月' : 'Monthly Fortune',
      'daily_fortune': showChineseNames.value ? '流日' : 'Daily Fortune',
    };
    return names[cycle] ?? cycle;
  }

  /// Get element color based on strength
  Color getElementColor(String element, double strength) {
    if (strength >= 0.8) return Colors.green;
    if (strength >= 0.6) return Colors.lightGreen;
    if (strength >= 0.4) return Colors.orange;
    if (strength >= 0.2) return Colors.red;
    return Colors.grey;
  }

  /// Get fortune strength description
  String getFortuneStrength(double value) {
    if (value >= 0.8) return 'Very Strong';
    if (value >= 0.6) return 'Strong';
    if (value >= 0.4) return 'Moderate';
    if (value >= 0.2) return 'Weak';
    return 'Very Weak';
  }

  /// [testNativeEngines] - Test the native calculation engines with current profile
  Future<void> testNativeEngines() async {
    if (currentProfile.value == null) {
      Get.snackbar(
        'No Profile',
        'Please create a profile first to test native engines',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      if (kDebugMode) {
        print('[AnalysisController] Testing native calculation engines...');
      }

      // Test native engines by calculating fortune for current year
      final currentYear = DateTime.now().year;
      final fortuneData = await _iztroService.calculateFortuneForYear(
        currentProfile.value!,
        currentYear,
      );

      // Test timing cycles
      final timingData = await _iztroService.calculateTimingCycles(
        currentProfile.value!,
        currentYear,
      );

      if (kDebugMode) {
        print('[AnalysisController] Native engine test completed successfully');
      }

      Get.snackbar(
        'Native Engines Test Successful! 🎉',
        'All native calculation engines working properly',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        duration: const Duration(seconds: 4),
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AnalysisController] Error testing native engines: $e');
      }
      Get.snackbar(
        'Native Engine Test Failed',
        'Error: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

import 'package:astro_iztro/core/models/chart_data.dart';
import 'package:astro_iztro/core/models/user_profile.dart';
import 'package:astro_iztro/core/services/iztro_service.dart';
import 'package:astro_iztro/core/services/storage_service.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// [ChartController] - Purple Star chart display and interaction controller
/// Manages chart data, palace selection, and chart visualization
class ChartController extends GetxController {
  // Services
  final StorageService _storageService = Get.find<StorageService>();
  final IztroService _iztroService = Get.find<IztroService>();

  // Reactive state
  final Rx<ChartData?> chartData = Rx<ChartData?>(null);
  final Rx<UserProfile?> currentProfile = Rx<UserProfile?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isCalculating = false.obs;
  final RxInt selectedPalaceIndex = (-1).obs;
  final RxBool showStarDetails = true.obs;
  final RxBool showTransformations = true.obs;
  final RxDouble chartScale = 1.0.obs;

  // Chart display options
  final RxString displayLanguage = 'en'.obs;
  final RxBool showChineseNames = false.obs;

  @override
  void onInit() {
    super.onInit();
    // [ChartController.onInit] - Loading user profile and chart data on initialization
    _loadUserProfile();
    _loadChartData();
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
        print('[ChartController] Error loading user profile: $e');
      }
    }
  }

  /// [loadChartData] - Load existing chart data or calculate new one
  Future<void> _loadChartData() async {
    if (currentProfile.value == null) return;

    try {
      isLoading.value = true;

      // Try to load existing chart data
      final profileId = currentProfile.value!.hashCode.toString();
      final existingData = _storageService.loadChartDataJson(profileId);

      if (existingData != null) {
        // Load from existing data (note: we'd need to recreate the astrolabe)
        if (kDebugMode) {
          print('[ChartController] Found existing chart data');
        }
        await calculateChart(); // For now, always recalculate
      } else {
        // Calculate new chart
        await calculateChart();
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[ChartController] Error loading chart data: $e');
      }
      Get.snackbar(
        'Error',
        'Failed to load chart data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// [calculateChart] - Calculate Purple Star chart for current profile
  Future<void> calculateChart() async {
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

      // Calculate chart using IztroService
      final chart = await _iztroService.calculateAstrolabe(
        currentProfile.value!,
      );
      chartData.value = chart;

      if (kDebugMode) {
        print('[ChartController] Chart calculated successfully');
      }
      Get.snackbar(
        'Success',
        'Chart calculated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[ChartController] Error calculating chart: $e');
      }
      Get.snackbar(
        'Calculation Error',
        'Failed to calculate chart: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isCalculating.value = false;
    }
  }

  /// [selectPalace] - Select a palace for detailed view
  void selectPalace(int palaceIndex) {
    if (palaceIndex == selectedPalaceIndex.value) {
      // Deselect if same palace clicked
      selectedPalaceIndex.value = -1;
    } else {
      selectedPalaceIndex.value = palaceIndex;
    }
  }

  /// [getSelectedPalace] - Get currently selected palace data
  PalaceData? getSelectedPalace() {
    if (selectedPalaceIndex.value == -1 || chartData.value == null) {
      return null;
    }

    return chartData.value!.getPalaceByIndex(selectedPalaceIndex.value);
  }

  /// [getStarsInSelectedPalace] - Get stars in currently selected palace
  List<StarData> getStarsInSelectedPalace() {
    final palace = getSelectedPalace();
    if (palace == null || chartData.value == null) return [];

    return chartData.value!.getStarsInPalace(palace.name);
  }

  /// [toggleStarDetails] - Toggle star detail display
  void toggleStarDetails() {
    showStarDetails.value = !showStarDetails.value;
  }

  /// [toggleTransformations] - Toggle transformation star display
  void toggleTransformations() {
    showTransformations.value = !showTransformations.value;
  }

  /// [toggleLanguage] - Toggle between English and Chinese names
  void toggleLanguage() {
    showChineseNames.value = !showChineseNames.value;
  }

  /// [zoomChart] - Zoom chart in/out
  void zoomChart(double delta) {
    final newScale = (chartScale.value + delta).clamp(0.5, 2.0);
    chartScale.value = newScale;
  }

  /// [resetZoom] - Reset chart zoom to default
  void resetZoom() {
    chartScale.value = 1.0;
  }

  /// [refreshChart] - Refresh chart data
  Future<void> refreshChart() async {
    selectedPalaceIndex.value = -1; // Clear selection
    await calculateChart();
  }

  /// [navigateToAnalysis] - Navigate to detailed analysis screen
  void navigateToAnalysis() {
    if (chartData.value != null) {
      Get.toNamed<void>('/analysis');
    } else {
      Get.snackbar(
        'No Chart Data',
        'Please calculate chart first',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// [exportChart] - Export chart data (placeholder)
  Future<void> exportChart() async {
    if (chartData.value == null) {
      Get.snackbar(
        'No Chart Data',
        'Please calculate chart first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // For now, just show success message
      // In the future, this would export to PDF or image
      Get.snackbar(
        'Export',
        'Chart export feature coming soon!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.secondary,
        colorText: Get.theme.colorScheme.onSecondary,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[ChartController] Error exporting chart: $e');
      }
      Get.snackbar(
        'Export Error',
        'Failed to export chart: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Getters for computed values
  bool get hasChartData => chartData.value != null;
  bool get hasSelectedPalace => selectedPalaceIndex.value != -1;
  String get chartTitle =>
      showChineseNames.value ? '紫微斗數命盤' : 'Purple Star Chart';

  /// Get palace name based on language preference
  String getPalaceName(PalaceData palace) {
    return showChineseNames.value ? palace.nameZh : palace.name;
  }

  /// Get star name based on language preference
  String getStarName(StarData star) {
    return showChineseNames.value ? star.name : star.nameEn;
  }

  /// [showChartExplanation] - Present how the chart was calculated and what it means
  /// Opens a bottom sheet aligned with our app's visual language and Apple HIG
  void showChartExplanation() {
    if (chartData.value == null) {
      Get.snackbar(
        'No Chart Data',
        'Please calculate chart first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final data = chartData.value!;

    Get.bottomSheet<void>(
      SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.surface.withValues(alpha: 0.98),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.onSurface.withValues(
                        alpha: 0.2,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'How this Purple Star chart was calculated',
                  style: Get.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Inputs used',
                  style: Get.textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                _bullet('Birth date/time: ${data.birthDate.toLocal()}'),
                _bullet('Gender: ${data.gender}'),
                _bullet(
                  'Location: ${data.latitude.toStringAsFixed(4)}, ${data.longitude.toStringAsFixed(4)}',
                ),
                _bullet(
                  'Time standard: ${data.useTrueSolarTime ? 'True Solar Time' : 'Standard Time'}',
                ),
                const SizedBox(height: 12),
                Text(
                  'Computation steps',
                  style: Get.textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                _bullet(
                  'Convert birth data to lunar calendrics and establish the astrolabe baseline.',
                ),
                _bullet(
                  'Determine 12 palaces (Life, Siblings, Spouse, etc.) and their order starting from the Life palace.',
                ),
                _bullet(
                  'Place major stars and auxiliaries into palaces based on birth hour/day/month/year rules.',
                ),
                _bullet(
                  'Apply transformation stars (Lu, Quan, Ke, Ji) and compute fortune periods.',
                ),
                const SizedBox(height: 12),
                Text(
                  'What it means',
                  style: Get.textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                _bullet(
                  'Each labeled sector is a palace describing a life domain; highlighted stars modify its tone.',
                ),
                _bullet(
                  'Gold accents indicate emphasis or selection; dots represent stars within that palace.',
                ),
                _bullet(
                  'Use the Meaning cards below for quick reference of each palace.',
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _chip('Palaces: ${data.palaces.length}'),
                    _chip('Stars: ${data.stars.length}'),
                    _chip('Major stars: ${data.majorStars.length}'),
                    _chip('Calculated at: ${data.calculatedAt.toLocal()}'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // Small helpers for consistent bullets and chips
  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Get.theme.colorScheme.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Text(
        label,
        style: Get.textTheme.bodySmall,
      ),
    );
  }
}

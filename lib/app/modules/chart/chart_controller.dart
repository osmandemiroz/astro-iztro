import 'package:astro_iztro/core/constants/colors.dart';
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

  /// [showChartExplanation] - Present user-friendly explanation of chart properties and star meanings
  /// Opens a beautiful bottom sheet explaining how the chart works and what colors mean
  void showChartExplanation() {
    if (chartData.value == null) {
      Get.snackbar(
        'No Chart Data',
        'Please calculate chart first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.bottomSheet<void>(
      SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.darkCard.withValues(alpha: 0.98),
                AppColors.darkCardSecondary.withValues(alpha: 0.95),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: AppColors.lightPurple.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.3),
                blurRadius: 30,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close button and drag handle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Close button
                    GestureDetector(
                      onTap: () => Get.back<void>(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.lightPurple.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppColors.lightPurple,
                          size: 20,
                        ),
                      ),
                    ),
                    // Drag handle
                    Container(
                      width: 48,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.lightPurple.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    // Spacer to balance the layout
                    const SizedBox(width: 36),
                  ],
                ),
                const SizedBox(height: 20),

                // Main title with cosmic styling
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.lightPurple.withValues(alpha: 0.1),
                        AppColors.lightGold.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.lightPurple.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        size: 32,
                        color: AppColors.lightGold,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Understanding Your Purple Star Chart',
                        style: Get.textTheme.headlineSmall?.copyWith(
                          color: AppColors.lightGold,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Discover how the stars influence your life path',
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: AppColors.darkTextSecondary,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Star Colors Section
                _buildSectionHeader(
                  'What Star Colors Mean',
                  Icons.palette_rounded,
                  AppColors.lightGold,
                ),
                const SizedBox(height: 16),

                // Star color explanations
                _buildStarColorCard(
                  'Purple Stars',
                  'Major Influences',
                  'These are your primary guiding stars that shape your core personality and life direction. They represent the strongest astrological forces in your chart.',
                  AppColors.lightPurple,
                ),
                const SizedBox(height: 12),

                _buildStarColorCard(
                  'Gold Stars',
                  'Emphasis & Selection',
                  'Gold indicates areas of special focus or selection in your chart. These are highlighted aspects that deserve extra attention in your life.',
                  AppColors.lightGold,
                ),
                const SizedBox(height: 12),

                _buildStarColorCard(
                  'Green Stars',
                  'Supportive Influences',
                  'Green represents supportive and harmonious energies that help balance and enhance the areas they influence.',
                  Colors.green,
                ),
                const SizedBox(height: 12),

                _buildStarColorCard(
                  'Red Stars',
                  'Challenging Influences',
                  'Red indicates areas that may present challenges or require extra effort, but also opportunities for growth and transformation.',
                  Colors.red,
                ),
                const SizedBox(height: 12),

                _buildStarColorCard(
                  'Orange Stars',
                  'Dynamic Energies',
                  'Orange represents dynamic, active energies that bring movement and change to the areas they influence.',
                  Colors.orange,
                ),
                const SizedBox(height: 12),

                _buildStarColorCard(
                  'Yellow Stars',
                  'Illumination & Wisdom',
                  'Yellow represents wisdom, clarity, and spiritual insight that illuminates your understanding of these life areas.',
                  Colors.yellow,
                ),

                const SizedBox(height: 24),

                // Chart Properties Section
                _buildSectionHeader(
                  'How Properties Are Calculated',
                  Icons.calculate_rounded,
                  AppColors.lightPurple,
                ),
                const SizedBox(height: 16),

                // Calculation explanation cards
                _buildCalculationCard(
                  'Birth Data Analysis',
                  'Your birth date, time, and location are converted to precise astronomical coordinates and lunar calendar dates.',
                  Icons.calendar_today_rounded,
                ),
                const SizedBox(height: 12),

                _buildCalculationCard(
                  'Palace Determination',
                  '12 life areas (palaces) are calculated based on your birth hour, creating a complete life blueprint from the Life Palace outward.',
                  Icons.grid_on_rounded,
                ),
                const SizedBox(height: 12),

                _buildCalculationCard(
                  'Star Placement',
                  'Major and minor stars are placed in palaces using ancient formulas based on your birth year, month, day, and hour.',
                  Icons.star_rounded,
                ),
                const SizedBox(height: 12),

                _buildCalculationCard(
                  'Transformation Stars',
                  'Special transformation stars (Lu, Quan, Ke, Ji) are calculated to show periods of change and fortune in your life.',
                  Icons.transform_rounded,
                ),

                const SizedBox(height: 24),

                // Personal Characteristics Section
                _buildSectionHeader(
                  'How You Are Calculated',
                  Icons.person_rounded,
                  AppColors.lightGold,
                ),
                const SizedBox(height: 16),

                // Personal characteristics explanation cards
                _buildPersonalCharacteristicCard(
                  'Core Personality',
                  'Your fundamental nature is determined by the stars in your Life Palace, calculated from your exact birth hour and the position of the Purple Star (Zi Wei). This creates your unique personality blueprint.',
                  Icons.psychology_rounded,
                ),
                const SizedBox(height: 12),

                _buildPersonalCharacteristicCard(
                  'Life Strengths',
                  'Your natural talents and abilities are revealed by the combination of major stars in different palaces, calculated using ancient formulas based on your birth year, month, and day.',
                  Icons.star_rounded,
                ),
                const SizedBox(height: 12),

                _buildPersonalCharacteristicCard(
                  'Life Challenges',
                  'Areas requiring growth are indicated by challenging star combinations and palace positions, calculated from your birth data and the relationships between different stars.',
                  Icons.trending_up_rounded,
                ),
                const SizedBox(height: 12),

                _buildPersonalCharacteristicCard(
                  'Destiny Path',
                  'Your life direction is mapped through the sequence of palaces and the transformation stars (Lu, Quan, Ke, Ji), revealing your unique journey through time.',
                  Icons.explore_rounded,
                ),

                const SizedBox(height: 24),

                // Interactive Elements Section
                _buildSectionHeader(
                  'How to Read Your Chart',
                  Icons.touch_app_rounded,
                  AppColors.lightGold,
                ),
                const SizedBox(height: 16),

                _buildInteractiveTipCard(
                  'Tap on any palace to see detailed information about that life area and the stars within it.',
                  Icons.touch_app_rounded,
                ),
                const SizedBox(height: 12),

                _buildInteractiveTipCard(
                  'Use the zoom controls to explore different parts of your chart in detail.',
                  Icons.zoom_in_rounded,
                ),
                const SizedBox(height: 12),

                _buildInteractiveTipCard(
                  'Toggle between English and Chinese names to explore traditional terminology.',
                  Icons.translate_rounded,
                ),

                const SizedBox(height: 24),

                // Chart Summary
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.lightPurple.withValues(alpha: 0.1),
                        AppColors.lightGold.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.lightPurple.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Your Chart Summary',
                        style: Get.textTheme.titleMedium?.copyWith(
                          color: AppColors.lightGold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildSummaryChip(
                            '${chartData.value!.palaces.length} Palaces',
                          ),
                          _buildSummaryChip(
                            '${chartData.value!.stars.length} Stars',
                          ),
                          _buildSummaryChip(
                            '${chartData.value!.majorStars.length} Major',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  /// [buildSectionHeader] - Beautiful section header with icon and color
  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Get.textTheme.titleLarge?.copyWith(
            color: AppColors.darkTextPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  /// [buildStarColorCard] - Beautiful card explaining star colors
  Widget _buildStarColorCard(
    String title,
    String subtitle,
    String description,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Color indicator
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Get.textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: AppColors.lightGold,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkTextSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// [buildCalculationCard] - Beautiful card explaining calculation steps
  Widget _buildCalculationCard(
    String title,
    String description,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightPurple.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.lightPurple.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.lightPurple,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Get.textTheme.titleMedium?.copyWith(
                    color: AppColors.darkTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkTextSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// [buildInteractiveTipCard] - Beautiful card with interactive tips
  Widget _buildInteractiveTipCard(String tip, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightGold.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.lightGold,
            size: 20,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              tip,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppColors.darkTextPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// [buildPersonalCharacteristicCard] - Beautiful card explaining personal characteristics
  Widget _buildPersonalCharacteristicCard(
    String title,
    String description,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightGold.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.lightGold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.lightGold,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Get.textTheme.titleMedium?.copyWith(
                    color: AppColors.lightGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkTextSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// [buildSummaryChip] - Beautiful summary chip
  Widget _buildSummaryChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightPurple.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightPurple.withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        label,
        style: Get.textTheme.bodyMedium?.copyWith(
          color: AppColors.lightPurple,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

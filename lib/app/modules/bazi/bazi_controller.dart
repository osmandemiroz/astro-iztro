import 'package:astro_iztro/core/models/bazi_data.dart';
import 'package:astro_iztro/core/models/user_profile.dart';
import 'package:astro_iztro/core/services/iztro_service.dart';
import 'package:astro_iztro/core/services/storage_service.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

/// [BaZiController] - Four Pillars BaZi analysis controller
/// Manages BaZi calculations, display, and element analysis
class BaZiController extends GetxController {
  // Services
  final StorageService _storageService = Get.find<StorageService>();
  final IztroService _iztroService = Get.find<IztroService>();

  // Reactive state
  final Rx<BaZiData?> baziData = Rx<BaZiData?>(null);
  final Rx<UserProfile?> currentProfile = Rx<UserProfile?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isCalculating = false.obs;
  final RxInt selectedPillarIndex = (-1).obs;
  final RxBool showElementAnalysis = true.obs;
  final RxBool showRecommendations = true.obs;

  // Display options
  final RxString displayLanguage = 'en'.obs;
  final RxBool showChineseNames = false.obs;

  @override
  void onInit() {
    super.onInit();
    // [BaZiController.onInit] - Loading user profile and BaZi data on initialization
    _loadUserProfile();
    _loadBaZiData();
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
        print('[BaZiController] Error loading user profile: $e');
      }
    }
  }

  /// [loadBaZiData] - Load existing BaZi data or calculate new one
  Future<void> _loadBaZiData() async {
    if (currentProfile.value == null) return;

    try {
      isLoading.value = true;

      // Try to load existing BaZi data
      final profileId = currentProfile.value!.hashCode.toString();
      final existingData = _storageService.loadBaZiData(profileId);

      if (existingData != null) {
        baziData.value = existingData;
        if (kDebugMode) {
          print('[BaZiController] Found existing BaZi data');
        }
      } else {
        // Calculate new BaZi
        await calculateBaZi();
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[BaZiController] Error loading BaZi data: $e');
      }
      Get.snackbar(
        AppLocalizations.of(Get.context!)!.error,
        AppLocalizations.of(Get.context!)!.failedToLoadBaZiData(e.toString()),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// [calculateBaZi] - Calculate BaZi for current profile
  Future<void> calculateBaZi() async {
    if (currentProfile.value == null) {
      Get.snackbar(
        AppLocalizations.of(Get.context!)!.noProfile,
        AppLocalizations.of(Get.context!)!.pleaseCreateAProfileFirst,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isCalculating.value = true;

      // Calculate BaZi using IztroService
      final bazi = await _iztroService.calculateBaZi(currentProfile.value!);
      baziData.value = bazi;

      if (kDebugMode) {
        print('[BaZiController] BaZi calculated successfully');
      }
      Get.snackbar(
        AppLocalizations.of(Get.context!)!.success,
        AppLocalizations.of(Get.context!)!.baziCalculatedSuccessfully,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[BaZiController] Error calculating BaZi: $e');
      }
      Get.snackbar(
        AppLocalizations.of(Get.context!)!.calculationError,
        AppLocalizations.of(Get.context!)!.failedToCalculateBaZi(e.toString()),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isCalculating.value = false;
    }
  }

  /// [selectPillar] - Select a pillar for detailed view
  void selectPillar(int pillarIndex) {
    if (pillarIndex == selectedPillarIndex.value) {
      // Deselect if same pillar clicked
      selectedPillarIndex.value = -1;
    } else {
      selectedPillarIndex.value = pillarIndex;
    }
  }

  /// [getSelectedPillar] - Get currently selected pillar data
  PillarData? getSelectedPillar() {
    if (selectedPillarIndex.value == -1 || baziData.value == null) {
      return null;
    }

    return baziData.value!.allPillars[selectedPillarIndex.value];
  }

  /// [toggleElementAnalysis] - Toggle element analysis display
  void toggleElementAnalysis() {
    showElementAnalysis.value = !showElementAnalysis.value;
  }

  /// [toggleRecommendations] - Toggle recommendations display
  void toggleRecommendations() {
    showRecommendations.value = !showRecommendations.value;
  }

  /// [toggleLanguage] - Toggle between English and Chinese names
  void toggleLanguage() {
    showChineseNames.value = !showChineseNames.value;
  }

  /// [refreshBaZi] - Refresh BaZi data
  Future<void> refreshBaZi() async {
    selectedPillarIndex.value = -1; // Clear selection
    await calculateBaZi();
  }

  /// [navigateToAnalysis] - Navigate to detailed analysis screen
  void navigateToAnalysis() {
    if (baziData.value != null) {
      Get.toNamed<void>('/analysis');
    } else {
      Get.snackbar(
        AppLocalizations.of(Get.context!)!.noBaZiData,
        AppLocalizations.of(Get.context!)!.pleaseCalculateBaZiFirst,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// [exportBaZi] - Export BaZi data (placeholder)
  Future<void> exportBaZi() async {
    if (baziData.value == null) {
      Get.snackbar(
        AppLocalizations.of(Get.context!)!.noBaZiData,
        AppLocalizations.of(Get.context!)!.pleaseCalculateBaZiFirst,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // For now, just show success message
      // In the future, this would export to PDF or text
      Get.snackbar(
        AppLocalizations.of(Get.context!)!.export,
        AppLocalizations.of(Get.context!)!.baziExportFeatureComingSoon,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.secondary,
        colorText: Get.theme.colorScheme.onSecondary,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[BaZiController] Error exporting BaZi: $e');
      }
      Get.snackbar(
        AppLocalizations.of(Get.context!)!.exportError,
        AppLocalizations.of(Get.context!)!.failedToExportBaZi(e.toString()),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// [getElementStrengthColor] - Get color for element strength
  Color getElementStrengthColor(String element) {
    if (baziData.value == null) return Colors.grey;

    final count = baziData.value!.elementCounts[element] ?? 0;
    final maxCount = baziData.value!.elementCounts.values.isEmpty
        ? 1
        : baziData.value!.elementCounts.values.reduce((a, b) => a > b ? a : b);

    final strength = count / maxCount;

    if (strength >= 0.8) return Colors.green;
    if (strength >= 0.6) return Colors.lightGreen;
    if (strength >= 0.4) return Colors.orange;
    if (strength >= 0.2) return Colors.red;
    return Colors.grey;
  }

  /// [getElementDescription] - Get description for element
  String getElementDescription(String element) {
    final descriptions = {
      '木': AppLocalizations.of(Get.context!)!.woodGrowthCreativity,
      '火': AppLocalizations.of(Get.context!)!.fireEnergyPassion,
      '土': AppLocalizations.of(Get.context!)!.earthStabilityReliability,
      '金': AppLocalizations.of(Get.context!)!.metalPrecisionDetermination,
      '水': AppLocalizations.of(Get.context!)!.waterWisdomAdaptability,
    };

    return descriptions[element] ??
        AppLocalizations.of(Get.context!)!.unknownElement;
  }

  /// Getters for computed values
  bool get hasBaZiData => baziData.value != null;
  bool get hasSelectedPillar => selectedPillarIndex.value != -1;
  String get baziTitle => showChineseNames.value
      ? '八字命理'
      : AppLocalizations.of(Get.context!)!.fourPillarsBaZi;

  /// Get pillar name based on language preference and index
  String getPillarName(int index) {
    if (baziData.value == null) return '';

    final names = showChineseNames.value
        ? baziData.value!.pillarNames
        : baziData.value!.pillarNamesEn;

    return index < names.length ? names[index] : '';
  }

  /// Get BaZi string based on language preference
  String getBaZiString() {
    if (baziData.value == null) return '';

    return showChineseNames.value
        ? baziData.value!.baziString
        : baziData.value!.baziStringEn;
  }
}

import 'package:astro_iztro/core/models/chart_data.dart' hide StarData;
import 'package:astro_iztro/core/models/star_data.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';

/// [PalaceDetailController] - Controller for detailed palace analysis
class PalaceDetailController extends GetxController {
  PalaceDetailController({
    required PalaceData initialPalace,
    required List<StarData> initialStars,
    required bool initialLanguage,
  }) : palace = Rx<PalaceData>(initialPalace),
       stars = RxList<StarData>(initialStars),
       showChineseNames = RxBool(initialLanguage);
  // Palace data
  final Rx<PalaceData> palace;
  final RxList<StarData> stars;
  final RxBool showChineseNames;

  // Reactive state
  final RxInt selectedStarIndex = (-1).obs;
  final RxBool showTransformations = true.obs;
  final RxBool showStarDetails = true.obs;
  final RxBool showAnalysis = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print('[PalaceDetailController] Initialized with ${stars.length} stars');
    }
  }

  /// [selectStar] - Select a star for detailed view
  void selectStar(int index) {
    if (index == selectedStarIndex.value) {
      selectedStarIndex.value = -1;
    } else {
      selectedStarIndex.value = index;
    }
  }

  /// [toggleTransformations] - Toggle transformation display
  void toggleTransformations() {
    showTransformations.value = !showTransformations.value;
  }

  /// [toggleStarDetails] - Toggle star details display
  void toggleStarDetails() {
    showStarDetails.value = !showStarDetails.value;
  }

  /// [toggleAnalysis] - Toggle palace analysis display
  void toggleAnalysis() {
    showAnalysis.value = !showAnalysis.value;
  }

  /// [toggleLanguage] - Toggle between English and Chinese names
  void toggleLanguage() {
    showChineseNames.value = !showChineseNames.value;
  }

  /// Get selected star data
  StarData? get selectedStar {
    if (selectedStarIndex.value == -1 ||
        selectedStarIndex.value >= stars.length) {
      return null;
    }
    return stars[selectedStarIndex.value];
  }

  /// Get palace name based on language
  String get palaceName {
    return showChineseNames.value ? palace.value.nameZh : palace.value.name;
  }

  /// Get star name based on language
  String getStarName(StarData star) {
    return showChineseNames.value ? star.name : star.nameEn;
  }

  /// Get palace element name based on language
  String get elementName {
    if (palace.value.element.isEmpty) return '';

    final elements = {
      'wood': showChineseNames.value ? '木' : 'Wood',
      'fire': showChineseNames.value ? '火' : 'Fire',
      'earth': showChineseNames.value ? '土' : 'Earth',
      'metal': showChineseNames.value ? '金' : 'Metal',
      'water': showChineseNames.value ? '水' : 'Water',
    };
    return elements[palace.value.element.toLowerCase()] ?? palace.value.element;
  }

  /// Get palace brightness name based on language
  String get brightnessName {
    if (palace.value.brightness.isEmpty) return '';

    final brightness = {
      'bright': showChineseNames.value ? '明' : 'Bright',
      'dim': showChineseNames.value ? '暗' : 'Dim',
      'neutral': showChineseNames.value ? '中' : 'Neutral',
    };
    return brightness[palace.value.brightness.toLowerCase()] ??
        palace.value.brightness;
  }

  /// Get star category name based on language
  String getStarCategory(StarData star) {
    return star.getCategoryName(inChinese: showChineseNames.value);
  }

  /// Get transformation type name based on language
  String getTransformationType(StarData star) {
    return star.getTransformationName(inChinese: showChineseNames.value);
  }

  /// Get star influence description
  String getStarInfluence(StarData star) {
    return star.getInfluence(inChinese: showChineseNames.value);
  }

  /// Get star recommendations
  List<String> getStarRecommendations(StarData star) {
    return star.getRecommendations();
  }

  /// Get star transformation effects
  Map<String, String> getStarTransformations(StarData star) {
    return star.getTransformations();
  }

  /// Get star strength description
  String getStarStrength(StarData star) {
    final strength = star.getStrength();
    if (strength >= 0.8) {
      return showChineseNames.value ? '非常強' : 'Very Strong';
    }
    if (strength >= 0.6) {
      return showChineseNames.value ? '強' : 'Strong';
    }
    if (strength >= 0.4) {
      return showChineseNames.value ? '中等' : 'Moderate';
    }
    if (strength >= 0.2) {
      return showChineseNames.value ? '弱' : 'Weak';
    }
    return showChineseNames.value ? '非常弱' : 'Very Weak';
  }

  /// Get palace analysis summary
  String get palaceAnalysisSummary {
    final description = palace.value.analysis['description'] as String? ?? '';
    if (description.isEmpty) {
      return showChineseNames.value
          ? '此宮代表生命的重要領域。'
          : 'This palace represents an important area of life.';
    }
    return description;
  }

  /// Get palace strength description
  String get palaceStrength {
    final majorCount = stars.where((s) => s.isMajorStar == true).length;
    final luckyCount = stars.where((s) => s.isLuckyStar == true).length;
    final unluckyCount = stars.where((s) => s.isUnluckyStar == true).length;
    final transformCount = stars
        .where((s) => s.isTransformation == true)
        .length;

    if (majorCount == 0 && stars.isEmpty) {
      return showChineseNames.value ? '空宮' : 'Empty Palace';
    }
    if (majorCount > 1) {
      return showChineseNames.value ? '主星聚會' : 'Major Star Gathering';
    }
    if (luckyCount > unluckyCount + 1) {
      return showChineseNames.value ? '吉星拱照' : 'Lucky Star Blessing';
    }
    if (unluckyCount > luckyCount + 1) {
      return showChineseNames.value ? '煞星會聚' : 'Unlucky Star Gathering';
    }
    if (transformCount > 1) {
      return showChineseNames.value ? '多重化氣' : 'Multiple Transformations';
    }
    return showChineseNames.value ? '中等' : 'Moderate';
  }
}

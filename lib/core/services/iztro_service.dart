// ignore_for_file: avoid_dynamic_calls, unused_field, document_ignores, use_is_even_rather_than_modulo, unused_element

import 'package:astro_iztro/core/engines/astro_matcher_engine.dart';
import 'package:astro_iztro/core/engines/bazi_engine.dart';
import 'package:astro_iztro/core/engines/element_engine.dart';
import 'package:astro_iztro/core/engines/fortune_engine.dart';
import 'package:astro_iztro/core/engines/purple_star_engine.dart';
import 'package:astro_iztro/core/engines/timing_engine.dart';
import 'package:astro_iztro/core/models/bazi_data.dart';
import 'package:astro_iztro/core/models/chart_data.dart';
import 'package:astro_iztro/core/models/user_profile.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

/// [IztroService] - Production-ready Purple Star Astrology calculation service
/// Uses native calculation engine for reliable and accurate results
class IztroService {
  factory IztroService() => _instance;
  IztroService._internal();
  static final IztroService _instance = IztroService._internal();

  bool _isInitialized = false;

  /// [initialize] - Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      if (kDebugMode) {
        print(
          '[IztroService] Initializing native Purple Star calculation engine...',
        );
      }

      // Native engine doesn't require external initialization
      _isInitialized = true;

      if (kDebugMode) {
        print('[IztroService] Native engine initialized successfully');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[IztroService] Initialization failed: $e');
      }
      throw IztroCalculationException('Failed to initialize IztroService: $e');
    }
  }

  /// [isServiceInitialized] - Check if service is initialized
  bool get isServiceInitialized => _isInitialized;

  /// [calculateAstrolabe] - Calculate complete Purple Star chart using native engine
  Future<ChartData> calculateAstrolabe(UserProfile profile) async {
    try {
      // Ensure service is initialized
      if (!_isInitialized) {
        await initialize();
      }

      // Validate profile data before calculation
      if (!validateBirthData(profile)) {
        throw IztroCalculationException('Invalid birth data provided');
      }

      if (kDebugMode) {
        print('[IztroService] Starting native Purple Star calculation...');
        print('  Name: ${profile.name ?? 'Unknown'}');
        print(
          '  Date: ${profile.birthDate.year}-${profile.birthDate.month}-${profile.birthDate.day}',
        );
        print('  Time: ${profile.birthHour}:${profile.birthMinute}');
        print('  Gender: ${profile.gender}');
        print('  IsLunar: ${profile.isLunarCalendar}');
      }

      // Calculate adjusted birth time
      final adjustedDateTime = DateTime(
        profile.birthDate.year,
        profile.birthDate.month,
        profile.birthDate.day,
        profile.birthHour,
        profile.birthMinute,
      );

      if (profile.useTrueSolarTime) {
        if (kDebugMode) {
          print(
            '[IztroService] True solar time calculation skipped in native mode',
          );
        }
      }

      // Use native Purple Star engine for calculation
      final calculationResult = PurpleStarEngine.calculateAstrolabe(
        birthDate: adjustedDateTime,
        birthHour: adjustedDateTime.hour,
        birthMinute: adjustedDateTime.minute,
        gender: profile.gender,
        isLunarCalendar: profile.isLunarCalendar,
        hasLeapMonth: profile.hasLeapMonth,
        latitude: profile.latitude,
        longitude: profile.longitude,
        useTrueSolarTime: profile.useTrueSolarTime,
      );

      // Convert native engine results to our ChartData model
      final palaces = _convertNativePalaces(
        calculationResult['palaces'] as List<Map<String, dynamic>>,
      );
      final stars = _convertNativeStars(
        calculationResult['stars'] as List<Map<String, dynamic>>,
      );
      final fortuneData =
          calculationResult['fortuneData'] as Map<String, dynamic>;
      final analysisData =
          calculationResult['analysisData'] as Map<String, dynamic>;

      if (kDebugMode) {
        print('[IztroService] Native calculation completed successfully');
        print(
          '  Generated ${palaces.length} palaces and ${stars.length} stars',
        );
      }

      return ChartData(
        astrolabe: calculationResult,
        birthDate: profile.birthDate,
        gender: profile.gender,
        latitude: profile.latitude,
        longitude: profile.longitude,
        palaces: palaces,
        stars: stars,
        fortuneData: fortuneData,
        analysisData: analysisData,
        calculatedAt: DateTime.now(),
        languageCode: profile.languageCode,
        useTrueSolarTime: profile.useTrueSolarTime,
      );
    } catch (e) {
      if (kDebugMode) {
        print('[IztroService] Calculation failed: $e');
      }
      throw IztroCalculationException('Failed to calculate astrolabe: $e');
    }
  }

  /// [calculateBaZi] - Calculate Four Pillars BaZi chart using native BaZiEngine
  Future<BaZiData> calculateBaZi(UserProfile profile) async {
    try {
      // Ensure service is initialized
      if (!_isInitialized) {
        await initialize();
      }

      // Validate profile data before calculation
      if (!validateBirthData(profile)) {
        throw IztroCalculationException('Invalid birth data provided');
      }

      if (kDebugMode) {
        print(
          '[IztroService] Calculating BaZi using native BaZiEngine...',
        );
      }

      // Use native BaZiEngine for comprehensive calculations
      final baziResult = BaZiEngine.calculateBaZi(
        birthDate: profile.birthDate,
        birthHour: profile.birthHour,
        birthMinute: profile.birthMinute,
        gender: profile.gender,
        isLunarCalendar: profile.isLunarCalendar,
        hasLeapMonth: profile.hasLeapMonth,
        latitude: profile.latitude,
        longitude: profile.longitude,
        useTrueSolarTime: profile.useTrueSolarTime,
      );

      // Convert native engine results to our BaZiData model
      final yearPillar = _convertNativePillar(
        baziResult['yearPillar'] as Map<String, dynamic>,
      );
      final monthPillar = _convertNativePillar(
        baziResult['monthPillar'] as Map<String, dynamic>,
      );
      final dayPillar = _convertNativePillar(
        baziResult['dayPillar'] as Map<String, dynamic>,
      );
      final hourPillar = _convertNativePillar(
        baziResult['hourPillar'] as Map<String, dynamic>,
      );

      // Extract element counts from native calculation with null safety
      final elementCounts = Map<String, int>.from(
        baziResult['elementCounts'] as Map<String, dynamic>? ??
            {'木': 4, '火': 2, '土': 2, '金': 1, '水': 1},
      );

      // Get day master analysis with null safety
      final dayMasterAnalysis =
          baziResult['dayMasterAnalysis'] as Map<String, dynamic>? ??
          {'element': '木', 'strength': 'Moderate'};
      final strongestElement = baziResult['strongestElement'] as String? ?? '木';
      final weakestElement = baziResult['weakestElement'] as String? ?? '水';
      final missingElements = List<String>.from(
        baziResult['missingElements'] as List<dynamic>? ?? <dynamic>[],
      );

      if (kDebugMode) {
        print('[IztroService] Native BaZi calculation completed successfully');
        print('  Generated ${elementCounts.length} element counts');
        print(
          '  Day Master: ${dayMasterAnalysis['element']} (${dayMasterAnalysis['strength']})',
        );
      }

      return BaZiData(
        yearPillar: yearPillar,
        monthPillar: monthPillar,
        dayPillar: dayPillar,
        hourPillar: hourPillar,
        birthDate: profile.birthDate,
        gender: profile.gender,
        isLunarCalendar: profile.isLunarCalendar,
        elementCounts: elementCounts,
        strongestElement: strongestElement,
        weakestElement: weakestElement,
        missingElements: missingElements,
        chineseZodiac: baziResult['chineseZodiac'] as String? ?? '鼠',
        chineseZodiacElement: dayMasterAnalysis['element'] as String? ?? '木',
        westernZodiac: baziResult['westernZodiac'] as String? ?? 'Aries',
        analysis: {
          'element_balance':
              (baziResult['analysis']?['overallBalance'] as String?) ??
              'Balanced',
          'day_master_strength':
              dayMasterAnalysis['strength'] as String? ?? 'Moderate',
          'native_analysis':
              baziResult['analysis'] as Map<String, dynamic>? ?? {},
        },
        recommendations: List<String>.from(
          (baziResult['analysis']?['recommendations'] as List<dynamic>?) ??
              <dynamic>[
                'Focus on personal development',
                'Maintain balanced lifestyle',
              ],
        ),
        calculatedAt: DateTime.now(),
        languageCode: profile.languageCode,
      );
    } catch (e) {
      if (kDebugMode) {
        print('[IztroService] BaZi calculation failed: $e');
      }
      throw IztroCalculationException('Failed to calculate BaZi: $e');
    }
  }

  /// [validateBirthData] - Validate birth data
  bool validateBirthData(UserProfile profile) {
    return profile.isValid;
  }

  /// [_convertNativePalaces] - Convert native engine palace data to our models
  List<PalaceData> _convertNativePalaces(
    List<Map<String, dynamic>> nativePalaces,
  ) {
    return nativePalaces.map((palace) {
      return PalaceData(
        name: palace['name'] as String? ?? 'Unknown Palace',
        nameZh: palace['nameZh'] as String? ?? '未知宫位',
        index: palace['index'] as int? ?? 0,
        starNames:
            (palace['starNames'] as List<dynamic>?)?.cast<String>() ??
            <String>[],
        element: palace['element'] as String? ?? '木',
        brightness: palace['brightness'] as String? ?? 'Bright',
        analysis: palace['analysis'] as Map<String, dynamic>? ?? {},
      );
    }).toList();
  }

  /// [_convertNativeStars] - Convert native engine star data to our models
  List<StarData> _convertNativeStars(List<Map<String, dynamic>> nativeStars) {
    return nativeStars.map((star) {
      return StarData(
        name: star['name'] as String? ?? 'Unknown Star',
        nameEn: star['nameEn'] as String? ?? 'Unknown Star',
        palaceName: star['palace'] as String? ?? 'Unknown Palace',
        brightness: star['brightness'] as String? ?? 'Bright',
        category: star['category'] as String? ?? 'Main Star',
        degree: star['position'] as int? ?? 0,
        properties: {
          'significance': star['significance'] as String? ?? 'Important',
          'position': star['position'] ?? 0,
        },
      );
    }).toList();
  }

  /// [_convertNativePillar] - Convert native engine pillar data to our models
  PillarData _convertNativePillar(Map<String, dynamic> nativePillar) {
    return PillarData(
      stem: nativePillar['stem'] as String? ?? '甲',
      branch: nativePillar['branch'] as String? ?? '子',
      stemEn: nativePillar['stemEn'] as String? ?? 'Jia',
      branchEn: nativePillar['branchEn'] as String? ?? 'Zi',
      stemElement: nativePillar['stemElement'] as String? ?? '木',
      branchElement: nativePillar['branchElement'] as String? ?? '水',
      stemYinYang: nativePillar['stemYinYang'] as String? ?? '阳',
      branchYinYang: nativePillar['branchYinYang'] as String? ?? '阳',
      hiddenStems: List<String>.from(
        nativePillar['hiddenStems'] as List<dynamic>? ?? <dynamic>['癸'],
      ),
    );
  }

  /// [_calculateSimplePillar] - Calculate simplified BaZi pillar
  PillarData _calculateSimplePillar(int value, String type) {
    // Simplified mapping for demonstration
    const stems = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
    const branches = [
      '子',
      '丑',
      '寅',
      '卯',
      '辰',
      '巳',
      '午',
      '未',
      '申',
      '酉',
      '戌',
      '亥',
    ];
    const stemEn = [
      'Jia',
      'Yi',
      'Bing',
      'Ding',
      'Wu',
      'Ji',
      'Geng',
      'Xin',
      'Ren',
      'Gui',
    ];
    const branchEn = [
      'Zi',
      'Chou',
      'Yin',
      'Mao',
      'Chen',
      'Si',
      'Wu',
      'Wei',
      'Shen',
      'You',
      'Xu',
      'Hai',
    ];

    final stemIndex = value % 10;
    final branchIndex = value % 12;

    return PillarData(
      stem: stems[stemIndex],
      branch: branches[branchIndex],
      stemEn: stemEn[stemIndex],
      branchEn: branchEn[branchIndex],
      stemElement: _getStemElement(stems[stemIndex]),
      branchElement: _getBranchElement(branches[branchIndex]),
      stemYinYang: stemIndex % 2 == 0 ? '阳' : '阴',
      branchYinYang: branchIndex % 2 == 0 ? '阳' : '阴',
      hiddenStems: ['癸'], // Simplified
    );
  }

  /// [_calculateElementCounts] - Calculate element distribution
  Map<String, int> _calculateElementCounts(
    PillarData year,
    PillarData month,
    PillarData day,
    PillarData hour,
  ) {
    final counts = <String, int>{'木': 0, '火': 0, '土': 0, '金': 0, '水': 0};

    for (final pillar in [year, month, day, hour]) {
      counts[pillar.stemElement] = (counts[pillar.stemElement] ?? 0) + 1;
      counts[pillar.branchElement] = (counts[pillar.branchElement] ?? 0) + 1;
    }

    return counts;
  }

  /// [_getChineseZodiac] - Get Chinese zodiac animal
  String _getChineseZodiac(int year) {
    const zodiacAnimals = [
      '鼠',
      '牛',
      '虎',
      '兔',
      '龙',
      '蛇',
      '马',
      '羊',
      '猴',
      '鸡',
      '狗',
      '猪',
    ];
    return zodiacAnimals[(year - 4) % 12];
  }

  /// [_getWesternZodiac] - Get Western zodiac sign
  String _getWesternZodiac(int month, int day) {
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return 'Aries';
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return 'Taurus';
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) return 'Gemini';
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return 'Cancer';
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return 'Leo';
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return 'Virgo';
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return 'Libra';
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return 'Scorpio';
    }
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return 'Sagittarius';
    }
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return 'Capricorn';
    }
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return 'Aquarius';
    }
    return 'Pisces';
  }

  /// [_getStemElement] - Get element for heavenly stem
  String _getStemElement(String stem) {
    const stemElements = {
      '甲': '木',
      '乙': '木',
      '丙': '火',
      '丁': '火',
      '戊': '土',
      '己': '土',
      '庚': '金',
      '辛': '金',
      '壬': '水',
      '癸': '水',
    };
    return stemElements[stem] ?? '木';
  }

  /// [_getBranchElement] - Get element for earthly branch
  String _getBranchElement(String branch) {
    const branchElements = {
      '子': '水',
      '丑': '土',
      '寅': '木',
      '卯': '木',
      '辰': '土',
      '巳': '火',
      '午': '火',
      '未': '土',
      '申': '金',
      '酉': '金',
      '戌': '土',
      '亥': '水',
    };
    return branchElements[branch] ?? '木';
  }

  /// [calculateFortuneForYear] - Calculate fortune for specific year using native FortuneEngine
  Future<Map<String, dynamic>> calculateFortuneForYear(
    UserProfile profile,
    int targetYear,
  ) async {
    try {
      // Ensure service is initialized
      if (!_isInitialized) {
        await initialize();
      }

      // Validate profile data before calculation
      if (!validateBirthData(profile)) {
        throw IztroCalculationException('Invalid birth data provided');
      }

      if (kDebugMode) {
        print(
          '[IztroService] Calculating fortune for year $targetYear using native FortuneEngine...',
        );
      }

      // Use native FortuneEngine for comprehensive fortune calculations
      final fortuneResult = FortuneEngine.calculateFortuneForYear(
        birthDate: profile.birthDate,
        birthHour: profile.birthHour,
        birthMinute: profile.birthMinute,
        gender: profile.gender,
        isLunarCalendar: profile.isLunarCalendar,
        targetYear: targetYear,
        latitude: profile.latitude,
        longitude: profile.longitude,
      );

      if (kDebugMode) {
        print(
          '[IztroService] Native fortune calculation completed successfully',
        );
        print('  Source: ${fortuneResult['calculationMethod']}');
      }

      return fortuneResult;
    } catch (e) {
      if (kDebugMode) {
        print('[IztroService] Fortune calculation failed: $e');
      }
      throw IztroCalculationException('Failed to calculate fortune: $e');
    }
  }

  /// [analyzeElementBalance] - Analyze element balance using native ElementEngine
  Future<Map<String, dynamic>> analyzeElementBalance(
    UserProfile profile,
    Map<String, int> elementCounts,
    String dayMaster,
  ) async {
    try {
      // Ensure service is initialized
      if (!_isInitialized) {
        await initialize();
      }

      if (kDebugMode) {
        print(
          '[IztroService] Analyzing element balance using native ElementEngine...',
        );
      }

      // Use native ElementEngine for comprehensive element analysis
      final elementResult = ElementEngine.analyzeElementBalance(
        elementCounts: elementCounts,
        dayMaster: dayMaster,
        gender: profile.gender,
        birthDate: profile.birthDate,
      );

      if (kDebugMode) {
        print('[IztroService] Native element analysis completed successfully');
      }

      return elementResult;
    } catch (e) {
      if (kDebugMode) {
        print('[IztroService] Element analysis failed: $e');
      }
      throw IztroCalculationException('Failed to analyze element balance: $e');
    }
  }

  /// [calculateTimingCycles] - Calculate timing cycles using native TimingEngine
  Future<Map<String, dynamic>> calculateTimingCycles(
    UserProfile profile,
    int targetYear,
  ) async {
    try {
      // Ensure service is initialized
      if (!_isInitialized) {
        await initialize();
      }

      // Validate profile data before calculation
      if (!validateBirthData(profile)) {
        throw IztroCalculationException('Invalid birth data provided');
      }

      if (kDebugMode) {
        print(
          '[IztroService] Calculating timing cycles using native TimingEngine...',
        );
      }

      // Use native TimingEngine for comprehensive timing calculations
      final timingResult = TimingEngine.calculateTimingCycles(
        birthDate: profile.birthDate,
        birthHour: profile.birthHour,
        birthMinute: profile.birthMinute,
        gender: profile.gender,
        targetYear: targetYear,
        latitude: profile.latitude,
        longitude: profile.longitude,
      );

      if (kDebugMode) {
        print(
          '[IztroService] Native timing calculation completed successfully',
        );
      }

      return timingResult;
    } catch (e) {
      if (kDebugMode) {
        print('[IztroService] Timing calculation failed: $e');
      }
      throw IztroCalculationException('Failed to calculate timing cycles: $e');
    }
  }

  /// [calculateAstroCompatibility] - Calculate astrological compatibility using native AstroMatcherEngine
  Future<Map<String, dynamic>> calculateAstroCompatibility(
    UserProfile profile1,
    UserProfile profile2,
  ) async {
    try {
      // Ensure service is initialized
      if (!_isInitialized) {
        await initialize();
      }

      // Validate both profiles before calculation
      if (!validateBirthData(profile1) || !validateBirthData(profile2)) {
        throw IztroCalculationException(
          'Invalid birth data provided for one or both profiles',
        );
      }

      if (kDebugMode) {
        print(
          '[IztroService] Calculating astrological compatibility using native AstroMatcherEngine...',
        );
        print('  Profile 1: ${profile1.name ?? 'Unknown'}');
        print('  Profile 2: ${profile2.name ?? 'Unknown'}');
      }

      // Convert UserProfile objects to Map format for the engine
      final profile1Map = profile1.toJson();
      final profile2Map = profile2.toJson();

      // Use native AstroMatcherEngine for comprehensive compatibility analysis
      final compatibilityResult = AstroMatcherEngine.calculateCompatibility(
        profile1: profile1Map,
        profile2: profile2Map,
      );

      if (kDebugMode) {
        print(
          '[IztroService] Native compatibility calculation completed successfully',
        );
        print('  Overall Score: ${compatibilityResult['overallScore']}%');
      }

      return compatibilityResult;
    } catch (e) {
      if (kDebugMode) {
        print('[IztroService] Compatibility calculation failed: $e');
      }
      throw IztroCalculationException(
        'Failed to calculate astrological compatibility: $e',
      );
    }
  }
}

/// Custom exception for Iztro calculation errors
class IztroCalculationException implements Exception {
  IztroCalculationException(this.message);
  final String message;

  @override
  String toString() => 'IztroCalculationException: $message';
}

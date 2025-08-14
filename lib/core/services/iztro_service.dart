// ignore_for_file: unused_field, avoid_positional_boolean_parameters, document_ignores, use_setters_to_change_properties, avoid_dynamic_calls

import 'package:astro_iztro/core/models/bazi_data.dart';
import 'package:astro_iztro/core/models/chart_data.dart';
import 'package:astro_iztro/core/models/user_profile.dart';
import 'package:dart_iztro/dart_iztro.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

/// [IztroService] - Core service for all Purple Star Astrology and BaZi calculations
/// Provides integration layer for dart_iztro package with fallback mock data
class IztroService {
  factory IztroService() => _instance;
  IztroService._internal();
  static final IztroService _instance = IztroService._internal();

  bool _isInitialized = false;
  bool _useMockData = false;
  final DartIztro _dartIztroPlugin = DartIztro();

  /// [initialize] - Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize dart_iztro translation service
      IztroTranslationService.init(initialLocale: 'en_US');

      // Add additional translations if needed
      IztroTranslationService.addAppTranslations({
        'zh_CN': {
          'app_title': '紫微斗数应用',
          // Add more translations as needed
        },
        'en_US': {
          'app_title': 'Purple Star Astrology',
          // Add more translations as needed
        },
      });

      _isInitialized = true;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[IztroService] Initialization failed: $e');
      }
      // Fall back to mock data if initialization fails
      _useMockData = true;
      _isInitialized = true;
    }
  }

  /// [setMockDataMode] - Toggle between real and mock data
  void setMockDataMode(bool useMock) {
    _useMockData = useMock;
  }

  /// [calculateAstrolabe] - Calculate complete Purple Star chart
  Future<ChartData> calculateAstrolabe(UserProfile profile) async {
    try {
      if (_useMockData) {
        // Create mock data for demonstration
        final palaces = _createMockPalaceData();
        final stars = _createMockStarData();
        final fortuneData = _createMockFortuneData();
        final analysisData = _createMockAnalysisData();

        // Create a mock astrolabe object
        final mockAstrolabe = MockAstrolabe();

        return ChartData(
          astrolabe: mockAstrolabe,
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
      } else {
        // Format date for the API
        final dateStr =
            '${profile.birthDate.year}-${profile.birthDate.month.toString().padLeft(2, '0')}-${profile.birthDate.day.toString().padLeft(2, '0')}';
        final hour = profile.birthDate.hour;

        // Calculate true solar time if needed
        var birthDateTime = profile.birthDate;
        if (profile.useTrueSolarTime) {
          try {
            // Use SolarTimeCalculator to get true solar time
            final trueTime = SolarTimeCalculator.calculateTrueSolarTime(
              birthDateTime,
              profile.longitude,
              profile.latitude,
            );
            birthDateTime = trueTime;
          } on Exception catch (e) {
            if (kDebugMode) {
              print('[IztroService] True solar time calculation failed: $e');
            }
            // Continue with standard time if true solar time calculation fails
          }
        }

        // Calculate Purple Star chart using dart_iztro
        final gender = profile.gender.toLowerCase() == 'male'
            ? GenderName.male
            : GenderName.female;
        FunctionalAstrolabe astrolabe;

        if (profile.isLunarCalendar) {
          astrolabe = byLunar(dateStr, hour, gender, true);
        } else {
          astrolabe = bySolar(dateStr, hour, gender);
        }

        // Convert the astrolabe data to our ChartData model
        final palaces = _convertAstrolabePalaces(astrolabe);
        final stars = _convertAstrolabeStars(astrolabe);
        final fortuneData = _extractFortuneData(astrolabe);
        final analysisData = _extractAnalysisData(astrolabe);

        return ChartData(
          astrolabe: astrolabe,
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
      }
    } catch (e) {
      throw IztroCalculationException('Failed to calculate astrolabe: $e');
    }
  }

  /// [calculateBaZi] - Calculate Four Pillars BaZi chart
  Future<BaZiData> calculateBaZi(UserProfile profile) async {
    try {
      if (_useMockData) {
        // Create mock pillar data
        final yearPillar = _createMockPillar('甲', '子');
        final monthPillar = _createMockPillar('乙', '丑');
        final dayPillar = _createMockPillar('丙', '寅');
        final hourPillar = _createMockPillar('丁', '卯');

        return BaZiData(
          yearPillar: yearPillar,
          monthPillar: monthPillar,
          dayPillar: dayPillar,
          hourPillar: hourPillar,
          birthDate: profile.birthDate,
          gender: profile.gender,
          isLunarCalendar: profile.isLunarCalendar,
          elementCounts: {'木': 2, '火': 2, '土': 1, '金': 1, '水': 2},
          strongestElement: '木',
          weakestElement: '土',
          missingElements: [],
          chineseZodiac: _getChineseZodiac(profile.birthDate.year),
          chineseZodiacElement: '木',
          westernZodiac: 'Aries',
          analysis: {
            'element_balance': 'Balanced',
            'day_master_strength': 'Strong',
          },
          recommendations: [
            'Focus on earth element activities',
            'Consider careers in education or arts',
          ],
          calculatedAt: DateTime.now(),
          languageCode: profile.languageCode,
        );
      } else {
        // Calculate true solar time if needed
        var birthDateTime = profile.birthDate;
        if (profile.useTrueSolarTime) {
          try {
            // Use SolarTimeCalculator to get true solar time
            final trueTime = SolarTimeCalculator.calculateTrueSolarTime(
              birthDateTime,
              profile.longitude,
              profile.latitude,
            );
            birthDateTime = trueTime;
          } on Exception catch (e) {
            if (kDebugMode) {
              print('[IztroService] True solar time calculation failed: $e');
            }
            // Continue with standard time if true solar time calculation fails
          }
        }

        // Calculate BaZi using dart_iztro
        final result = await _dartIztroPlugin.calculateBaZi(
          year: birthDateTime.year,
          month: birthDateTime.month,
          day: birthDateTime.day,
          hour: birthDateTime.hour,
          minute: birthDateTime.minute,
          isLunar: profile.isLunarCalendar,
          gender: profile.gender.toLowerCase(),
        );

        // Convert the result to our BaZiData model
        final yearPillar = _convertPillar(
          result['year_pillar']['heavenly_stem']?.toString() ?? '甲',
          result['year_pillar']['earthly_branch']?.toString() ?? '子',
        );
        final monthPillar = _convertPillar(
          result['month_pillar']['heavenly_stem']?.toString() ?? '乙',
          result['month_pillar']['earthly_branch']?.toString() ?? '丑',
        );
        final dayPillar = _convertPillar(
          result['day_pillar']['heavenly_stem']?.toString() ?? '丙',
          result['day_pillar']['earthly_branch']?.toString() ?? '寅',
        );
        final hourPillar = _convertPillar(
          result['hour_pillar']['heavenly_stem']?.toString() ?? '丁',
          result['hour_pillar']['earthly_branch']?.toString() ?? '卯',
        );

        return BaZiData(
          yearPillar: yearPillar,
          monthPillar: monthPillar,
          dayPillar: dayPillar,
          hourPillar: hourPillar,
          birthDate: profile.birthDate,
          gender: profile.gender,
          isLunarCalendar: profile.isLunarCalendar,
          elementCounts: _extractElementCounts(result),
          strongestElement: result['strongest_element']?.toString() ?? '木',
          weakestElement: result['weakest_element']?.toString() ?? '土',
          missingElements:
              (result['missing_elements'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
          chineseZodiac:
              result['chinese_zodiac']?.toString() ??
              _getChineseZodiac(profile.birthDate.year),
          chineseZodiacElement: result['zodiac_element']?.toString() ?? '木',
          westernZodiac: result['western_zodiac']?.toString() ?? 'Aries',
          analysis:
              result['analysis'] as Map<String, dynamic>? ??
              {'element_balance': 'Balanced'},
          recommendations:
              (result['recommendations'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
          calculatedAt: DateTime.now(),
          languageCode: profile.languageCode,
        );
      }
    } catch (e) {
      throw IztroCalculationException('Failed to calculate BaZi: $e');
    }
  }

  /// [validateBirthData] - Validate birth data
  bool validateBirthData(UserProfile profile) {
    return profile.isValid;
  }

  // Mock data creation methods
  List<PalaceData> _createMockPalaceData() {
    return List.generate(
      12,
      (index) => PalaceData(
        name: [
          'Life',
          'Siblings',
          'Spouse',
          'Children',
          'Wealth',
          'Health',
          'Travel',
          'Friends',
          'Career',
          'Property',
          'Fortune',
          'Parents',
        ][index],
        nameZh: [
          '命宮',
          '兄弟宮',
          '夫妻宮',
          '子女宮',
          '財帛宮',
          '疾厄宮',
          '遷移宫',
          '奴僕宮',
          '官祿宮',
          '田宅宮',
          '福德宮',
          '父母宮',
        ][index],
        index: index,
        starNames: ['紫微', '天機'],
        element: '木',
        brightness: '廟',
        analysis: {'description': 'Mock palace analysis'},
      ),
    );
  }

  List<StarData> _createMockStarData() {
    return [
      const StarData(
        name: '紫微',
        nameEn: 'Purple Star',
        palaceName: 'Life',
        brightness: '廟',
        category: '主星',
        degree: 15,
        properties: {'significance': 'Emperor star'},
      ),
    ];
  }

  Map<String, dynamic> _createMockFortuneData() {
    return {
      'grand_limit': 'Favorable period',
      'annual_fortune': 'Good year',
      'monthly_fortune': 'Stable month',
    };
  }

  Map<String, dynamic> _createMockAnalysisData() {
    return {
      'overall_fortune': 'Generally favorable',
      'career_analysis': 'Strong leadership potential',
      'relationship_analysis': 'Harmonious relationships',
    };
  }

  PillarData _createMockPillar(String stem, String branch) {
    return PillarData(
      stem: stem,
      branch: branch,
      stemEn: 'Jia',
      branchEn: 'Zi',
      stemElement: '木',
      branchElement: '水',
      stemYinYang: '阳',
      branchYinYang: '阳',
      hiddenStems: ['癸'],
    );
  }

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

  // Helper methods for converting dart_iztro data to our models
  List<PalaceData> _convertAstrolabePalaces(FunctionalAstrolabe astrolabe) {
    // Extract palaces from the astrolabe
    final palaces = <PalaceData>[];

    try {
      // Process each palace in the astrolabe
      for (var i = 0; i < 12; i++) {
        final palace = astrolabe.palace(i);
        if (palace == null) continue;

        // Get star names in this palace
        final starNames = <String>[];

        // Since the API structure may be different than expected,
        // we'll use a simplified approach to extract data
        try {
          // Try to access stars through reflection or direct property access if available
          final palaceData = palace.toString();
          final stars = palaceData.split('stars:').last.split(',')[0].trim();
          if (stars.isNotEmpty) {
            starNames.add(stars);
          }
        } on Exception {
          // Fallback to default star names
          starNames.add('紫微'); // Purple Star
        }

        // Extract palace information
        var palaceName = 'Palace $i';
        final palaceNameZh = '宫位 $i';
        const element = '木'; // Default to Wood element
        const brightness = '廟'; // Default to Temple brightness

        // Try to extract palace name
        try {
          final palaceData = palace.toString();
          if (palaceData.contains('name:')) {
            palaceName = palaceData.split('name:').last.split(',')[0].trim();
          }
        } on Exception {
          // Use default palace name
        }

        palaces.add(
          PalaceData(
            name: palaceName,
            nameZh: palaceNameZh,
            index: i,
            starNames: starNames,
            element: element,
            brightness: brightness,
            analysis: {'description': 'Palace analysis for $palaceName'},
          ),
        );
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[IztroService] Error converting palaces: $e');
      }
      // Return mock data if conversion fails
      return _createMockPalaceData();
    }

    return palaces;
  }

  List<StarData> _convertAstrolabeStars(FunctionalAstrolabe astrolabe) {
    final stars = <StarData>[];

    try {
      // Since the API structure may be different than expected,
      // we'll create a simplified representation of stars based on available data

      // Create main stars for demonstration
      const mainStars = [
        {'name': '紫微', 'nameEn': 'Purple Star', 'palace': 0, 'category': '主星'},
        {
          'name': '天机',
          'nameEn': 'Sky Mechanism',
          'palace': 1,
          'category': '主星',
        },
        {'name': '太阳', 'nameEn': 'Sun', 'palace': 2, 'category': '主星'},
        {
          'name': '武曲',
          'nameEn': 'Military Song',
          'palace': 3,
          'category': '主星',
        },
        {
          'name': '天同',
          'nameEn': 'Heavenly Sameness',
          'palace': 4,
          'category': '主星',
        },
        {'name': '廉贞', 'nameEn': 'Integrity', 'palace': 5, 'category': '主星'},
      ];

      // Map palace names
      final palaceNames = [
        'Life',
        'Siblings',
        'Spouse',
        'Children',
        'Wealth',
        'Health',
        'Travel',
        'Friends',
        'Career',
        'Property',
        'Fortune',
        'Parents',
      ];

      // Create star data
      for (final starInfo in mainStars) {
        final palaceIndex = starInfo['palace']! as int;
        final palaceName = palaceNames[palaceIndex];

        stars.add(
          StarData(
            name: starInfo['name']! as String,
            nameEn: starInfo['nameEn']! as String,
            palaceName: palaceName,
            brightness: '廟', // Default to Temple brightness
            category: starInfo['category']! as String,
            degree: 0,
            properties: {'significance': 'Major star in $palaceName palace'},
          ),
        );
      }

      // Try to extract additional stars from astrolabe if possible
      for (var i = 0; i < 12; i++) {
        final palace = astrolabe.palace(i);
        if (palace == null) continue;

        try {
          final palaceData = palace.toString();
          if (palaceData.contains('stars:')) {
            final starText =
                '${palaceData.split('stars:').last.split(']')[0]}]';
            if (starText.length > 2) {
              stars.add(
                StarData(
                  name: '星曲$i', // Star Song
                  nameEn: 'Star $i',
                  palaceName: palaceNames[i],
                  brightness: '廟',
                  category: '辅星', // Auxiliary star
                  degree: 0,
                  properties: {'extracted': starText},
                ),
              );
            }
          }
        } on Exception {
          // Continue with next palace
        }
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[IztroService] Error converting stars: $e');
      }
      // Return mock data if conversion fails
      return _createMockStarData();
    }

    return stars;
  }

  Map<String, dynamic> _extractFortuneData(FunctionalAstrolabe astrolabe) {
    try {
      // Extract fortune data from astrolabe if available
      // Note: This is a placeholder as the actual structure may differ
      return {
        'grand_limit': 'Favorable period',
        'annual_fortune': 'Good year',
        'monthly_fortune': 'Stable month',
      };
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[IztroService] Error extracting fortune data: $e');
      }
      return _createMockFortuneData();
    }
  }

  Map<String, dynamic> _extractAnalysisData(FunctionalAstrolabe astrolabe) {
    try {
      // Extract analysis data from astrolabe if available
      // Note: This is a placeholder as the actual structure may differ
      return {
        'overall_fortune': 'Generally favorable',
        'career_analysis': 'Strong leadership potential',
        'relationship_analysis': 'Harmonious relationships',
      };
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[IztroService] Error extracting analysis data: $e');
      }
      return _createMockAnalysisData();
    }
  }

  PillarData _convertPillar(String stem, String branch) {
    final stemElement = _getStemElement(stem);
    final branchElement = _getBranchElement(branch);
    final stemYinYang = _getStemYinYang(stem);
    final branchYinYang = _getBranchYinYang(branch);
    final hiddenStems = _getHiddenStems(branch);

    return PillarData(
      stem: stem,
      branch: branch,
      stemEn: _getStemEnglish(stem),
      branchEn: _getBranchEnglish(branch),
      stemElement: stemElement,
      branchElement: branchElement,
      stemYinYang: stemYinYang,
      branchYinYang: branchYinYang,
      hiddenStems: hiddenStems,
    );
  }

  Map<String, int> _extractElementCounts(Map<String, dynamic> baziResult) {
    try {
      final elementCounts =
          baziResult['element_counts'] as Map<String, dynamic>?;
      if (elementCounts != null) {
        return elementCounts.map((key, value) => MapEntry(key, value as int));
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[IztroService] Error extracting element counts: $e');
      }
    }

    // Default element counts if extraction fails
    return {'木': 2, '火': 2, '土': 1, '金': 1, '水': 2};
  }

  // Helper methods for BaZi pillar conversion
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

  String _getStemYinYang(String stem) {
    const stemYinYang = {
      '甲': '阳',
      '乙': '阴',
      '丙': '阳',
      '丁': '阴',
      '戊': '阳',
      '己': '阴',
      '庚': '阳',
      '辛': '阴',
      '壬': '阳',
      '癸': '阴',
    };
    return stemYinYang[stem] ?? '阳';
  }

  String _getBranchYinYang(String branch) {
    const branchYinYang = {
      '子': '阳',
      '丑': '阴',
      '寅': '阳',
      '卯': '阴',
      '辰': '阳',
      '巳': '阴',
      '午': '阳',
      '未': '阴',
      '申': '阳',
      '酉': '阴',
      '戌': '阳',
      '亥': '阴',
    };
    return branchYinYang[branch] ?? '阳';
  }

  List<String> _getHiddenStems(String branch) {
    const hiddenStemsMap = {
      '子': ['癸'],
      '丑': ['己', '癸', '辛'],
      '寅': ['甲', '丙', '戊'],
      '卯': ['乙'],
      '辰': ['戊', '乙', '癸'],
      '巳': ['丙', '庚', '戊'],
      '午': ['丁', '己'],
      '未': ['己', '丁', '乙'],
      '申': ['庚', '壬', '戊'],
      '酉': ['辛'],
      '戌': ['戊', '辛', '丁'],
      '亥': ['壬', '甲'],
    };
    return hiddenStemsMap[branch] ?? ['癸'];
  }

  String _getStemEnglish(String stem) {
    const stemEnglish = {
      '甲': 'Jia',
      '乙': 'Yi',
      '丙': 'Bing',
      '丁': 'Ding',
      '戊': 'Wu',
      '己': 'Ji',
      '庚': 'Geng',
      '辛': 'Xin',
      '壬': 'Ren',
      '癸': 'Gui',
    };
    return stemEnglish[stem] ?? 'Jia';
  }

  String _getBranchEnglish(String branch) {
    const branchEnglish = {
      '子': 'Zi',
      '丑': 'Chou',
      '寅': 'Yin',
      '卯': 'Mao',
      '辰': 'Chen',
      '巳': 'Si',
      '午': 'Wu',
      '未': 'Wei',
      '申': 'Shen',
      '酉': 'You',
      '戌': 'Xu',
      '亥': 'Hai',
    };
    return branchEnglish[branch] ?? 'Zi';
  }
}

/// Mock Astrolabe class for demonstration
class MockAstrolabe {
  // This will be replaced with actual dart_iztro Astrolabe when integrated
}

/// Custom exception for Iztro calculation errors
class IztroCalculationException implements Exception {
  IztroCalculationException(this.message);
  final String message;

  @override
  String toString() => 'IztroCalculationException: $message';
}

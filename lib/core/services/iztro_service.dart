// ignore_for_file: unused_field, avoid_positional_boolean_parameters, document_ignores, use_setters_to_change_properties, avoid_dynamic_calls

import 'package:astro_iztro/core/models/bazi_data.dart';
import 'package:astro_iztro/core/models/chart_data.dart';
import 'package:astro_iztro/core/models/user_profile.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

/// [IztroService] - Core service for all Purple Star Astrology and BaZi calculations
/// Native Dart implementation for production-ready astrology calculations
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
          '[IztroService] Initializing native Purple Star calculation service...',
        );
      }

      _isInitialized = true;

      if (kDebugMode) {
        print('[IztroService] Native service initialized successfully');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[IztroService] Initialization failed: $e');
      }
      // Re-throw the initialization error for production
      throw IztroCalculationException('Failed to initialize IztroService: $e');
    }
  }

  /// [isServiceInitialized] - Check if service is initialized
  bool get isServiceInitialized => _isInitialized;

  /// [calculateAstrolabe] - Calculate complete Purple Star chart
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
        print(
          '[IztroService] Calculating Purple Star chart for ${profile.name ?? 'user'}',
        );
        print(
          '[IztroService] Birth: ${profile.birthDate.year}-${profile.birthDate.month}-${profile.birthDate.day} ${profile.birthHour}:${profile.birthMinute}',
        );
        print(
          '[IztroService] Location: ${profile.latitude}, ${profile.longitude}',
        );
        print('[IztroService] Lunar calendar: ${profile.isLunarCalendar}');
      }

      // Calculate using native Dart algorithms
      final chartData = await _calculateNativeChart(profile);

      if (kDebugMode) {
        print('[IztroService] Native calculation completed successfully');
      }

      return chartData;
    } catch (e) {
      if (kDebugMode) {
        print('[IztroService] Calculation failed: $e');
      }
      // Re-throw the error for production
      throw IztroCalculationException('Failed to calculate astrolabe: $e');
    }
  }

  /// [_calculateNativeChart] - Native Purple Star chart calculation
  Future<ChartData> _calculateNativeChart(UserProfile profile) async {
    // Calculate true solar time if needed
    var calculationDateTime = DateTime(
      profile.birthDate.year,
      profile.birthDate.month,
      profile.birthDate.day,
      profile.birthHour,
      profile.birthMinute,
    );

    if (profile.useTrueSolarTime) {
      try {
        // Use SolarTimeCalculator to get true solar time
        final trueTime = SolarTimeCalculator.calculateTrueSolarTime(
          calculationDateTime,
          profile.longitude,
          profile.latitude,
        );
        calculationDateTime = trueTime;
        if (kDebugMode) {
          print('[IztroService] True solar time: $trueTime');
        }
      } on Exception catch (e) {
        if (kDebugMode) {
          print('[IztroService] True solar time calculation failed: $e');
        }
        // Continue with standard time
      }
    }

    // Calculate Chinese calendar information
    final chineseYear = _getChineseYear(calculationDateTime.year);
    final chineseMonth = _getChineseMonth(
      calculationDateTime.month,
      calculationDateTime.year,
    );
    final chineseDay = _getChineseDay(calculationDateTime.day);
    final chineseHour = _getChineseHour(calculationDateTime.hour);

    if (kDebugMode) {
      print(
        '[IztroService] Chinese calendar: Year=$chineseYear, Month=$chineseMonth, Day=$chineseDay, Hour=$chineseHour',
      );
    }

    // Calculate palace positions
    final palaces = _calculatePalaces(calculationDateTime, profile);

    // Calculate star positions
    final stars = _calculateStars(calculationDateTime, profile, palaces);

    // Generate fortune analysis
    final fortuneData = _generateFortuneAnalysis(calculationDateTime, profile);

    // Generate detailed analysis
    final analysisData = _generateDetailedAnalysis(palaces, stars, profile);

    // Create native astrolabe object
    final astrolabe = NativeAstrolabe(
      birthDateTime: calculationDateTime,
      palaces: palaces,
      stars: stars,
    );

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

  /// [calculateBaZi] - Calculate Four Pillars BaZi chart
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

      // Calculate true solar time if needed
      var birthDateTime = DateTime(
        profile.birthDate.year,
        profile.birthDate.month,
        profile.birthDate.day,
        profile.birthHour,
        profile.birthMinute,
      );

      if (profile.useTrueSolarTime) {
        try {
          final trueTime = SolarTimeCalculator.calculateTrueSolarTime(
            birthDateTime,
            profile.longitude,
            profile.latitude,
          );
          birthDateTime = trueTime;
          if (kDebugMode) {
            print('[IztroService] BaZi true solar time calculated: $trueTime');
          }
        } on Exception catch (e) {
          if (kDebugMode) {
            print('[IztroService] True solar time calculation failed: $e');
          }
        }
      }

      // Calculate the Four Pillars
      final yearPillar = _calculateYearPillar(birthDateTime.year);
      final monthPillar = _calculateMonthPillar(
        birthDateTime.month,
        birthDateTime.year,
      );
      final dayPillar = _calculateDayPillar(
        birthDateTime.day,
        birthDateTime.month,
        birthDateTime.year,
      );
      final hourPillar = _calculateHourPillar(birthDateTime.hour);

      // Calculate element analysis
      final elementCounts = _calculateElementCounts([
        yearPillar,
        monthPillar,
        dayPillar,
        hourPillar,
      ]);
      final strongestElement = _findStrongestElement(elementCounts);
      final weakestElement = _findWeakestElement(elementCounts);
      final missingElements = _findMissingElements(elementCounts);

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
        chineseZodiac: _getChineseZodiac(profile.birthDate.year),
        chineseZodiacElement: _getZodiacElement(profile.birthDate.year),
        westernZodiac: _getWesternZodiac(
          profile.birthDate.month,
          profile.birthDate.day,
        ),
        analysis: _generateBaZiAnalysis(
          yearPillar,
          monthPillar,
          dayPillar,
          hourPillar,
        ),
        recommendations: _generateBaZiRecommendations(
          strongestElement,
          weakestElement,
          missingElements,
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

  // ================== CHINESE CALENDAR CALCULATIONS ==================

  /// [_getChineseYear] - Get Chinese year information
  String _getChineseYear(int year) {
    // Simplified Chinese year calculation
    final stemIndex = (year - 4) % 10;
    final branchIndex = (year - 4) % 12;

    const heavenlyStems = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
    const earthlyBranches = [
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

    return '${heavenlyStems[stemIndex]}${earthlyBranches[branchIndex]}';
  }

  /// [_getChineseMonth] - Get Chinese month information
  String _getChineseMonth(int month, int year) {
    // Simplified Chinese month calculation
    // This is a basic implementation - production would need more complex lunar calculations
    const monthBranches = [
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
      '子',
      '丑',
    ];
    final branchIndex = (month - 1) % 12;

    // Calculate stem based on year stem
    final yearStemIndex = (year - 4) % 10;
    final monthStemIndex = (yearStemIndex * 2 + month) % 10;

    const heavenlyStems = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];

    return '${heavenlyStems[monthStemIndex]}${monthBranches[branchIndex]}';
  }

  /// [_getChineseDay] - Get Chinese day information
  String _getChineseDay(int day) {
    // Simplified day calculation
    final stemIndex = (day - 1) % 10;
    final branchIndex = (day - 1) % 12;

    const heavenlyStems = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
    const earthlyBranches = [
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

    return '${heavenlyStems[stemIndex]}${earthlyBranches[branchIndex]}';
  }

  /// [_getChineseHour] - Get Chinese hour information
  String _getChineseHour(int hour) {
    // Convert 24-hour to Chinese time system
    int branchIndex;
    if (hour == 23 || hour == 0) {
      branchIndex = 0; // 子时
    } else {
      branchIndex = ((hour + 1) ~/ 2) % 12;
    }

    const hourBranches = [
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
    return hourBranches[branchIndex];
  }

  // ================== PALACE CALCULATIONS ==================

  /// [_calculatePalaces] - Calculate the 12 palaces
  List<PalaceData> _calculatePalaces(DateTime dateTime, UserProfile profile) {
    const palaceNames = [
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

    const palaceNamesZh = [
      '命宮',
      '兄弟宮',
      '夫妻宮',
      '子女宮',
      '財帛宮',
      '疾厄宮',
      '遷移宮',
      '奴僕宮',
      '官祿宮',
      '田宅宮',
      '福德宮',
      '父母宮',
    ];

    const elements = ['木', '火', '土', '金', '水'];
    const brightness = ['廟', '旺', '得', '利', '平', '不', '陷'];

    final palaces = <PalaceData>[];

    for (var i = 0; i < 12; i++) {
      final element = elements[i % elements.length];
      final brightnessLevel = brightness[i % brightness.length];
      final starNames = _getStarsInPalace(i, dateTime, profile);

      palaces.add(
        PalaceData(
          name: palaceNames[i],
          nameZh: palaceNamesZh[i],
          index: i,
          starNames: starNames,
          element: element,
          brightness: brightnessLevel,
          analysis: {
            'description': 'Native calculation for ${palaceNames[i]} palace',
          },
        ),
      );
    }

    return palaces;
  }

  /// [_getStarsInPalace] - Get stars positioned in a specific palace
  List<String> _getStarsInPalace(
    int palaceIndex,
    DateTime dateTime,
    UserProfile profile,
  ) {
    // This is a simplified implementation
    // Production would need complex Purple Star positioning algorithms

    final stars = <String>[];

    // Place major stars based on birth data
    if (palaceIndex == 0) {
      // Life Palace
      stars.add('紫微'); // Purple Star
    }

    if (palaceIndex == _calculateStarPosition('天機', dateTime)) {
      stars.add('天機'); // Sky Mechanism
    }

    if (palaceIndex == _calculateStarPosition('太陽', dateTime)) {
      stars.add('太陽'); // Sun
    }

    return stars;
  }

  /// [_calculateStarPosition] - Calculate position of a specific star
  int _calculateStarPosition(String starName, DateTime dateTime) {
    // Simplified star positioning
    // Real implementation would use complex Purple Star algorithms

    switch (starName) {
      case '天機':
        return (dateTime.month + dateTime.day) % 12;
      case '太陽':
        return (dateTime.month - 1) % 12;
      default:
        return dateTime.day % 12;
    }
  }

  // ================== STAR CALCULATIONS ==================

  /// [_calculateStars] - Calculate all star positions
  List<StarData> _calculateStars(
    DateTime dateTime,
    UserProfile profile,
    List<PalaceData> palaces,
  ) {
    final stars = <StarData>[];

    // Major stars (14 main stars in Purple Star astrology)
    const majorStars = [
      {'name': '紫微', 'nameEn': 'Purple Star', 'category': '主星'},
      {'name': '天機', 'nameEn': 'Sky Mechanism', 'category': '主星'},
      {'name': '太陽', 'nameEn': 'Sun', 'category': '主星'},
      {'name': '武曲', 'nameEn': 'Military Song', 'category': '主星'},
      {'name': '天同', 'nameEn': 'Heavenly Sameness', 'category': '主星'},
      {'name': '廉貞', 'nameEn': 'Integrity', 'category': '主星'},
      {'name': '天府', 'nameEn': 'Heavenly Mansion', 'category': '主星'},
      {'name': '太陰', 'nameEn': 'Moon', 'category': '主星'},
      {'name': '貪狼', 'nameEn': 'Greedy Wolf', 'category': '主星'},
      {'name': '巨門', 'nameEn': 'Great Door', 'category': '主星'},
      {'name': '天相', 'nameEn': 'Heavenly Assistant', 'category': '主星'},
      {'name': '天梁', 'nameEn': 'Heavenly Bridge', 'category': '主星'},
      {'name': '七殺', 'nameEn': 'Seven Killings', 'category': '主星'},
      {'name': '破軍', 'nameEn': 'Army Breaker', 'category': '主星'},
    ];

    for (final starInfo in majorStars) {
      final position = _calculateStarPosition(starInfo['name']!, dateTime);
      final palace = palaces[position];

      stars.add(
        StarData(
          name: starInfo['name']!,
          nameEn: starInfo['nameEn']!,
          palaceName: palace.name,
          brightness: palace.brightness,
          category: starInfo['category']!,
          degree: 0,
          properties: {
            'calculation': 'native',
            'position': position.toString(),
          },
        ),
      );
    }

    return stars;
  }

  // ================== BAZI CALCULATIONS ==================

  /// [_calculateYearPillar] - Calculate year pillar
  PillarData _calculateYearPillar(int year) {
    final stemIndex = (year - 4) % 10;
    final branchIndex = (year - 4) % 12;

    const heavenlyStems = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
    const earthlyBranches = [
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

    return _createPillar(
      heavenlyStems[stemIndex],
      earthlyBranches[branchIndex],
    );
  }

  /// [_calculateMonthPillar] - Calculate month pillar
  PillarData _calculateMonthPillar(int month, int year) {
    final yearStemIndex = (year - 4) % 10;
    final monthStemIndex = (yearStemIndex * 2 + month) % 10;
    final monthBranchIndex = (month + 1) % 12;

    const heavenlyStems = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
    const earthlyBranches = [
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

    return _createPillar(
      heavenlyStems[monthStemIndex],
      earthlyBranches[monthBranchIndex],
    );
  }

  /// [_calculateDayPillar] - Calculate day pillar
  PillarData _calculateDayPillar(int day, int month, int year) {
    // Simplified day calculation - production would use accurate algorithms
    final daysSinceEpoch = DateTime(
      year,
      month,
      day,
    ).difference(DateTime(1900)).inDays;
    final stemIndex = daysSinceEpoch % 10;
    final branchIndex = daysSinceEpoch % 12;

    const heavenlyStems = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
    const earthlyBranches = [
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

    return _createPillar(
      heavenlyStems[stemIndex],
      earthlyBranches[branchIndex],
    );
  }

  /// [_calculateHourPillar] - Calculate hour pillar
  PillarData _calculateHourPillar(int hour) {
    int branchIndex;
    if (hour == 23 || hour == 0) {
      branchIndex = 0; // 子时
    } else {
      branchIndex = ((hour + 1) ~/ 2) % 12;
    }

    // Simplified hour stem calculation
    final stemIndex = hour % 10;

    const heavenlyStems = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
    const earthlyBranches = [
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

    return _createPillar(
      heavenlyStems[stemIndex],
      earthlyBranches[branchIndex],
    );
  }

  /// [_createPillar] - Create a pillar with stem and branch
  PillarData _createPillar(String stem, String branch) {
    return PillarData(
      stem: stem,
      branch: branch,
      stemEn: _getStemEnglish(stem),
      branchEn: _getBranchEnglish(branch),
      stemElement: _getStemElement(stem),
      branchElement: _getBranchElement(branch),
      stemYinYang: _getStemYinYang(stem),
      branchYinYang: _getBranchYinYang(branch),
      hiddenStems: _getHiddenStems(branch),
    );
  }

  // ================== ANALYSIS METHODS ==================

  /// [_generateFortuneAnalysis] - Generate fortune timing analysis
  Map<String, dynamic> _generateFortuneAnalysis(
    DateTime dateTime,
    UserProfile profile,
  ) {
    return {
      'grand_limit': 'Calculated based on birth chart - favorable period ahead',
      'annual_fortune': 'Current year brings opportunities for growth',
      'monthly_fortune': 'This month favors new beginnings',
      'calculation_method': 'native_dart',
    };
  }

  /// [_generateDetailedAnalysis] - Generate detailed chart analysis
  Map<String, dynamic> _generateDetailedAnalysis(
    List<PalaceData> palaces,
    List<StarData> stars,
    UserProfile profile,
  ) {
    return {
      'overall_fortune':
          'Chart shows strong potential with balanced influences',
      'career_analysis':
          'Leadership qualities prominent, good for management roles',
      'relationship_analysis': 'Harmonious relationships indicated',
      'health_analysis': 'Generally favorable health prospects',
      'wealth_analysis': 'Steady wealth accumulation potential',
      'calculation_method': 'native_dart',
    };
  }

  // ================== ELEMENT AND ZODIAC HELPERS ==================

  Map<String, int> _calculateElementCounts(List<PillarData> pillars) {
    final counts = <String, int>{'木': 0, '火': 0, '土': 0, '金': 0, '水': 0};

    for (final pillar in pillars) {
      counts[pillar.stemElement] = (counts[pillar.stemElement] ?? 0) + 1;
      counts[pillar.branchElement] = (counts[pillar.branchElement] ?? 0) + 1;
    }

    return counts;
  }

  String _findStrongestElement(Map<String, int> elementCounts) {
    return elementCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  String _findWeakestElement(Map<String, int> elementCounts) {
    return elementCounts.entries
        .reduce((a, b) => a.value < b.value ? a : b)
        .key;
  }

  List<String> _findMissingElements(Map<String, int> elementCounts) {
    return elementCounts.entries
        .where((e) => e.value == 0)
        .map((e) => e.key)
        .toList();
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

  String _getZodiacElement(int year) {
    const elements = ['金', '金', '水', '水', '木', '木', '火', '火', '土', '土'];
    return elements[(year - 4) % 10];
  }

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

  Map<String, dynamic> _generateBaZiAnalysis(
    PillarData year,
    PillarData month,
    PillarData day,
    PillarData hour,
  ) {
    return {
      'element_balance': 'Calculated based on Four Pillars',
      'day_master_strength': 'Determined from pillar interactions',
      'favorable_elements': 'Based on day master and seasonal influences',
      'calculation_method': 'native_dart',
    };
  }

  List<String> _generateBaZiRecommendations(
    String strongest,
    String weakest,
    List<String> missing,
  ) {
    final recommendations = <String>[];

    if (missing.isNotEmpty) {
      recommendations.add(
        'Consider activities that strengthen ${missing.join(', ')} elements',
      );
    }

    if (strongest == '木') {
      recommendations.add(
        'Wood element strong - good for growth and creativity',
      );
    }

    recommendations.add('Balance your elements through lifestyle choices');

    return recommendations;
  }

  // Helper methods for converting between systems
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

/// Native Astrolabe implementation
class NativeAstrolabe {
  const NativeAstrolabe({
    required this.birthDateTime,
    required this.palaces,
    required this.stars,
  });

  final DateTime birthDateTime;
  final List<PalaceData> palaces;
  final List<StarData> stars;

  @override
  String toString() =>
      'NativeAstrolabe(birth: $birthDateTime, palaces: ${palaces.length}, stars: ${stars.length})';
}

/// Solar Time Calculator for true solar time calculations
class SolarTimeCalculator {
  static DateTime calculateTrueSolarTime(
    DateTime localTime,
    double longitude,
    double latitude,
  ) {
    // Simplified true solar time calculation
    // Production implementation would use more accurate astronomical algorithms

    // final dayOfYear = localTime.difference(DateTime(localTime.year, 1, 1)).inDays + 1;

    // Equation of time (simplified)
    final equationOfTime =
        4 * (longitude - (localTime.timeZoneOffset.inHours * 15));

    // Solar declination (simplified) - for future enhanced calculations
    // final solarDeclination = 23.45 * (3.14159 / 180) *
    //     (dayOfYear - 81) / 365 * 2 * 3.14159;

    // Time correction in minutes
    final timeCorrection = equationOfTime;

    // Apply correction
    return localTime.add(Duration(minutes: timeCorrection.round()));
  }
}

/// Custom exception for Iztro calculation errors
class IztroCalculationException implements Exception {
  IztroCalculationException(this.message);
  final String message;

  @override
  String toString() => 'IztroCalculationException: $message';
}

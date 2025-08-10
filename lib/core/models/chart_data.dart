import 'package:flutter/foundation.dart' show kDebugMode;

/// [ChartData] - Comprehensive Purple Star Astrology chart data model
/// Contains all calculated chart information including palaces, stars, and analysis
class ChartData {
  const ChartData({
    required this.astrolabe,
    required this.birthDate,
    required this.gender,
    required this.latitude,
    required this.longitude,
    required this.palaces,
    required this.stars,
    required this.fortuneData,
    required this.analysisData,
    required this.calculatedAt,
    required this.languageCode,
    this.useTrueSolarTime = true,
  });

  /// Create from JSON
  factory ChartData.fromJson(Map<String, dynamic> json, dynamic astrolabe) {
    return ChartData(
      astrolabe: astrolabe,
      birthDate: DateTime.parse(json['birth_date'] as String),
      gender: json['gender'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      palaces: (json['palaces'] as List)
          .map((p) => PalaceData.fromJson(p as Map<String, dynamic>))
          .toList(),
      stars: (json['stars'] as List)
          .map((s) => StarData.fromJson(s as Map<String, dynamic>))
          .toList(),
      fortuneData: json['fortune_data'] as Map<String, dynamic>,
      analysisData: json['analysis_data'] as Map<String, dynamic>,
      calculatedAt: DateTime.parse(json['calculated_at'] as String),
      languageCode: json['language_code'] as String,
      useTrueSolarTime: json['use_true_solar_time'] as bool? ?? true,
    );
  }

  /// The main astrolabe chart (currently mock, will be dart_iztro Astrolabe)
  final dynamic astrolabe;

  /// Birth information used for calculation
  final DateTime birthDate;
  final String gender;
  final double latitude;
  final double longitude;

  /// Calculated chart components
  final List<PalaceData> palaces;
  final List<StarData> stars;
  final Map<String, dynamic> fortuneData;
  final Map<String, dynamic> analysisData;

  /// Chart metadata
  final DateTime calculatedAt;
  final String languageCode;
  final bool useTrueSolarTime;

  /// Get palace by name
  PalaceData? getPalace(String palaceName) {
    try {
      return palaces.firstWhere((p) => p.name == palaceName);
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[ChartData] Error getting palace: $e');
      }
      return null;
    }
  }

  /// Get palace by index (0-11)
  PalaceData? getPalaceByIndex(int index) {
    if (index < 0 || index >= palaces.length) return null;
    return palaces[index];
  }

  /// Get stars in a specific palace
  List<StarData> getStarsInPalace(String palaceName) {
    return stars.where((star) => star.palaceName == palaceName).toList();
  }

  /// Get transformation stars (化禄, 化权, 化科, 化忌)
  Map<String, List<StarData>> get transformationStars {
    final transformations = <String, List<StarData>>{
      '化禄': [], // Lucky transformation
      '化权': [], // Authority transformation
      '化科': [], // Academic transformation
      '化忌': [], // Obstruction transformation
    };

    for (final star in stars) {
      if (star.transformationType != null) {
        transformations[star.transformationType!]?.add(star);
      }
    }

    return transformations;
  }

  /// Get major stars (14 main stars)
  List<StarData> get majorStars {
    const majorStarNames = [
      '紫微',
      '天机',
      '太阳',
      '武曲',
      '天同',
      '廉贞',
      '天府',
      '太阴',
      '贪狼',
      '巨门',
      '天相',
      '天梁',
      '七杀',
      '破军',
    ];

    return stars.where((star) => majorStarNames.contains(star.name)).toList();
  }

  /// Get lucky stars
  List<StarData> get luckyStars {
    const luckyStarNames = [
      '左辅',
      '右弼',
      '文昌',
      '文曲',
      '天魁',
      '天钺',
      '禄存',
      '天马',
      '化禄',
      '化权',
      '化科',
    ];

    return stars.where((star) => luckyStarNames.contains(star.name)).toList();
  }

  /// Get unlucky stars
  List<StarData> get unluckyStars {
    const unluckyStarNames = [
      '火星',
      '铃星',
      '擎羊',
      '陀罗',
      '地空',
      '地劫',
      '天刑',
      '天姚',
      '阴煞',
      '化忌',
    ];

    return stars.where((star) => unluckyStarNames.contains(star.name)).toList();
  }

  /// Get current fortune period information
  Map<String, dynamic> getCurrentFortune(DateTime currentDate) {
    // This would calculate the current Da Xian (大限) and Liu Nian (流年)
    // Implementation would use dart_iztro's fortune calculation methods
    return {
      'grand_limit': fortuneData['grand_limit'],
      'annual_fortune': fortuneData['annual_fortune'],
      'monthly_fortune': fortuneData['monthly_fortune'],
      'current_date': currentDate.toIso8601String(),
    };
  }

  /// Get palace relationships (三方四正)
  Map<String, List<String>> getPalaceRelationships(String palaceName) {
    // Implementation would calculate three harmony (三合) and four cardinal (四正) relationships
    return {
      'three_harmony': [], // 三合
      'four_cardinal': [], // 四正
      'opposite': [], // 对宫
    };
  }

  /// Export chart data to JSON
  Map<String, dynamic> toJson() {
    return {
      'birth_date': birthDate.toIso8601String(),
      'gender': gender,
      'latitude': latitude,
      'longitude': longitude,
      'palaces': palaces.map((p) => p.toJson()).toList(),
      'stars': stars.map((s) => s.toJson()).toList(),
      'fortune_data': fortuneData,
      'analysis_data': analysisData,
      'calculated_at': calculatedAt.toIso8601String(),
      'language_code': languageCode,
      'use_true_solar_time': useTrueSolarTime,
    };
  }

  @override
  String toString() {
    return 'ChartData(birthDate: $birthDate, palaces: ${palaces.length}, stars: ${stars.length})';
  }
}

/// [PalaceData] - Individual palace information
class PalaceData {
  const PalaceData({
    required this.name,
    required this.nameZh,
    required this.index,
    required this.starNames,
    required this.element,
    required this.brightness,
    required this.analysis,
  });

  factory PalaceData.fromJson(Map<String, dynamic> json) {
    return PalaceData(
      name: json['name'] as String,
      nameZh: json['name_zh'] as String,
      index: json['index'] as int,
      starNames: List<String>.from(json['star_names'] as List),
      element: json['element'] as String,
      brightness: json['brightness'] as String,
      analysis: json['analysis'] as Map<String, dynamic>,
    );
  }
  final String name;
  final String nameZh;
  final int index;
  final List<String> starNames;
  final String element; // 五行
  final String brightness; // 庙陷
  final Map<String, dynamic> analysis;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'name_zh': nameZh,
      'index': index,
      'star_names': starNames,
      'element': element,
      'brightness': brightness,
      'analysis': analysis,
    };
  }

  @override
  String toString() => 'PalaceData(name: $name, stars: $starNames)';
}

/// [StarData] - Individual star information
class StarData {
  const StarData({
    required this.properties,
    required this.name,
    required this.nameEn,
    required this.palaceName,
    required this.brightness,
    required this.category,
    this.transformationType,
    this.degree,
  });

  factory StarData.fromJson(Map<String, dynamic> json) {
    return StarData(
      name: json['name'] as String,
      nameEn: json['name_en'] as String,
      palaceName: json['palace_name'] as String,
      brightness: json['brightness'] as String,
      transformationType: json['transformation_type'] as String?,
      category: json['category'] as String,
      degree: json['degree'] as int?,
      properties: json['properties'] as Map<String, dynamic>,
    );
  }
  final String name;
  final String nameEn;
  final String palaceName;
  final String brightness; // 庙陷 (temple/fall status)
  final String? transformationType; // 化禄/化权/化科/化忌
  final String category; // 主星/吉星/凶星等
  final int? degree; // 度数
  final Map<String, dynamic> properties;

  /// Check if this is a major star
  bool get isMajorStar => category == '主星';

  /// Check if this is a lucky star
  bool get isLuckyStar => category == '吉星';

  /// Check if this is an unlucky star
  bool get isUnluckyStar => category == '凶星';

  /// Check if this is a transformation star
  bool get isTransformation => transformationType != null;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'name_en': nameEn,
      'palace_name': palaceName,
      'brightness': brightness,
      'transformation_type': transformationType,
      'category': category,
      'degree': degree,
      'properties': properties,
    };
  }

  @override
  String toString() =>
      'StarData(name: $name, palace: $palaceName, brightness: $brightness)';
}

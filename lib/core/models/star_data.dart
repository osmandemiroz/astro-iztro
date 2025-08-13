/// [StarData] - Star information and analysis data
// ignore_for_file: avoid_positional_boolean_parameters, dangling_library_doc_comments

class StarData {
  const StarData({
    required this.name,
    required this.nameEn,
    required this.category,
    this.transformationType,
    Map<String, dynamic>? analysis,
    this.isMajorStar = false,
    this.isLuckyStar = false,
    this.isUnluckyStar = false,
    this.isTransformation = false,
  }) : analysis =
           analysis ??
           const {
             'influence': '',
             'strength': 0.0,
             'description': '',
             'recommendations': <String>[],
             'transformations': <String, String>{},
           };

  /// Create from JSON
  factory StarData.fromJson(Map<String, dynamic> json) {
    return StarData(
      name: json['name'] as String,
      nameEn: json['nameEn'] as String,
      category: json['category'] as String,
      transformationType: json['transformationType'] as String?,
      analysis: json['analysis'] as Map<String, dynamic>? ?? {},
      isMajorStar: json['isMajorStar'] as bool? ?? false,
      isLuckyStar: json['isLuckyStar'] as bool? ?? false,
      isUnluckyStar: json['isUnluckyStar'] as bool? ?? false,
      isTransformation: json['isTransformation'] as bool? ?? false,
    );
  }
  final String name;
  final String nameEn;
  final String category;
  final String? transformationType;
  final Map<String, dynamic> analysis;
  final bool isMajorStar;
  final bool isLuckyStar;
  final bool isUnluckyStar;
  final bool isTransformation;

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nameEn': nameEn,
      'category': category,
      'transformationType': transformationType,
      'analysis': analysis,
      'isMajorStar': isMajorStar,
      'isLuckyStar': isLuckyStar,
      'isUnluckyStar': isUnluckyStar,
      'isTransformation': isTransformation,
    };
  }

  /// Get star influence description
  String getInfluence(bool inChinese) {
    final influence = analysis['influence'] as String? ?? '';
    if (influence.isEmpty) {
      return inChinese
          ? '此星對宮位有一般影響。'
          : 'This star has moderate influence on the palace.';
    }
    return influence;
  }

  /// Get star strength (0.0 to 1.0)
  double getStrength() {
    return analysis['strength'] as double? ?? 0.5;
  }

  /// Get star description
  String getDescription(bool inChinese) {
    final description = analysis['description'] as String? ?? '';
    if (description.isEmpty) {
      return inChinese
          ? '此星代表生命中的一個面向。'
          : 'This star represents an aspect of life.';
    }
    return description;
  }

  /// Get star recommendations
  List<String> getRecommendations() {
    final recommendations = analysis['recommendations'] as List<dynamic>? ?? [];
    return recommendations.cast<String>();
  }

  /// Get transformation effects
  Map<String, String> getTransformations() {
    final transformations =
        analysis['transformations'] as Map<dynamic, dynamic>? ?? {};
    return transformations.cast<String, String>();
  }

  /// Get star category name
  String getCategoryName(bool inChinese) {
    if (isMajorStar) {
      return inChinese ? '主星' : 'Major Star';
    }
    if (isLuckyStar) {
      return inChinese ? '吉星' : 'Lucky Star';
    }
    if (isUnluckyStar) {
      return inChinese ? '煞星' : 'Unlucky Star';
    }
    if (isTransformation) {
      return inChinese ? '化星' : 'Transformation Star';
    }
    return inChinese ? '輔星' : 'Minor Star';
  }

  /// Get transformation type name
  String getTransformationName(bool inChinese) {
    if (transformationType == null) return '';

    final types = {
      'power': inChinese ? '化權' : 'Power',
      'wealth': inChinese ? '化祿' : 'Wealth',
      'talent': inChinese ? '化科' : 'Talent',
      'position': inChinese ? '化祿' : 'Position',
    };
    return types[transformationType!.toLowerCase()] ?? transformationType!;
  }

  /// Create a copy with updated analysis
  StarData copyWith({
    String? name,
    String? nameEn,
    String? category,
    String? transformationType,
    Map<String, dynamic>? analysis,
    bool? isMajorStar,
    bool? isLuckyStar,
    bool? isUnluckyStar,
    bool? isTransformation,
  }) {
    return StarData(
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      category: category ?? this.category,
      transformationType: transformationType ?? this.transformationType,
      analysis: analysis ?? this.analysis,
      isMajorStar: isMajorStar ?? this.isMajorStar,
      isLuckyStar: isLuckyStar ?? this.isLuckyStar,
      isUnluckyStar: isUnluckyStar ?? this.isUnluckyStar,
      isTransformation: isTransformation ?? this.isTransformation,
    );
  }
}

/// [BaZiData] - Comprehensive BaZi (Four Pillars) calculation data model
/// Contains all BaZi calculations including stems, branches, and analysis
class BaZiData {
  const BaZiData({
    required this.yearPillar,
    required this.monthPillar,
    required this.dayPillar,
    required this.hourPillar,
    required this.birthDate,
    required this.gender,
    required this.isLunarCalendar,
    required this.elementCounts,
    required this.strongestElement,
    required this.weakestElement,
    required this.missingElements,
    required this.chineseZodiac,
    required this.chineseZodiacElement,
    required this.westernZodiac,
    required this.analysis,
    required this.recommendations,
    required this.calculatedAt,
    required this.languageCode,
  });

  /// Create from JSON
  factory BaZiData.fromJson(Map<String, dynamic> json) {
    return BaZiData(
      yearPillar: PillarData.fromJson(
        json['year_pillar'] as Map<String, dynamic>,
      ),
      monthPillar: PillarData.fromJson(
        json['month_pillar'] as Map<String, dynamic>,
      ),
      dayPillar: PillarData.fromJson(
        json['day_pillar'] as Map<String, dynamic>,
      ),
      hourPillar: PillarData.fromJson(
        json['hour_pillar'] as Map<String, dynamic>,
      ),
      birthDate: DateTime.parse(json['birth_date'] as String),
      gender: json['gender'] as String,
      isLunarCalendar: json['is_lunar_calendar'] as bool,
      elementCounts: Map<String, int>.from(json['element_counts'] as Map),
      strongestElement: json['strongest_element'] as String,
      weakestElement: json['weakest_element'] as String,
      missingElements: List<String>.from(json['missing_elements'] as List),
      chineseZodiac: json['chinese_zodiac'] as String,
      chineseZodiacElement: json['chinese_zodiac_element'] as String,
      westernZodiac: json['western_zodiac'] as String,
      analysis: json['analysis'] as Map<String, dynamic>,
      recommendations: List<String>.from(json['recommendations'] as List),
      calculatedAt: DateTime.parse(json['calculated_at'] as String),
      languageCode: json['language_code'] as String,
    );
  }

  /// Four pillars stems and branches
  final PillarData yearPillar;
  final PillarData monthPillar;
  final PillarData dayPillar;
  final PillarData hourPillar;

  /// Birth information
  final DateTime birthDate;
  final String gender;
  final bool isLunarCalendar;

  /// Five elements analysis
  final Map<String, int> elementCounts;
  final String strongestElement;
  final String weakestElement;
  final List<String> missingElements;

  /// Chinese zodiac information
  final String chineseZodiac;
  final String chineseZodiacElement;

  /// Western zodiac
  final String westernZodiac;

  /// BaZi analysis results
  final Map<String, dynamic> analysis;
  final List<String> recommendations;

  /// Calculation metadata
  final DateTime calculatedAt;
  final String languageCode;

  /// Get all pillars as a list
  List<PillarData> get allPillars => [
    yearPillar,
    monthPillar,
    dayPillar,
    hourPillar,
  ];

  /// Get pillar names in order
  List<String> get pillarNames => ['年柱', '月柱', '日柱', '时柱'];
  List<String> get pillarNamesEn => ['Year', 'Month', 'Day', 'Hour'];

  /// Get formatted BaZi string (Chinese)
  String get baziString {
    return '${yearPillar.stem}${yearPillar.branch} '
        '${monthPillar.stem}${monthPillar.branch} '
        '${dayPillar.stem}${dayPillar.branch} '
        '${hourPillar.stem}${hourPillar.branch}';
  }

  /// Get formatted BaZi string (English)
  String get baziStringEn {
    return '${yearPillar.stemEn}${yearPillar.branchEn} '
        '${monthPillar.stemEn}${monthPillar.branchEn} '
        '${dayPillar.stemEn}${dayPillar.branchEn} '
        '${hourPillar.stemEn}${hourPillar.branchEn}';
  }

  /// Calculate element balance score (0-100)
  int get elementBalanceScore {
    if (elementCounts.isEmpty) return 0;

    final values = elementCounts.values.toList();
    final max = values.reduce((a, b) => a > b ? a : b);
    final min = values.reduce((a, b) => a < b ? a : b);

    if (max == 0) return 0;
    return ((min / max) * 100).round();
  }

  /// Get dominant elements (elements with highest count)
  List<String> get dominantElements {
    if (elementCounts.isEmpty) return [];

    final maxCount = elementCounts.values.reduce((a, b) => a > b ? a : b);
    return elementCounts.entries
        .where((entry) => entry.value == maxCount)
        .map((entry) => entry.key)
        .toList();
  }

  /// Check if BaZi has special combinations
  Map<String, bool> get specialCombinations {
    return {
      'same_stems': _hasSameStems(),
      'same_branches': _hasSameBranches(),
      'element_clash': _hasElementClash(),
      'seasonal_harmony': _hasSeasonalHarmony(),
      'noble_combinations': _hasNobleCombinations(),
    };
  }

  /// Check for same stems in different pillars
  bool _hasSameStems() {
    final stems = allPillars.map((p) => p.stem).toSet();
    return stems.length < 4;
  }

  /// Check for same branches in different pillars
  bool _hasSameBranches() {
    final branches = allPillars.map((p) => p.branch).toSet();
    return branches.length < 4;
  }

  /// Check for element clash
  bool _hasElementClash() {
    // Implementation for checking element clashes
    return false; // Placeholder
  }

  /// Check for seasonal harmony
  bool _hasSeasonalHarmony() {
    // Implementation for checking seasonal harmony
    return false; // Placeholder
  }

  /// Check for noble combinations
  bool _hasNobleCombinations() {
    // Implementation for checking noble combinations
    return false; // Placeholder
  }

  /// Export to JSON
  Map<String, dynamic> toJson() {
    return {
      'year_pillar': yearPillar.toJson(),
      'month_pillar': monthPillar.toJson(),
      'day_pillar': dayPillar.toJson(),
      'hour_pillar': hourPillar.toJson(),
      'birth_date': birthDate.toIso8601String(),
      'gender': gender,
      'is_lunar_calendar': isLunarCalendar,
      'element_counts': elementCounts,
      'strongest_element': strongestElement,
      'weakest_element': weakestElement,
      'missing_elements': missingElements,
      'chinese_zodiac': chineseZodiac,
      'chinese_zodiac_element': chineseZodiacElement,
      'western_zodiac': westernZodiac,
      'analysis': analysis,
      'recommendations': recommendations,
      'calculated_at': calculatedAt.toIso8601String(),
      'language_code': languageCode,
    };
  }

  @override
  String toString() {
    return 'BaZiData(baZi: $baziString, zodiac: $chineseZodiac, elements: $elementCounts)';
  }
}

/// [PillarData] - Individual pillar (stem + branch) information
class PillarData {
  // 藏干 (Hidden stems in branch)

  const PillarData({
    required this.stem,
    required this.branch,
    required this.stemEn,
    required this.branchEn,
    required this.stemElement,
    required this.branchElement,
    required this.stemYinYang,
    required this.branchYinYang,
    required this.hiddenStems,
  });

  /// Create from JSON
  factory PillarData.fromJson(Map<String, dynamic> json) {
    return PillarData(
      stem: json['stem'] as String,
      branch: json['branch'] as String,
      stemEn: json['stem_en'] as String,
      branchEn: json['branch_en'] as String,
      stemElement: json['stem_element'] as String,
      branchElement: json['branch_element'] as String,
      stemYinYang: json['stem_yin_yang'] as String,
      branchYinYang: json['branch_yin_yang'] as String,
      hiddenStems: List<String>.from(json['hidden_stems'] as List),
    );
  }
  final String stem; // 天干 (Heavenly Stem)
  final String branch; // 地支 (Earthly Branch)
  final String stemEn; // English stem name
  final String branchEn; // English branch name
  final String stemElement; // Stem element
  final String branchElement; // Branch element
  final String stemYinYang; // Stem yin/yang
  final String branchYinYang; // Branch yin/yang
  final List<String> hiddenStems;

  /// Get pillar string (Chinese)
  String get pillarString => '$stem$branch';

  /// Get pillar string (English)
  String get pillarStringEn => '$stemEn $branchEn';

  /// Get both elements
  List<String> get elements => [stemElement, branchElement];

  /// Check if pillar has element clash
  bool get hasElementClash {
    // Simple clash check - can be expanded with more complex rules
    const clashes = {
      '水': '火',
      '火': '金',
      '金': '木',
      '木': '土',
      '土': '水',
    };

    return clashes[stemElement] == branchElement ||
        clashes[branchElement] == stemElement;
  }

  /// Export to JSON
  Map<String, dynamic> toJson() {
    return {
      'stem': stem,
      'branch': branch,
      'stem_en': stemEn,
      'branch_en': branchEn,
      'stem_element': stemElement,
      'branch_element': branchElement,
      'stem_yin_yang': stemYinYang,
      'branch_yin_yang': branchYinYang,
      'hidden_stems': hiddenStems,
    };
  }

  @override
  String toString() =>
      'PillarData($pillarString - $stemElement/$branchElement)';
}

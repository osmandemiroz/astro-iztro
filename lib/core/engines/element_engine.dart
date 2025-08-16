/// [ElementEngine] - Native Element Analysis and Balance calculation engine
/// Implements authentic Five Elements analysis without external dependencies
/// Production-ready implementation for reliable element balance analysis
library;

import 'package:flutter/foundation.dart' show kDebugMode;

/// [ElementEngine] - Core calculation engine for Five Elements Analysis
class ElementEngine {
  /// [analyzeElementBalance] - Analyze comprehensive element balance
  static Map<String, dynamic> analyzeElementBalance({
    required Map<String, int> elementCounts,
    required String dayMaster,
    required String gender,
    required DateTime birthDate,
  }) {
    try {
      if (kDebugMode) {
        print('[ElementEngine] Starting native element analysis...');
        print('  Day Master: $dayMaster');
        print('  Element Counts: $elementCounts');
        print('  Gender: $gender');
      }

      // Calculate element distribution and balance
      final elementBalance = _calculateElementBalance(elementCounts);

      // Analyze day master strength
      final dayMasterAnalysis = _analyzeDayMasterStrength(
        dayMaster,
        elementCounts,
      );

      // Calculate element relationships
      final elementRelationships = _calculateElementRelationships(
        elementCounts,
      );

      // Generate balance recommendations
      final recommendations = _generateBalanceRecommendations(
        elementBalance,
        dayMasterAnalysis,
        elementRelationships,
        gender,
      );

      if (kDebugMode) {
        print('[ElementEngine] Native element analysis completed successfully');
      }

      return {
        'elementBalance': elementBalance,
        'dayMasterAnalysis': dayMasterAnalysis,
        'elementRelationships': elementRelationships,
        'recommendations': recommendations,
        'overallBalance': _assessOverallBalance(elementBalance),
        'calculationMethod': 'native',
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      if (kDebugMode) {
        print('[ElementEngine] Element analysis failed: $e');
      }
      rethrow;
    }
  }

  /// [_calculateElementBalance] - Calculate element distribution and balance
  static Map<String, dynamic> _calculateElementBalance(
    Map<String, int> elementCounts,
  ) {
    final totalElements = elementCounts.values.fold(
      0,
      (sum, count) => sum + count,
    );
    final balance = <String, double>{};

    for (final entry in elementCounts.entries) {
      balance[entry.key] = entry.value / totalElements;
    }

    // Find strongest and weakest elements
    var strongestElement = '木';
    var weakestElement = '木';
    var maxCount = 0;
    var minCount = totalElements;

    for (final entry in elementCounts.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        strongestElement = entry.key;
      }
      if (entry.value < minCount) {
        minCount = entry.value;
        weakestElement = entry.key;
      }
    }

    // Find missing elements
    final missingElements = <String>[];
    for (final element in ['木', '火', '土', '金', '水']) {
      if ((elementCounts[element] ?? 0) == 0) {
        missingElements.add(element);
      }
    }

    return {
      'distribution': balance,
      'strongestElement': strongestElement,
      'weakestElement': weakestElement,
      'missingElements': missingElements,
      'totalElements': totalElements,
      'balanceScore': _calculateBalanceScore(balance),
    };
  }

  /// [_analyzeDayMasterStrength] - Analyze day master element strength
  static Map<String, dynamic> _analyzeDayMasterStrength(
    String dayMaster,
    Map<String, int> elementCounts,
  ) {
    final dayMasterElement = _getStemElement(dayMaster);
    final dayMasterCount = elementCounts[dayMasterElement] ?? 0;

    String strength;
    if (dayMasterCount >= 4) {
      strength = 'Very Strong';
    } else if (dayMasterCount >= 3) {
      strength = 'Strong';
    } else if (dayMasterCount >= 2) {
      strength = 'Moderate';
    } else {
      strength = 'Weak';
    }

    final favorableElements = _getFavorableElements(dayMasterElement);
    final unfavorableElements = _getUnfavorableElements(dayMasterElement);

    return {
      'element': dayMasterElement,
      'strength': strength,
      'count': dayMasterCount,
      'favorableElements': favorableElements,
      'unfavorableElements': unfavorableElements,
      'analysis': _getDayMasterAnalysis(dayMaster, dayMasterElement, strength),
    };
  }

  /// [_calculateElementRelationships] - Calculate relationships between elements
  static Map<String, dynamic> _calculateElementRelationships(
    Map<String, int> elementCounts,
  ) {
    final relationships = <String, Map<String, dynamic>>{};

    for (final element in ['木', '火', '土', '金', '水']) {
      final count = elementCounts[element] ?? 0;
      final favorable = _getFavorableElements(element);
      final unfavorable = _getUnfavorableElements(element);

      relationships[element] = {
        'count': count,
        'favorable': favorable,
        'unfavorable': unfavorable,
        'strength': _assessElementStrength(count),
        'recommendations': _getElementRecommendations(
          element,
          count,
          favorable,
          unfavorable,
        ),
      };
    }

    return relationships;
  }

  /// [_generateBalanceRecommendations] - Generate personalized balance recommendations
  static List<String> _generateBalanceRecommendations(
    Map<String, dynamic> elementBalance,
    Map<String, dynamic> dayMasterAnalysis,
    Map<String, dynamic> elementRelationships,
    String gender,
  ) {
    final recommendations = <String>[];

    // Day master based recommendations
    final dayMasterElement = dayMasterAnalysis['element'] as String;
    final dayMasterStrength = dayMasterAnalysis['strength'] as String;

    if (dayMasterStrength == 'Weak') {
      recommendations.add(
        'Strengthen your $dayMasterElement nature through favorable elements',
      );
    } else if (dayMasterStrength == 'Very Strong') {
      recommendations.add(
        'Your strong $dayMasterElement can help others develop',
      );
    }

    // Element balance recommendations
    final missingElements = elementBalance['missingElements'] as List<String>;
    if (missingElements.isNotEmpty) {
      recommendations.add(
        'Consider incorporating ${missingElements.join(', ')} elements',
      );
    }

    // Gender-specific recommendations
    if (gender.toLowerCase() == 'male') {
      recommendations.add('Embrace yang energy for leadership and action');
    } else {
      recommendations.add('Develop yin energy for intuition and wisdom');
    }

    return recommendations;
  }

  // Helper methods
  static String _getStemElement(String stem) {
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

  static List<String> _getFavorableElements(String element) {
    const favorableMap = {
      '木': ['水', '火'],
      '火': ['木', '土'],
      '土': ['火', '金'],
      '金': ['土', '水'],
      '水': ['金', '木'],
    };
    return favorableMap[element] ?? [];
  }

  static List<String> _getUnfavorableElements(String element) {
    const unfavorableMap = {
      '木': ['金'],
      '火': ['水'],
      '土': ['木'],
      '金': ['火'],
      '水': ['土'],
    };
    return unfavorableMap[element] ?? [];
  }

  static String _assessElementStrength(int count) {
    if (count >= 4) return 'Very Strong';
    if (count >= 3) return 'Strong';
    if (count >= 2) return 'Moderate';
    return 'Weak';
  }

  static double _calculateBalanceScore(Map<String, double> balance) {
    final values = balance.values.toList();
    final max = values.reduce((a, b) => a > b ? a : b);
    final min = values.reduce((a, b) => a < b ? a : b);
    return 1.0 - (max - min);
  }

  static String _assessOverallBalance(Map<String, dynamic> elementBalance) {
    final balanceScore = elementBalance['balanceScore'] as double;
    if (balanceScore >= 0.8) return 'Very Balanced';
    if (balanceScore >= 0.6) return 'Balanced';
    if (balanceScore >= 0.4) return 'Moderately Balanced';
    return 'Unbalanced';
  }

  static String _getDayMasterAnalysis(
    String dayMaster,
    String element,
    String strength,
  ) {
    final analysis = StringBuffer()
      ..writeln('Day Master: $dayMaster ($element)')
      ..writeln('Strength: $strength');

    switch (element) {
      case '木':
        analysis.writeln('Wood element represents growth and flexibility');
      case '火':
        analysis.writeln('Fire element represents passion and transformation');
      case '土':
        analysis.writeln('Earth element represents stability and nourishment');
      case '金':
        analysis.writeln('Metal element represents clarity and precision');
      case '水':
        analysis.writeln('Water element represents wisdom and flow');
    }

    return analysis.toString();
  }

  static List<String> _getElementRecommendations(
    String element,
    int count,
    List<String> favorable,
    List<String> unfavorable,
  ) {
    final recommendations = <String>[];

    if (count == 0) {
      recommendations.add('Incorporate $element energy');
    } else if (count >= 4) {
      recommendations.add('Balance excessive $element energy');
    }

    if (favorable.isNotEmpty) {
      recommendations.add(
        'Develop ${favorable.join(', ')} elements for support',
      );
    }

    return recommendations;
  }
}

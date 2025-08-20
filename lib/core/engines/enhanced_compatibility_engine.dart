/// [EnhancedCompatibilityEngine] - Enhanced compatibility analysis with timing predictions
/// Implements relationship timing predictions and compatibility trend analysis
/// Production-ready implementation for advanced relationship compatibility
library;

import 'dart:math' as math;

import 'package:astro_iztro/core/engines/astro_matcher_engine.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

/// [EnhancedCompatibilityEngine] - Advanced compatibility analysis with timing insights
class EnhancedCompatibilityEngine {
  /// [calculateRelationshipTiming] - Predict optimal timing for relationship milestones
  static Map<String, dynamic> calculateRelationshipTiming({
    required Map<String, dynamic> profile1,
    required Map<String, dynamic> profile2,
    required int targetYear,
  }) {
    try {
      if (kDebugMode) {
        print(
          '[EnhancedCompatibilityEngine] Calculating relationship timing for $targetYear...',
        );
      }

      final birth1 = DateTime.parse(profile1['birthDate'] as String);
      final birth2 = DateTime.parse(profile2['birthDate'] as String);

      // Calculate timing cycles for both profiles
      final timing1 = _calculatePersonalTiming(birth1, targetYear);
      final timing2 = _calculatePersonalTiming(birth2, targetYear);

      // Calculate relationship timing windows
      final timingWindows = _calculateTimingWindows(
        timing1,
        timing2,
        targetYear,
      );

      // Generate timing recommendations
      final recommendations = _generateTimingRecommendations(
        timingWindows,
        targetYear,
      );

      if (kDebugMode) {
        print(
          '[EnhancedCompatibilityEngine] Relationship timing calculation completed',
        );
      }

      return {
        'targetYear': targetYear,
        'personalTiming1': timing1,
        'personalTiming2': timing2,
        'timingWindows': timingWindows,
        'recommendations': recommendations,
        'calculationMethod': 'native',
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      if (kDebugMode) {
        print('[EnhancedCompatibilityEngine] Timing calculation failed: $e');
      }
      rethrow;
    }
  }

  /// [analyzeCompatibilityTrends] - Analyze compatibility changes over time
  static Map<String, dynamic> analyzeCompatibilityTrends({
    required Map<String, dynamic> profile1,
    required Map<String, dynamic> profile2,
    required int startYear,
    required int endYear,
  }) {
    try {
      if (kDebugMode) {
        print(
          '[EnhancedCompatibilityEngine] Analyzing compatibility trends $startYear-$endYear...',
        );
      }

      final trends = <String, dynamic>{};
      final yearlyScores = <int, double>{};
      final yearlyBreakdown = <String, dynamic>{};

      // Baseline pair compatibility from core engine (static wrt year)
      final base = AstroMatcherEngine.calculateCompatibility(
        profile1: profile1,
        profile2: profile2,
      );
      final baseScore = (base['overallScore'] as num).toDouble();

      // Calculate compatibility for each year with detailed breakdown
      for (var year = startYear; year <= endYear; year++) {
        final compatibility = _calculateYearlyCompatibilityDetailed(
          profile1,
          profile2,
          year,
          baseScore,
        );
        yearlyScores[year] = (compatibility['overallScore'] as num).toDouble();
        yearlyBreakdown[year.toString()] = compatibility;

        if (year == startYear || year == endYear || year % 5 == 0) {
          trends[year.toString()] = compatibility;
        }
      }

      // Analyze trends and patterns
      final trendAnalysis = _analyzeTrendPatterns(
        yearlyScores,
        startYear,
        endYear,
      );
      final predictions = _predictFutureTrends(yearlyScores, endYear);

      if (kDebugMode) {
        print('[EnhancedCompatibilityEngine] Trend analysis completed');
      }

      return {
        'yearRange': '$startYear-$endYear',
        'yearlyScores': yearlyScores,
        'yearlyBreakdown': yearlyBreakdown,
        'trendAnalysis': trendAnalysis,
        'predictions': predictions,
        'keyYears': trends,
        'calculationMethod': 'native',
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      if (kDebugMode) {
        print('[EnhancedCompatibilityEngine] Trend analysis failed: $e');
      }
      rethrow;
    }
  }

  /// [_calculatePersonalTiming] - Calculate personal timing cycles
  static Map<String, dynamic> _calculatePersonalTiming(
    DateTime birthDate,
    int targetYear,
  ) {
    final age = targetYear - birthDate.year;
    final lifePeriod = (age / 10).floor();
    final yearInPeriod = age % 10;

    return {
      'age': age,
      'lifePeriod': lifePeriod,
      'yearInPeriod': yearInPeriod,
      'energyLevel': _calculateEnergyLevel(age, yearInPeriod),
      'focusArea': _getFocusArea(lifePeriod),
    };
  }

  /// [_calculateTimingWindows] - Calculate optimal relationship timing windows
  static Map<String, dynamic> _calculateTimingWindows(
    Map<String, dynamic> timing1,
    Map<String, dynamic> timing2,
    int targetYear,
  ) {
    final energy1 = timing1['energyLevel'] as double;
    final energy2 = timing2['energyLevel'] as double;
    final combinedEnergy = (energy1 + energy2) / 2;

    return {
      'optimalWindows': _findOptimalWindows(timing1, timing2, targetYear),
      'challengingPeriods': _findChallengingPeriods(
        timing1,
        timing2,
        targetYear,
      ),
      'combinedEnergy': combinedEnergy,
      'synergyScore': _calculateSynergyScore(timing1, timing2),
    };
  }

  /// [_generateTimingRecommendations] - Generate timing-based recommendations
  static List<String> _generateTimingRecommendations(
    Map<String, dynamic> timingWindows,
    int targetYear,
  ) {
    final recommendations = <String>[];
    final optimalWindows = timingWindows['optimalWindows'] as List;
    final challengingPeriods = timingWindows['challengingPeriods'] as List;

    if (optimalWindows.isNotEmpty) {
      recommendations.add(
        'Optimal timing for major decisions: ${optimalWindows.join(', ')}',
      );
    }

    if (challengingPeriods.isNotEmpty) {
      recommendations.add(
        'Exercise patience during: ${challengingPeriods.join(', ')}',
      );
    }

    recommendations.add(
      'Focus on communication and understanding during transition periods',
    );

    return recommendations;
  }

  /// [_calculateYearlyCompatibilityDetailed] - Compute yearly compatibility with reasons
  static Map<String, dynamic> _calculateYearlyCompatibilityDetailed(
    Map<String, dynamic> profile1,
    Map<String, dynamic> profile2,
    int year,
    double baseScore,
  ) {
    final birth1 = DateTime.parse(profile1['birthDate'] as String);
    final birth2 = DateTime.parse(profile2['birthDate'] as String);

    // Personal timing and synergy
    final timing1 = _calculatePersonalTiming(birth1, year);
    final timing2 = _calculatePersonalTiming(birth2, year);
    final synergy = _calculateSynergyScore(timing1, timing2); // 0-100

    // Year element vs each person element
    final element1 = _getElement(birth1);
    final element2 = _getElement(birth2);
    final yearElement = _getYearElement(year);
    final eScore1 = _getElementCompatibility(yearElement, element1).toDouble();
    final eScore2 = _getElementCompatibility(yearElement, element2).toDouble();
    final elementYearScore = (eScore1 + eScore2) / 2.0;

    // Year animal vs each person's animal
    final animal1 = _getChineseZodiacAnimal(birth1.year);
    final animal2 = _getChineseZodiacAnimal(birth2.year);
    final yearAnimal = _getChineseZodiacAnimal(year);
    final zScore1 = _zodiacCompatAnimal(yearAnimal, animal1).toDouble();
    final zScore2 = _zodiacCompatAnimal(yearAnimal, animal2).toDouble();
    final zodiacYearScore = (zScore1 + zScore2) / 2.0;

    // Weighted blend (kept conservative to avoid big swings)
    const wBase = 0.5; // baseline pair dynamic
    const wElemYear = 0.2; // how year element supports pair
    const wZodiacYear = 0.15; // how year animal supports pair
    const wSynergy = 0.15; // their cycle alignment that year

    final overall =
        ((baseScore * wBase) +
                (elementYearScore * wElemYear) +
                (zodiacYearScore * wZodiacYear) +
                (synergy * wSynergy))
            .clamp(0.0, 100.0);

    final delta = overall - baseScore;

    return {
      'year': year,
      'overallScore': overall,
      'deltaFromBase': double.parse(delta.toStringAsFixed(1)),
      'reasons': {
        'yearElement': yearElement,
        'pairElements': [element1, element2],
        'yearAnimal': yearAnimal,
        'pairAnimals': [animal1, animal2],
        'timing': {
          'energy1': timing1['energyLevel'],
          'energy2': timing2['energyLevel'],
          'synergyScore': synergy,
        },
        'scores': {
          'base': baseScore,
          'yearElementSupport': elementYearScore,
          'yearAnimalSupport': zodiacYearScore,
          'timingSynergy': synergy,
        },
        'weights': {
          'base': wBase,
          'elementYear': wElemYear,
          'zodiacYear': wZodiacYear,
          'synergy': wSynergy,
        },
      },
    };
  }

  /// [_analyzeTrendPatterns] - Analyze compatibility trend patterns
  static Map<String, dynamic> _analyzeTrendPatterns(
    Map<int, double> yearlyScores,
    int startYear,
    int endYear,
  ) {
    final scores = yearlyScores.values.toList();
    final avgScore = scores.reduce((a, b) => a + b) / scores.length;
    final trend = scores.last > scores.first ? 'improving' : 'declining';

    return {
      'averageScore': avgScore.toStringAsFixed(1),
      'overallTrend': trend,
      'volatility': _calculateVolatility(scores),
      'peakYear': _findPeakYear(yearlyScores),
      'lowYear': _findLowYear(yearlyScores),
    };
  }

  /// [_predictFutureTrends] - Predict future compatibility trends
  static Map<String, dynamic> _predictFutureTrends(
    Map<int, double> yearlyScores,
    int currentYear,
  ) {
    final recentScores = yearlyScores.entries
        .where((entry) => entry.key >= currentYear - 3)
        .map((entry) => entry.value)
        .toList();

    if (recentScores.length < 2) return {'prediction': 'insufficient data'};

    final trend = recentScores.last > recentScores.first
        ? 'positive'
        : 'negative';
    final prediction = trend == 'positive'
        ? 'continued improvement'
        : 'potential challenges';

    return {
      'prediction': prediction,
      'confidence': 'medium',
      'nextYearEstimate':
          (recentScores.last + (recentScores.last - recentScores.first)).clamp(
            0.0,
            100.0,
          ),
    };
  }

  /// [_calculateEnergyLevel] - Calculate personal energy level
  static double _calculateEnergyLevel(int age, int yearInPeriod) {
    final baseEnergy = 100.0 - (age * 0.5);
    final periodVariation = (yearInPeriod - 5).abs() * 5;
    return (baseEnergy - periodVariation).clamp(20.0, 100.0);
  }

  /// [_getFocusArea] - Get life focus area for period
  static String _getFocusArea(int lifePeriod) {
    final focusAreas = [
      'Foundation & Learning',
      'Career & Identity',
      'Relationships & Family',
      'Spiritual Growth',
      'Legacy & Wisdom',
    ];
    return focusAreas[lifePeriod.clamp(0, focusAreas.length - 1)];
  }

  /// [_findOptimalWindows] - Find optimal timing windows
  static List<String> _findOptimalWindows(
    Map<String, dynamic> timing1,
    Map<String, dynamic> timing2,
    int targetYear,
  ) {
    final windows = <String>[];

    if ((timing1['energyLevel'] as double) > 70 &&
        (timing2['energyLevel'] as double) > 70) {
      windows.add('High energy alignment');
    }

    if ((timing1['yearInPeriod'] as int) == 0 ||
        (timing2['yearInPeriod'] as int) == 0) {
      windows.add('New cycle beginnings');
    }

    return windows;
  }

  /// [_findChallengingPeriods] - Find challenging timing periods
  static List<String> _findChallengingPeriods(
    Map<String, dynamic> timing1,
    Map<String, dynamic> timing2,
    int targetYear,
  ) {
    final periods = <String>[];

    if ((timing1['energyLevel'] as double) < 40 ||
        (timing2['energyLevel'] as double) < 40) {
      periods.add('Low energy periods');
    }

    if ((timing1['yearInPeriod'] as int) == 9 ||
        (timing2['yearInPeriod'] as int) == 9) {
      periods.add('Cycle endings');
    }

    return periods;
  }

  /// [_calculateSynergyScore] - Calculate synergy between two timing patterns
  static double _calculateSynergyScore(
    Map<String, dynamic> timing1,
    Map<String, dynamic> timing2,
  ) {
    final energyDiff =
        ((timing1['energyLevel'] as double) -
                (timing2['energyLevel'] as double))
            .abs();
    final periodDiff =
        ((timing1['yearInPeriod'] as int) - (timing2['yearInPeriod'] as int))
            .abs();

    return (100.0 - energyDiff - (periodDiff * 2)).clamp(0.0, 100.0);
  }

  /// [_calculateVolatility] - Calculate score volatility
  static double _calculateVolatility(List<double> scores) {
    if (scores.length < 2) return 0;

    final mean = scores.reduce((a, b) => a + b) / scores.length;
    final variance =
        scores
            .map((score) => (score - mean) * (score - mean))
            .reduce((a, b) => a + b) /
        scores.length;

    return math.sqrt(variance);
  }

  /// [_findPeakYear] - Find year with highest compatibility score
  static int _findPeakYear(Map<int, double> yearlyScores) {
    return yearlyScores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  /// [_findLowYear] - Find year with lowest compatibility score
  static int _findLowYear(Map<int, double> yearlyScores) {
    return yearlyScores.entries.reduce((a, b) => a.value < b.value ? a : b).key;
  }

  // --- Helpers replicated for yearly modeling ---
  static String _getYearElement(int year) {
    // Simple 5-element cycle approximation by year
    switch ((year - 4) % 5) {
      case 0:
        return 'Wood';
      case 1:
        return 'Fire';
      case 2:
        return 'Earth';
      case 3:
        return 'Metal';
      default:
        return 'Water';
    }
  }

  static String _getElement(DateTime birth) {
    return _getYearElement(birth.year);
  }

  static int _getElementCompatibility(String element1, String element2) {
    final elementMatrix = {
      'Wood': {'Wood': 70, 'Fire': 85, 'Earth': 60, 'Metal': 40, 'Water': 90},
      'Fire': {'Wood': 85, 'Fire': 70, 'Earth': 85, 'Metal': 60, 'Water': 40},
      'Earth': {
        'Wood': 60,
        'Fire': 85,
        'Earth': 80,
        'Metal': 85,
        'Water': 60,
      },
      'Metal': {
        'Wood': 40,
        'Fire': 60,
        'Earth': 85,
        'Metal': 70,
        'Water': 85,
      },
      'Water': {
        'Wood': 90,
        'Fire': 40,
        'Earth': 60,
        'Metal': 85,
        'Water': 70,
      },
    };
    return elementMatrix[element1]?[element2] ?? 60;
  }

  static String _getChineseZodiacAnimal(int year) {
    const animals = [
      'Rat',
      'Ox',
      'Tiger',
      'Rabbit',
      'Dragon',
      'Snake',
      'Horse',
      'Goat',
      'Monkey',
      'Rooster',
      'Dog',
      'Pig',
    ];
    final idx = (year - 4) % 12;
    return animals[idx];
  }

  static int _zodiacCompatAnimal(String a1, String a2) {
    const trines = [
      {'Rat', 'Dragon', 'Monkey'},
      {'Ox', 'Snake', 'Rooster'},
      {'Tiger', 'Horse', 'Dog'},
      {'Rabbit', 'Goat', 'Pig'},
    ];
    const clashes = {
      'Rat': 'Horse',
      'Ox': 'Goat',
      'Tiger': 'Monkey',
      'Rabbit': 'Rooster',
      'Dragon': 'Dog',
      'Snake': 'Pig',
      'Horse': 'Rat',
      'Goat': 'Ox',
      'Monkey': 'Tiger',
      'Rooster': 'Rabbit',
      'Dog': 'Dragon',
      'Pig': 'Snake',
    };
    if (a1 == a2) return 80;
    final inTrine = trines.any((t) => t.contains(a1) && t.contains(a2));
    if (inTrine) return 90;
    if (clashes[a1] == a2) return 35;
    // neighbors in cycle considered semi-compatible
    const order = [
      'Rat',
      'Ox',
      'Tiger',
      'Rabbit',
      'Dragon',
      'Snake',
      'Horse',
      'Goat',
      'Monkey',
      'Rooster',
      'Dog',
      'Pig',
    ];
    final i1 = order.indexOf(a1);
    final i2 = order.indexOf(a2);
    final diff = (i1 - i2).abs();
    if (diff == 1 || diff == 11) return 70;
    return 60;
  }
}

/// [EnhancedCompatibilityEngine] - Enhanced compatibility analysis with timing predictions
/// Implements relationship timing predictions and compatibility trend analysis
/// Production-ready implementation for advanced relationship compatibility
library;

import 'dart:math' as math;

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

      // Calculate compatibility for each year
      for (var year = startYear; year <= endYear; year++) {
        final compatibility = _calculateYearlyCompatibility(
          profile1,
          profile2,
          year,
        );
        yearlyScores[year] = compatibility['overallScore'] as double;

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

  /// [_calculateYearlyCompatibility] - Calculate compatibility for specific year
  static Map<String, dynamic> _calculateYearlyCompatibility(
    Map<String, dynamic> profile1,
    Map<String, dynamic> profile2,
    int year,
  ) {
    // Simplified yearly compatibility calculation
    const baseScore = 70.0;
    final yearVariation = (year % 12) * 2.5;
    final finalScore = (baseScore + yearVariation).clamp(0.0, 100.0);

    return {
      'year': year,
      'overallScore': finalScore,
      'trend': yearVariation > 0 ? 'improving' : 'challenging',
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
}

/// [AstroMatcherEngine] - Native Astrological Compatibility calculation engine
/// Implements authentic astrological compatibility analysis without external dependencies
/// Production-ready implementation for reliable relationship compatibility analysis
// ignore_for_file: unused_local_variable

library;

import 'package:flutter/foundation.dart' show kDebugMode;

/// [AstroMatcherEngine] - Core calculation engine for Astrological Compatibility Analysis
class AstroMatcherEngine {
  /// [calculateCompatibility] - Calculate astrological compatibility between two profiles
  static Map<String, dynamic> calculateCompatibility({
    required Map<String, dynamic> profile1,
    required Map<String, dynamic> profile2,
  }) {
    try {
      if (kDebugMode) {
        print(
          '[AstroMatcherEngine] Starting native compatibility calculation...',
        );
        print('  Profile 1: ${profile1['name'] ?? 'Unknown'}');
        print('  Profile 2: ${profile2['name'] ?? 'Unknown'}');
      }

      // Extract birth data from profiles
      final birth1 = DateTime.parse(profile1['birthDate'] as String);
      final birth2 = DateTime.parse(profile2['birthDate'] as String);
      final hour1 = profile1['birthHour'] as int;
      final hour2 = profile2['birthHour'] as int;
      final minute1 = profile1['birthMinute'] as int;
      final minute2 = profile2['birthMinute'] as int;
      final gender1 = profile1['gender'] as String;
      final gender2 = profile2['gender'] as String;

      // Calculate compatibility scores
      final sunSignCompatibility = _calculateSunSignCompatibility(
        birth1,
        birth2,
      );
      final elementCompatibility = _calculateElementCompatibility(
        birth1,
        birth2,
      );
      final timingCompatibility = _calculateTimingCompatibility(birth1, birth2);
      final overallCompatibility = _calculateOverallCompatibility(
        sunSignCompatibility,
        elementCompatibility,
        timingCompatibility,
      );

      // Generate detailed analysis
      final analysis = _generateCompatibilityAnalysis(
        sunSignCompatibility,
        elementCompatibility,
        timingCompatibility,
        overallCompatibility,
        birth1,
        birth2,
        gender1,
        gender2,
      );

      if (kDebugMode) {
        print(
          '[AstroMatcherEngine] Compatibility calculation completed successfully',
        );
        print('  Overall Score: $overallCompatibility%');
      }

      return {
        'overallScore': overallCompatibility,
        'sunSignScore': sunSignCompatibility,
        'elementScore': elementCompatibility,
        'timingScore': timingCompatibility,
        'analysis': analysis,
        'recommendations': _generateRecommendations(overallCompatibility),
        'calculatedAt': DateTime.now().toIso8601String(),
        'profile1': profile1,
        'profile2': profile2,
      };
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AstroMatcherEngine] Error calculating compatibility: $e');
        print('[AstroMatcherEngine] Using fallback compatibility values');
      }

      // Return fallback values if calculation fails
      return {
        'overallScore': 50,
        'sunSignScore': 50,
        'elementScore': 50,
        'timingScore': 50,
        'analysis': 'Compatibility analysis temporarily unavailable',
        'recommendations': ['Please try again later'],
        'calculatedAt': DateTime.now().toIso8601String(),
        'profile1': profile1,
        'profile2': profile2,
        'error': 'Calculation failed: $e',
      };
    }
  }

  /// [_calculateSunSignCompatibility] - Calculate sun sign compatibility
  static double _calculateSunSignCompatibility(
    DateTime birth1,
    DateTime birth2,
  ) {
    try {
      final sign1 = _getZodiacSign(birth1);
      final sign2 = _getZodiacSign(birth2);

      // Traditional astrological compatibility rules
      final compatibility = _getSignCompatibility(sign1, sign2);

      if (kDebugMode) {
        print(
          '[AstroMatcherEngine] Sun sign compatibility: $sign1 + $sign2 = $compatibility%',
        );
      }

      return compatibility.toDouble();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AstroMatcherEngine] Error in sun sign compatibility: $e');
      }
      return 50; // Neutral score on error
    }
  }

  /// [_calculateElementCompatibility] - Calculate element compatibility
  static double _calculateElementCompatibility(
    DateTime birth1,
    DateTime birth2,
  ) {
    try {
      final element1 = _getElement(birth1);
      final element2 = _getElement(birth2);

      // Traditional element compatibility rules
      final compatibility = _getElementCompatibility(element1, element2);

      if (kDebugMode) {
        print(
          '[AstroMatcherEngine] Element compatibility: $element1 + $element2 = $compatibility%',
        );
      }

      return compatibility.toDouble();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AstroMatcherEngine] Error in element compatibility: $e');
      }
      return 50; // Neutral score on error
    }
  }

  /// [_calculateTimingCompatibility] - Calculate timing compatibility
  static double _calculateTimingCompatibility(
    DateTime birth1,
    DateTime birth2,
  ) {
    try {
      // Calculate age difference and life cycle compatibility
      final ageDiff = (birth1.year - birth2.year).abs();
      final monthDiff = (birth1.month - birth2.month).abs();
      final dayDiff = (birth1.day - birth2.day).abs();

      // Timing compatibility based on traditional Chinese astrology
      double compatibility = 100;

      // Age difference factor (optimal: 0-5 years)
      if (ageDiff <= 5) {
        compatibility -= 0;
      } else if (ageDiff <= 10) {
        compatibility -= 10;
      } else if (ageDiff <= 20) {
        compatibility -= 25;
      } else {
        compatibility -= 40;
      }

      // Seasonal compatibility (same season = better)
      final season1 = _getSeason(birth1);
      final season2 = _getSeason(birth2);
      if (season1 == season2) {
        compatibility += 15;
      } else if (_areSeasonsAdjacent(season1, season2)) {
        compatibility += 5;
      } else if (_areSeasonsOpposite(season1, season2)) {
        compatibility -= 10;
      }

      // Ensure compatibility stays within 0-100 range
      compatibility = compatibility.clamp(0.0, 100.0);

      if (kDebugMode) {
        print('[AstroMatcherEngine] Timing compatibility: $compatibility%');
      }

      return compatibility;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AstroMatcherEngine] Error in timing compatibility: $e');
      }
      return 50; // Neutral score on error
    }
  }

  /// [_calculateOverallCompatibility] - Calculate overall compatibility score
  static double _calculateOverallCompatibility(
    double sunSignScore,
    double elementScore,
    double timingScore,
  ) {
    try {
      // Weighted average of all compatibility factors
      // Sun sign: 40%, Element: 35%, Timing: 25%
      final overall =
          (sunSignScore * 0.4) + (elementScore * 0.35) + (timingScore * 0.25);

      if (kDebugMode) {
        print('[AstroMatcherEngine] Overall compatibility calculation:');
        print('  Sun Sign (40%): ${sunSignScore.toStringAsFixed(1)}');
        print('  Element (35%): ${elementScore.toStringAsFixed(1)}');
        print('  Timing (25%): ${timingScore.toStringAsFixed(1)}');
        print('  Overall: ${overall.toStringAsFixed(1)}%');
      }

      return overall;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AstroMatcherEngine] Error in overall compatibility: $e');
      }
      return 50; // Neutral score on error
    }
  }

  /// [_generateCompatibilityAnalysis] - Generate detailed compatibility analysis
  static Map<String, dynamic> _generateCompatibilityAnalysis(
    double sunSignScore,
    double elementScore,
    double timingScore,
    double overallScore,
    DateTime birth1,
    DateTime birth2,
    String gender1,
    String gender2,
  ) {
    try {
      final sign1 = _getZodiacSign(birth1);
      final sign2 = _getZodiacSign(birth2);
      final element1 = _getElement(birth1);
      final element2 = _getElement(birth2);

      return {
        'summary': _getCompatibilitySummary(overallScore),
        'sunSignAnalysis': _getSunSignAnalysis(sign1, sign2, sunSignScore),
        'elementAnalysis': _getElementAnalysis(
          element1,
          element2,
          elementScore,
        ),
        'timingAnalysis': _getTimingAnalysis(birth1, birth2, timingScore),
        'strengths': _getCompatibilityStrengths(
          sunSignScore,
          elementScore,
          timingScore,
        ),
        'challenges': _getCompatibilityChallenges(
          sunSignScore,
          elementScore,
          timingScore,
        ),
        'relationshipType': _getRelationshipType(
          overallScore,
          gender1,
          gender2,
        ),
      };
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AstroMatcherEngine] Error generating analysis: $e');
      }
      return {
        'summary': 'Analysis temporarily unavailable',
        'error': 'Failed to generate analysis: $e',
      };
    }
  }

  /// [_generateRecommendations] - Generate compatibility recommendations
  static List<String> _generateRecommendations(double overallScore) {
    try {
      final recommendations = <String>[];

      if (overallScore >= 80) {
        recommendations.addAll([
          'Excellent compatibility! This relationship has strong astrological foundations.',
          'Focus on maintaining the positive energy and harmony.',
          'Consider deepening spiritual and emotional connections.',
        ]);
      } else if (overallScore >= 60) {
        recommendations.addAll([
          'Good compatibility with room for growth.',
          'Work on communication and understanding differences.',
          'Use complementary strengths to balance each other.',
        ]);
      } else if (overallScore >= 40) {
        recommendations.addAll([
          'Moderate compatibility that requires effort.',
          'Focus on finding common ground and shared values.',
          'Consider seeking guidance for relationship improvement.',
        ]);
      } else {
        recommendations.addAll([
          'Challenging compatibility that needs careful attention.',
          'Focus on understanding and respecting differences.',
          'Consider professional relationship counseling.',
        ]);
      }

      return recommendations;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AstroMatcherEngine] Error generating recommendations: $e');
      }
      return ['Please consult with an astrologer for personalized advice.'];
    }
  }

  /// [_getZodiacSign] - Get zodiac sign from birth date
  static String _getZodiacSign(DateTime birthDate) {
    try {
      final month = birthDate.month;
      final day = birthDate.day;

      if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
        return 'Aries';
      }
      if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
        return 'Taurus';
      }
      if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
        return 'Gemini';
      }
      if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
        return 'Cancer';
      }
      if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return 'Leo';
      if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
        return 'Virgo';
      }
      if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
        return 'Libra';
      }
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
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AstroMatcherEngine] Error getting zodiac sign: $e');
      }
      return 'Unknown';
    }
  }

  /// [_getElement] - Get element from birth date (Chinese astrology)
  static String _getElement(DateTime birthDate) {
    try {
      final year = birthDate.year;
      final elementIndex = (year - 4) % 5;

      switch (elementIndex) {
        case 0:
          return 'Wood';
        case 1:
          return 'Fire';
        case 2:
          return 'Earth';
        case 3:
          return 'Metal';
        case 4:
          return 'Water';
        default:
          return 'Earth';
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AstroMatcherEngine] Error getting element: $e');
      }
      return 'Earth';
    }
  }

  /// [_getSeason] - Get season from birth date
  static String _getSeason(DateTime birthDate) {
    try {
      final month = birthDate.month;
      if (month >= 3 && month <= 5) return 'Spring';
      if (month >= 6 && month <= 8) return 'Summer';
      if (month >= 9 && month <= 11) return 'Autumn';
      return 'Winter';
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AstroMatcherEngine] Error getting season: $e');
      }
      return 'Unknown';
    }
  }

  /// [_getSignCompatibility] - Get compatibility between two zodiac signs
  static int _getSignCompatibility(String sign1, String sign2) {
    try {
      // Traditional astrological compatibility matrix
      final compatibilityMatrix = {
        'Aries': {
          'Aries': 70,
          'Taurus': 40,
          'Gemini': 85,
          'Cancer': 45,
          'Leo': 90,
          'Virgo': 35,
          'Libra': 80,
          'Scorpio': 50,
          'Sagittarius': 95,
          'Capricorn': 30,
          'Aquarius': 75,
          'Pisces': 40,
        },
        'Taurus': {
          'Aries': 40,
          'Taurus': 80,
          'Gemini': 35,
          'Cancer': 85,
          'Leo': 45,
          'Virgo': 90,
          'Libra': 40,
          'Scorpio': 80,
          'Sagittarius': 35,
          'Capricorn': 95,
          'Aquarius': 30,
          'Pisces': 85,
        },
        'Gemini': {
          'Aries': 85,
          'Taurus': 35,
          'Gemini': 75,
          'Cancer': 40,
          'Leo': 80,
          'Virgo': 45,
          'Libra': 90,
          'Scorpio': 35,
          'Sagittarius': 85,
          'Capricorn': 30,
          'Aquarius': 95,
          'Pisces': 40,
        },
        'Cancer': {
          'Aries': 45,
          'Taurus': 85,
          'Gemini': 40,
          'Cancer': 80,
          'Leo': 35,
          'Virgo': 85,
          'Libra': 40,
          'Scorpio': 90,
          'Sagittarius': 30,
          'Capricorn': 80,
          'Aquarius': 35,
          'Pisces': 95,
        },
        'Leo': {
          'Aries': 90,
          'Taurus': 45,
          'Gemini': 80,
          'Cancer': 35,
          'Leo': 85,
          'Virgo': 40,
          'Libra': 85,
          'Scorpio': 35,
          'Sagittarius': 90,
          'Capricorn': 30,
          'Aquarius': 80,
          'Pisces': 40,
        },
        'Virgo': {
          'Aries': 35,
          'Taurus': 90,
          'Gemini': 45,
          'Cancer': 85,
          'Leo': 40,
          'Virgo': 80,
          'Libra': 40,
          'Scorpio': 85,
          'Sagittarius': 35,
          'Capricorn': 90,
          'Aquarius': 30,
          'Pisces': 85,
        },
        'Libra': {
          'Aries': 80,
          'Taurus': 40,
          'Gemini': 90,
          'Cancer': 40,
          'Leo': 85,
          'Virgo': 40,
          'Libra': 80,
          'Scorpio': 35,
          'Sagittarius': 85,
          'Capricorn': 30,
          'Aquarius': 90,
          'Pisces': 40,
        },
        'Scorpio': {
          'Aries': 50,
          'Taurus': 80,
          'Gemini': 35,
          'Cancer': 90,
          'Leo': 35,
          'Virgo': 85,
          'Libra': 35,
          'Scorpio': 85,
          'Sagittarius': 30,
          'Capricorn': 80,
          'Aquarius': 35,
          'Pisces': 90,
        },
        'Sagittarius': {
          'Aries': 95,
          'Taurus': 35,
          'Gemini': 85,
          'Cancer': 30,
          'Leo': 90,
          'Virgo': 35,
          'Libra': 85,
          'Scorpio': 30,
          'Sagittarius': 80,
          'Capricorn': 25,
          'Aquarius': 90,
          'Pisces': 35,
        },
        'Capricorn': {
          'Aries': 30,
          'Taurus': 95,
          'Gemini': 30,
          'Cancer': 80,
          'Leo': 30,
          'Virgo': 90,
          'Libra': 30,
          'Scorpio': 80,
          'Sagittarius': 25,
          'Capricorn': 85,
          'Aquarius': 25,
          'Pisces': 80,
        },
        'Aquarius': {
          'Aries': 75,
          'Taurus': 30,
          'Gemini': 95,
          'Cancer': 35,
          'Leo': 80,
          'Virgo': 30,
          'Libra': 90,
          'Scorpio': 35,
          'Sagittarius': 90,
          'Capricorn': 25,
          'Aquarius': 80,
          'Pisces': 35,
        },
        'Pisces': {
          'Aries': 40,
          'Taurus': 85,
          'Gemini': 40,
          'Cancer': 95,
          'Leo': 40,
          'Virgo': 85,
          'Libra': 40,
          'Scorpio': 90,
          'Sagittarius': 35,
          'Capricorn': 80,
          'Aquarius': 35,
          'Pisces': 85,
        },
      };

      return compatibilityMatrix[sign1]?[sign2] ?? 50;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AstroMatcherEngine] Error getting sign compatibility: $e');
      }
      return 50; // Neutral score on error
    }
  }

  /// [_getElementCompatibility] - Get compatibility between two elements
  static int _getElementCompatibility(String element1, String element2) {
    try {
      // Traditional Chinese element compatibility
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

      return elementMatrix[element1]?[element2] ?? 50;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AstroMatcherEngine] Error getting element compatibility: $e');
      }
      return 50; // Neutral score on error
    }
  }

  /// [_areSeasonsAdjacent] - Check if two seasons are adjacent
  static bool _areSeasonsAdjacent(String season1, String season2) {
    try {
      final seasons = ['Spring', 'Summer', 'Autumn', 'Winter'];
      final index1 = seasons.indexOf(season1);
      final index2 = seasons.indexOf(season2);

      if (index1 == -1 || index2 == -1) return false;

      final diff = (index1 - index2).abs();
      return diff == 1 || diff == 3; // Adjacent or wrap-around
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AstroMatcherEngine] Error checking adjacent seasons: $e');
      }
      return false;
    }
  }

  /// [_areSeasonsOpposite] - Check if two seasons are opposite
  static bool _areSeasonsOpposite(String season1, String season2) {
    try {
      final seasons = ['Spring', 'Summer', 'Autumn', 'Winter'];
      final index1 = seasons.indexOf(season1);
      final index2 = seasons.indexOf(season2);

      if (index1 == -1 || index2 == -1) return false;

      final diff = (index1 - index2).abs();
      return diff == 2; // Opposite seasons
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[AstroMatcherEngine] Error checking opposite seasons: $e');
      }
      return false;
    }
  }

  /// [_getCompatibilitySummary] - Get compatibility summary based on score
  static String _getCompatibilitySummary(double score) {
    if (score >= 80) return 'Excellent Compatibility';
    if (score >= 60) return 'Good Compatibility';
    if (score >= 40) return 'Moderate Compatibility';
    return 'Challenging Compatibility';
  }

  /// [_getSunSignAnalysis] - Get sun sign compatibility analysis
  static String _getSunSignAnalysis(String sign1, String sign2, double score) {
    if (score >= 80) {
      return '$sign1 and $sign2 have excellent astrological harmony. Your sun signs complement each other perfectly, creating a strong foundation for your relationship.';
    } else if (score >= 60) {
      return '$sign1 and $sign2 have good compatibility. While there may be some differences, your sun signs work well together with understanding and compromise.';
    } else if (score >= 40) {
      return '$sign1 and $sign2 have moderate compatibility. Your sun signs may have some challenges, but these can be overcome with effort and communication.';
    } else {
      return '$sign1 and $sign2 have challenging compatibility. Your sun signs may have fundamental differences that require extra understanding and patience.';
    }
  }

  /// [_getElementAnalysis] - Get element compatibility analysis
  static String _getElementAnalysis(
    String element1,
    String element2,
    double score,
  ) {
    if (score >= 80) {
      return '$element1 and $element2 elements create excellent balance and harmony. Your elemental energies work together to create a strong and stable relationship.';
    } else if (score >= 60) {
      return '$element1 and $element2 elements have good compatibility. Your elemental energies complement each other well, creating a balanced relationship.';
    } else if (score >= 40) {
      return '$element1 and $element2 elements have moderate compatibility. There may be some elemental conflicts, but these can be managed with awareness.';
    } else {
      return '$element1 and $element2 elements have challenging compatibility. Your elemental energies may conflict, requiring extra effort to find balance.';
    }
  }

  /// [_getTimingAnalysis] - Get timing compatibility analysis
  static String _getTimingAnalysis(
    DateTime birth1,
    DateTime birth2,
    double score,
  ) {
    if (score >= 80) {
      return "Your birth timing creates excellent compatibility. You are likely to be in sync with each other's life cycles and rhythms.";
    } else if (score >= 60) {
      return 'Your birth timing has good compatibility. You can work well together despite some timing differences.';
    } else if (score >= 40) {
      return 'Your birth timing has moderate compatibility. There may be some timing challenges, but these can be navigated with patience.';
    } else {
      return 'Your birth timing has challenging compatibility. You may need to work harder to synchronize your life rhythms and cycles.';
    }
  }

  /// [_getCompatibilityStrengths] - Get compatibility strengths
  static List<String> _getCompatibilityStrengths(
    double sunSign,
    double element,
    double timing,
  ) {
    final strengths = <String>[];

    if (sunSign >= 70) strengths.add('Strong sun sign harmony');
    if (element >= 70) strengths.add('Excellent elemental balance');
    if (timing >= 70) strengths.add('Good life cycle synchronization');
    if (sunSign >= 60 && element >= 60) {
      strengths.add('Balanced astrological foundation');
    }
    if (element >= 60 && timing >= 60) strengths.add('Harmonious energy flow');

    if (strengths.isEmpty) {
      strengths.add('Potential for growth through understanding');
    }

    return strengths;
  }

  /// [_getCompatibilityChallenges] - Get compatibility challenges
  static List<String> _getCompatibilityChallenges(
    double sunSign,
    double element,
    double timing,
  ) {
    final challenges = <String>[];

    if (sunSign < 50) {
      challenges.add('Sun sign differences may cause conflicts');
    }
    if (element < 50) challenges.add('Elemental imbalances may create tension');
    if (timing < 50) challenges.add('Life cycle timing may be out of sync');
    if (sunSign < 40 && element < 40) {
      challenges.add('Fundamental astrological differences');
    }

    if (challenges.isEmpty) {
      challenges.add('Minor adjustments may be needed');
    }

    return challenges;
  }

  /// [_getRelationshipType] - Get relationship type based on compatibility
  static String _getRelationshipType(
    double score,
    String gender1,
    String gender2,
  ) {
    if (score >= 80) {
      return 'Soulmate Connection';
    } else if (score >= 60) {
      return 'Harmonious Partnership';
    } else if (score >= 40) {
      return 'Growth Relationship';
    } else {
      return 'Learning Relationship';
    }
  }
}

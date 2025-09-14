/// [TarotResponseEngine] - Intelligent Tarot Response and Interpretation Engine
/// Provides contextual, meaningful responses based on user questions and card combinations
/// Follows Apple Human Interface Guidelines for user experience and clean architecture principles
/// Production-ready implementation for reliable tarot readings with advanced analytics

// ignore_for_file: document_ignores

library;

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// [TarotResponseEngine] - Core engine for generating intelligent tarot responses
/// Enhanced with numerology, astrological correspondences, and advanced pattern recognition
class TarotResponseEngine {
  /// [generateContextualReading] - Generate contextual reading based on question and cards
  /// Analyzes question intent, card meanings, and relationships to provide meaningful insights
  static Map<String, dynamic> generateContextualReading({
    required String question,
    required List<Map<String, dynamic>> selectedCards,
    required String readingType,
    required AppLocalizations l10n,
  }) {
    try {
      if (kDebugMode) {
        print(
          '[TarotResponseEngine] Generating enhanced contextual reading...',
        );
        print('  Question: $question');
        print('  Cards: ${selectedCards.length}');
        print('  Reading Type: $readingType');
      }

      // Analyze question intent and categorize with enhanced precision
      final questionAnalysis = _analyzeQuestionIntent(question);

      // Analyze card relationships and patterns with advanced analytics
      final cardAnalysis = _analyzeCardRelationships(selectedCards);

      // Generate enhanced contextual interpretation
      final contextualInterpretation = _generateContextualInterpretation(
        question,
        questionAnalysis,
        selectedCards,
        cardAnalysis,
        readingType,
        l10n,
      );

      // Generate actionable guidance with specific steps
      final guidance = _generateActionableGuidance(
        questionAnalysis,
        cardAnalysis,
        selectedCards,
        l10n,
      );

      // Generate timing insights with astrological considerations
      final timingInsights = _generateTimingInsights(
        selectedCards,
        questionAnalysis,
        l10n,
      );

      // Generate emotional intelligence insights
      final emotionalInsights = _generateEmotionalInsights(
        selectedCards,
        questionAnalysis,
        cardAnalysis,
        l10n,
      );

      // Generate numerological insights
      final numerologicalInsights = _generateNumerologicalInsights(
        selectedCards,
      );

      // Generate astrological correspondences
      final astrologicalInsights = _generateAstrologicalInsights(selectedCards);

      // Generate seasonal and elemental insights
      final seasonalInsights = _generateSeasonalInsights(selectedCards);

      // Generate advanced card combination analysis
      final cardCombinations = _analyzeCardCombinations(selectedCards);

      // Generate shadow work insights
      final shadowWorkInsights = _generateShadowWorkInsights(
        selectedCards,
        questionAnalysis,
      );

      // Generate archetypal insights
      final archetypalInsights = _generateArchetypalInsights(selectedCards);

      // Generate comprehensive summary and key takeaways
      final comprehensiveSummary = _generateComprehensiveSummary(
        questionAnalysis,
        cardAnalysis,
        emotionalInsights,
        numerologicalInsights,
        astrologicalInsights,
        seasonalInsights,
        cardCombinations,
        shadowWorkInsights,
        archetypalInsights,
        l10n,
      );

      final response = {
        'question': question,
        'readingType': readingType,
        'questionAnalysis': questionAnalysis,
        'cardAnalysis': cardAnalysis,
        'contextualInterpretation': contextualInterpretation,
        'guidance': guidance,
        'timingInsights': timingInsights,
        'emotionalInsights': emotionalInsights,
        'numerologicalInsights': numerologicalInsights,
        'astrologicalInsights': astrologicalInsights,
        'seasonalInsights': seasonalInsights,
        'cardCombinations': cardCombinations,
        'shadowWorkInsights': shadowWorkInsights,
        'archetypalInsights': archetypalInsights,
        'comprehensiveSummary': comprehensiveSummary,
        'timestamp': DateTime.now().toIso8601String(),
        'readingId': _generateReadingId(),
      };

      if (kDebugMode) {
        print(
          '[TarotResponseEngine] Enhanced contextual reading generated successfully',
        );
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('[TarotResponseEngine] Error generating reading: $e');
      }
      rethrow;
    }
  }

  /// [_generateReadingId] - Generate unique reading identifier
  static String _generateReadingId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'TR_${timestamp}_$random';
  }

  // Private helper methods will be added here
  static Map<String, dynamic> _analyzeQuestionIntent(String question) {
    final lowerQuestion = question.toLowerCase();

    // Define question categories and keywords
    final categories = {
      'love': [
        'love',
        'relationship',
        'romance',
        'marriage',
        'dating',
        'partner',
        'heart',
      ],
      'career': [
        'career',
        'job',
        'work',
        'business',
        'profession',
        'promotion',
        'success',
      ],
      'finance': [
        'money',
        'finance',
        'wealth',
        'investment',
        'financial',
        'abundance',
        'prosperity',
      ],
      'health': [
        'health',
        'wellness',
        'healing',
        'medical',
        'physical',
        'mental',
        'emotional',
      ],
      'spirituality': [
        'spiritual',
        'soul',
        'divine',
        'purpose',
        'meaning',
        'faith',
        'belief',
      ],
      'family': [
        'family',
        'parent',
        'child',
        'sibling',
        'home',
        'domestic',
        'household',
      ],
      'travel': [
        'travel',
        'journey',
        'trip',
        'adventure',
        'movement',
        'exploration',
      ],
      'decision': [
        'decision',
        'choice',
        'option',
        'path',
        'direction',
        'what should',
        'should i',
      ],
      'timing': [
        'when',
        'timing',
        'time',
        'schedule',
        'deadline',
        'soon',
        'later',
      ],
      'general': [
        'general',
        'overall',
        'future',
        'destiny',
        'fate',
        'guidance',
      ],
    };

    // Find matching category
    var primaryCategory = 'general';
    var confidence = 0.0;

    for (final entry in categories.entries) {
      final category = entry.key;
      final keywords = entry.value;

      var matches = 0;
      for (final keyword in keywords) {
        if (lowerQuestion.contains(keyword)) {
          matches++;
        }
      }

      final categoryConfidence = matches / keywords.length;
      if (categoryConfidence > confidence) {
        confidence = categoryConfidence;
        primaryCategory = category;
      }
    }

    // Detect question type (yes/no, timing, guidance, etc.)
    var questionType = 'guidance';
    if (lowerQuestion.contains('should i') ||
        lowerQuestion.contains('is it') ||
        lowerQuestion.contains('will i')) {
      questionType = 'decision';
    } else if (lowerQuestion.contains('when') ||
        lowerQuestion.contains('how long')) {
      questionType = 'timing';
    } else if (lowerQuestion.contains('why') ||
        lowerQuestion.contains('what does')) {
      questionType = 'understanding';
    }

    return {
      'primaryCategory': primaryCategory,
      'confidence': confidence,
      'questionType': questionType,
      'keywords': _extractKeywords(lowerQuestion),
      'emotionalTone': _analyzeEmotionalTone(lowerQuestion),
    };
  }

  /// [_extractKeywords] - Extract meaningful keywords from the question
  static List<String> _extractKeywords(String question) {
    final stopWords = [
      'the',
      'a',
      'an',
      'and',
      'or',
      'but',
      'in',
      'on',
      'at',
      'to',
      'for',
      'of',
      'with',
      'by',
      'is',
      'are',
      'was',
      'were',
      'be',
      'been',
      'being',
      'have',
      'has',
      'had',
      'do',
      'does',
      'did',
      'will',
      'would',
      'could',
      'should',
      'may',
      'might',
      'can',
      'what',
      'when',
      'where',
      'why',
      'how',
      'i',
      'me',
      'my',
      'myself',
      'we',
      'our',
      'ours',
      'ourselves',
      'you',
      'your',
      'yours',
      'yourself',
      'yourselves',
      'it',
      'its',
      'itself',
      'they',
      'them',
      'their',
      'theirs',
      'themselves',
      'this',
      'that',
      'these',
      'those',
      'am',
      'is',
      'are',
      'was',
      'were',
      'be',
      'been',
      'being',
      'have',
      'has',
      'had',
      'do',
      'does',
      'did',
      'will',
      'would',
      'could',
      'should',
      'may',
      'might',
      'can',
      'must',
      'shall',
      'ought',
    ];

    final words = question.split(RegExp(r'\s+'));
    final keywords = words.where((word) {
      final cleanWord = word.toLowerCase().replaceAll(RegExp(r'[^\w]'), '');
      return cleanWord.length > 2 && !stopWords.contains(cleanWord);
    }).toList();

    return keywords.take(5).toList(); // Limit to top 5 keywords
  }

  /// [_analyzeEmotionalTone] - Analyze the emotional tone of the question
  static String _analyzeEmotionalTone(String question) {
    final positiveWords = [
      'happy',
      'joy',
      'love',
      'success',
      'hope',
      'dream',
      'wish',
      'want',
      'excited',
      'enthusiastic',
      'positive',
      'good',
      'great',
      'wonderful',
      'amazing',
      'beautiful',
      'perfect',
      'blessed',
      'grateful',
      'thankful',
    ];

    final negativeWords = [
      'worried',
      'afraid',
      'scared',
      'fear',
      'anxiety',
      'stress',
      'pain',
      'sad',
      'depressed',
      'angry',
      'frustrated',
      'confused',
      'lost',
      'problem',
      'trouble',
      'difficulty',
      'challenge',
      'obstacle',
      'block',
    ];

    final urgentWords = [
      'urgent',
      'immediate',
      'now',
      'quick',
      'fast',
      'hurry',
      'emergency',
      'critical',
      'important',
      'desperate',
      'needed',
      'required',
      'must',
    ];

    var positiveCount = 0;
    var negativeCount = 0;
    var urgentCount = 0;

    for (final word in positiveWords) {
      if (question.contains(word)) positiveCount++;
    }
    for (final word in negativeWords) {
      if (question.contains(word)) negativeCount++;
    }
    for (final word in urgentWords) {
      if (question.contains(word)) urgentCount++;
    }

    if (urgentCount > 0) return 'urgent';
    if (positiveCount > negativeCount) return 'positive';
    if (negativeCount > positiveCount) return 'negative';
    return 'neutral';
  }

  static Map<String, dynamic> _analyzeCardRelationships(
    List<Map<String, dynamic>> cards,
  ) {
    if (cards.isEmpty) return {};

    // Count card orientations
    var uprightCount = 0;
    var reversedCount = 0;

    // Analyze element distribution
    final suitCounts = <String, int>{};

    // Analyze card themes and keywords
    final allKeywords = <String>[];
    final cardThemes = <String>[];

    for (final card in cards) {
      // Count orientations
      if (card['is_reversed'] == true) {
        reversedCount++;
      } else {
        uprightCount++;
      }

      // Count suits
      final suit = card['suit']?.toString() ?? 'Unknown';
      suitCounts[suit] = (suitCounts[suit] ?? 0) + 1;

      // Collect keywords
      if (card['keywords'] != null) {
        final keywords = card['keywords'];
        if (keywords is List) {
          for (final keyword in keywords) {
            if (keyword is String) {
              allKeywords.add(keyword.toLowerCase());
            }
          }
        }
      }

      // Analyze card themes
      final cardName = card['name']?.toString() ?? '';
      if (cardName.contains('Love') || cardName.contains('Heart')) {
        cardThemes.add('love');
      } else if (cardName.contains('Money') || cardName.contains('Wealth')) {
        cardThemes.add('abundance');
      } else if (cardName.contains('Death') || cardName.contains('Tower')) {
        cardThemes.add('transformation');
      } else if (cardName.contains('Sun') || cardName.contains('Star')) {
        cardThemes.add('positivity');
      }
    }

    // Find dominant themes
    final keywordFrequency = <String, int>{};
    for (final keyword in allKeywords) {
      keywordFrequency[keyword] = (keywordFrequency[keyword] ?? 0) + 1;
    }

    final dominantKeywords = keywordFrequency.entries
        .where((entry) => entry.value > 1)
        .map((entry) => entry.key)
        .take(3)
        .toList();

    return {
      'orientation': {
        'upright': uprightCount,
        'reversed': reversedCount,
        'dominant': uprightCount > reversedCount ? 'upright' : 'reversed',
      },
      'suitDistribution': suitCounts,
      'dominantKeywords': dominantKeywords,
      'cardThemes': cardThemes,
      'totalCards': cards.length,
      'balance': _calculateCardBalance(cards),
    };
  }

  /// [_calculateCardBalance] - Calculate the overall balance and energy of the reading
  static Map<String, dynamic> _calculateCardBalance(
    List<Map<String, dynamic>> cards,
  ) {
    if (cards.isEmpty) return {};

    // Calculate energy scores based on card meanings
    var positiveEnergy = 0;
    var negativeEnergy = 0;
    var neutralEnergy = 0;

    for (final card in cards) {
      final meaning = card['upright_meaning']?.toString() ?? '';
      final reversedMeaning = card['reversed_meaning']?.toString() ?? '';
      final isReversed = card['is_reversed'] == true;

      final cardMeaning = isReversed ? reversedMeaning : meaning;
      final lowerMeaning = cardMeaning.toLowerCase();

      // Score based on keywords
      if (_containsPositiveKeywords(lowerMeaning)) {
        positiveEnergy += isReversed ? -1 : 1;
      } else if (_containsNegativeKeywords(lowerMeaning)) {
        negativeEnergy += isReversed ? 1 : -1;
      } else {
        neutralEnergy += 1;
      }
    }

    final totalEnergy = positiveEnergy + negativeEnergy + neutralEnergy;
    final balance = totalEnergy > 0
        ? 'positive'
        : totalEnergy < 0
            ? 'negative'
            : 'balanced';

    return {
      'positiveEnergy': positiveEnergy,
      'negativeEnergy': negativeEnergy,
      'neutralEnergy': neutralEnergy,
      'totalEnergy': totalEnergy,
      'balance': balance,
      'intensity': (positiveEnergy.abs() + negativeEnergy.abs()).clamp(0, 10),
    };
  }

  /// [_containsPositiveKeywords] - Check if meaning contains positive keywords
  static bool _containsPositiveKeywords(String meaning) {
    final positiveKeywords = [
      'love',
      'success',
      'happiness',
      'joy',
      'peace',
      'harmony',
      'growth',
      'abundance',
      'prosperity',
      'wisdom',
      'strength',
      'courage',
      'hope',
      'faith',
      'blessing',
      'opportunity',
      'freedom',
      'victory',
      'triumph',
    ];

    return positiveKeywords.any((keyword) => meaning.contains(keyword));
  }

  /// [_containsNegativeKeywords] - Check if meaning contains negative keywords
  static bool _containsNegativeKeywords(String meaning) {
    final negativeKeywords = [
      'death',
      'destruction',
      'loss',
      'pain',
      'suffering',
      'fear',
      'anxiety',
      'conflict',
      'struggle',
      'obstacle',
      'blockage',
      'delay',
      'failure',
      'betrayal',
      'deception',
      'isolation',
      'loneliness',
      'poverty',
      'illness',
    ];

    return negativeKeywords.any((keyword) => meaning.contains(keyword));
  }

  static String _generateContextualInterpretation(
    String question,
    Map<String, dynamic> questionAnalysis,
    List<Map<String, dynamic>> cards,
    Map<String, dynamic> cardAnalysis,
    String readingType,
    AppLocalizations l10n,
  ) {
    final category = questionAnalysis['primaryCategory'] as String;
    final questionType = questionAnalysis['questionType'] as String;
    final emotionalTone = questionAnalysis['emotionalTone'] as String;
    final balance = (cardAnalysis['balance']
            as Map<String, dynamic>?)?['balance'] as String? ??
        'balanced';

    final interpretation = StringBuffer()
      // Opening based on reading type
      ..writeln(_getReadingTypeOpening(readingType, l10n))
      ..writeln()
      // Question context
      ..writeln(
        'Your question about ${_getCategoryDescription(category, l10n)} reveals important insights.',
      )
      ..writeln();

    // Card-by-card interpretation with context
    for (var i = 0; i < cards.length; i++) {
      final card = cards[i];
      final position = i + 1;
      final isReversed = card['is_reversed'] == true;

      interpretation
        ..writeln(l10n.cardPosition(position, card['name'] as String))
        ..writeln(isReversed ? l10n.reversed : l10n.upright);

      final meaning = isReversed
          ? (card['reversed_meaning'] ?? l10n.noReversedMeaningAvailable)
          : (card['upright_meaning'] ?? l10n.noUprightMeaningAvailable);

      interpretation.writeln('${l10n.meaningLabelShort} $meaning');

      // Add contextual interpretation
      final contextualMeaning = _getContextualMeaning(
        card,
        category,
        questionType,
        position,
        readingType,
        l10n,
      );
      if (contextualMeaning.isNotEmpty) {
        interpretation.writeln(l10n.inYourSituationContext(contextualMeaning));
      }

      interpretation.writeln();
    }

    // Overall message based on balance
    interpretation
      ..writeln(l10n.overallMessage)
      ..writeln(
        _getOverallMessage(balance, category, emotionalTone, l10n),
      )
      ..writeln();

    // Timing insights
    if (questionType == 'timing' || questionType == 'decision') {
      interpretation
        ..writeln(l10n.timing)
        ..writeln(_getTimingMessage(cards, balance, l10n));
    }

    return interpretation.toString();
  }

  /// [_getReadingTypeOpening] - Get opening message based on reading type
  static String _getReadingTypeOpening(
    String readingType,
    AppLocalizations l10n,
  ) {
    switch (readingType) {
      case 'single_card':
        return l10n.singleCardReadingDescription;
      case 'three_card':
        return l10n.threeCardReadingDescription;
      case 'celtic_cross':
        return l10n.celticCrossReadingDescription;
      case 'horseshoe':
        return l10n.horseshoeReadingDescription;
      case 'daily_draw':
        return l10n.dailyDrawReadingDescription;
      default:
        return l10n.genericTarotReadingDescription;
    }
  }

  /// [_getCategoryDescription] - Get human-readable category description
  static String _getCategoryDescription(
    String category,
    AppLocalizations l10n,
  ) {
    switch (category) {
      case 'love':
        return l10n.loveAndRelationships;
      case 'career':
        return l10n.careerAndProfessionalLife;
      case 'finance':
        return l10n.financialMattersAndAbundance;
      case 'health':
        return l10n.healthAndWellness;
      case 'spirituality':
        return l10n.spiritualGrowthAndPurpose;
      case 'family':
        return l10n.familyAndHomeLife;
      case 'travel':
        return l10n.travelAndNewExperiences;
      case 'decision':
        return l10n.importantDecisionsAndChoices;
      case 'timing':
        return l10n.timingAndLifeCycles;
      default:
        return l10n.yourLifePath;
    }
  }

  /// [_getContextualMeaning] - Get contextual meaning for a card based on question
  static String _getContextualMeaning(
    Map<String, dynamic> card,
    String category,
    String questionType,
    int position,
    String readingType,
    AppLocalizations l10n,
  ) {
    final cardName = card['name']?.toString() ?? '';
    final isReversed = card['is_reversed'] == true;

    // Position-based interpretation for multi-card readings
    if (readingType == 'three_card') {
      switch (position) {
        case 1:
          return _getPastContext(cardName, category, isReversed, l10n);
        case 2:
          return _getPresentContext(cardName, category, isReversed, l10n);
        case 3:
          return _getFutureContext(cardName, category, isReversed, l10n);
      }
    }

    // Category-based interpretation
    return _getCategoryContext(cardName, category, isReversed, l10n);
  }

  /// [_getPastContext] - Get past context for a card
  static String _getPastContext(
    String cardName,
    String category,
    bool isReversed,
    AppLocalizations l10n,
  ) {
    if (cardName.contains('Death') || cardName.contains('Tower')) {
      return l10n.significantTransformationPast;
    } else if (cardName.contains('Fool') || cardName.contains('Magician')) {
      return l10n.newBeginningPast;
    }
    return l10n.pastInfluencesGeneral;
  }

  /// [_getPresentContext] - Get present context for a card
  static String _getPresentContext(
    String cardName,
    String category,
    bool isReversed,
    AppLocalizations l10n,
  ) {
    if (cardName.contains('High Priestess') || cardName.contains('Hermit')) {
      return l10n.introspectionPresent;
    } else if (cardName.contains('Chariot') || cardName.contains('Strength')) {
      return l10n.activeWorkPresent;
    }
    return l10n.currentSituationGeneral;
  }

  /// [_getFutureContext] - Get future context for a card
  static String _getFutureContext(
    String cardName,
    String category,
    bool isReversed,
    AppLocalizations l10n,
  ) {
    if (cardName.contains('Sun') || cardName.contains('Star')) {
      return l10n.brightOutcomeFuture;
    } else if (cardName.contains('Moon') || cardName.contains('Devil')) {
      return l10n.potentialChallengesFuture;
    }
    return l10n.pathDirectionFuture;
  }

  /// [_getCategoryContext] - Get category-specific context for a card
  static String _getCategoryContext(
    String cardName,
    String category,
    bool isReversed,
    AppLocalizations l10n,
  ) {
    switch (category) {
      case 'love':
        if (cardName.contains('Lovers')) {
          return l10n.relationshipDecisionLove;
        } else if (cardName.contains('Two of Cups')) {
          return l10n.romanticConnectionLove;
        }
      case 'career':
        if (cardName.contains('Magician')) {
          return l10n.skillsManifestCareer;
        } else if (cardName.contains('Chariot')) {
          return l10n.determinationSuccessCareer;
        }
      case 'finance':
        if (cardName.contains('Six of Pentacles')) {
          return l10n.financialBalanceFinance;
        } else if (cardName.contains('Ten of Pentacles')) {
          return l10n.longTermSecurityFinance;
        }
    }

    return l10n.cardEnergyRelevant(_getCategoryDescription(category, l10n));
  }

  /// [_getOverallMessage] - Get overall message based on card balance and category
  static String _getOverallMessage(
    String balance,
    String category,
    String emotionalTone,
    AppLocalizations l10n,
  ) {
    switch (balance) {
      case 'positive':
        return _getPositiveOverallMessage(category, emotionalTone, l10n);
      case 'negative':
        return _getNegativeOverallMessage(category, emotionalTone, l10n);
      default:
        return _getBalancedOverallMessage(category, emotionalTone, l10n);
    }
  }

  /// [_getPositiveOverallMessage] - Get positive overall message
  static String _getPositiveOverallMessage(
    String category,
    String emotionalTone,
    AppLocalizations l10n,
  ) {
    switch (category) {
      case 'love':
        return l10n.positiveEnergyLove;
      case 'career':
        return l10n.careerPathAligned;
      case 'finance':
        return l10n.financialAbundancePositive;
      default:
        return l10n.overallPositiveEnergy;
    }
  }

  /// [_getNegativeOverallMessage] - Get negative overall message
  static String _getNegativeOverallMessage(
    String category,
    String emotionalTone,
    AppLocalizations l10n,
  ) {
    switch (category) {
      case 'love':
        return l10n.relationshipChallenges;
      case 'career':
        return l10n.careerObstacles;
      case 'finance':
        return l10n.financialChallenges;
      default:
        return l10n.challengesLeadGrowth;
    }
  }

  /// [_getBalancedOverallMessage] - Get balanced overall message
  static String _getBalancedOverallMessage(
    String category,
    String emotionalTone,
    AppLocalizations l10n,
  ) {
    switch (category) {
      case 'love':
        return l10n.loveLifeBalance;
      case 'career':
        return l10n.careerSteadyProgress;
      case 'finance':
        return l10n.financialStability;
      default:
        return l10n.balancedEnergy;
    }
  }

  /// [_getTimingMessage] - Get timing insights from the cards
  static String _getTimingMessage(
    List<Map<String, dynamic>> cards,
    String balance,
    AppLocalizations l10n,
  ) {
    if (cards.isEmpty) return l10n.timingNotAvailable;

    // Analyze timing based on card meanings and positions
    final timingKeywords = <String>[];

    for (final card in cards) {
      final meaning = card['upright_meaning']?.toString() ?? '';
      final lowerMeaning = meaning.toLowerCase();

      if (lowerMeaning.contains('soon') || lowerMeaning.contains('quick')) {
        timingKeywords.add('soon');
      } else if (lowerMeaning.contains('patience') ||
          lowerMeaning.contains('wait')) {
        timingKeywords.add('patience');
      } else if (lowerMeaning.contains('long') ||
          lowerMeaning.contains('future')) {
        timingKeywords.add('long-term');
      }
    }

    if (timingKeywords.contains('soon')) {
      return l10n.changesComeSoon;
    } else if (timingKeywords.contains('patience')) {
      return l10n.patienceRequired;
    } else if (timingKeywords.contains('long-term')) {
      return l10n.longTermSituation;
    }

    // Default timing based on balance
    switch (balance) {
      case 'positive':
        return l10n.positiveOutcomesWeeksMonths;
      case 'negative':
        return l10n.challengesAriseSoon;
      default:
        return l10n.steadyProgressMonths;
    }
  }

  static Map<String, dynamic> _generateActionableGuidance(
    Map<String, dynamic> questionAnalysis,
    Map<String, dynamic> cardAnalysis,
    List<Map<String, dynamic>> cards,
    AppLocalizations l10n,
  ) {
    final category = questionAnalysis['primaryCategory'] as String;
    final emotionalTone = questionAnalysis['emotionalTone'] as String;
    final balance = (cardAnalysis['balance']
            as Map<String, dynamic>?)?['balance'] as String? ??
        'balanced';

    final guidance = <String>[];
    final affirmations = <String>[];
    final warnings = <String>[];

    // Generate guidance based on category and balance
    switch (category) {
      case 'love':
        if (balance == 'positive') {
          guidance
            ..add(l10n.openHeartNewPossibilities)
            ..add(l10n.expressFeelingsAuthentically);
          affirmations.add(l10n.worthyOfLoveAndRespect);
        } else if (balance == 'negative') {
          guidance
            ..add(l10n.focusSelfLoveHealing)
            ..add(l10n.communicateOpenlyConcerns);
          warnings.add(l10n.avoidRushingRelationships);
        } else {
          guidance
            ..add(l10n.maintainBalanceGivingReceiving)
            ..add(l10n.practicePatienceRelationships);
        }

      case 'career':
        if (balance == 'positive') {
          guidance
            ..add(l10n.takeConfidentActionGoals)
            ..add(l10n.networkBuildRelationships);
          affirmations.add(l10n.skillsToSucceed);
        } else if (balance == 'negative') {
          guidance
            ..add(l10n.addressSkillGapsObstacles)
            ..add(l10n.seekMentorshipGuidance);
          warnings.add(l10n.avoidHastyCareerDecisions);
        } else {
          guidance
            ..add(l10n.focusSteadyProgress)
            ..add(l10n.balanceWorkPersonalDevelopment);
        }

      case 'finance':
        if (balance == 'positive') {
          guidance
            ..add(l10n.investFutureWisely)
            ..add(l10n.shareAbundanceOthers);
          affirmations.add(l10n.attractFinancialProsperity);
        } else if (balance == 'negative') {
          guidance
            ..add(l10n.createBudgetFinancialPlan)
            ..add(l10n.avoidUnnecessaryExpenses);
          warnings.add(l10n.cautiousFinancialDecisions);
        } else {
          guidance
            ..add(l10n.maintainFinancialDiscipline)
            ..add(l10n.buildLongTermSecurity);
        }

      default:
        if (balance == 'positive') {
          guidance
            ..add(l10n.embracePositiveEnergy)
            ..add(l10n.takeActionGoals);
          affirmations.add(l10n.capableAndConfident);
        } else if (balance == 'negative') {
          guidance
            ..add(l10n.practiceSelfCarePatience)
            ..add(l10n.seekSupportWhenNeeded);
          warnings.add(l10n.avoidMajorDecisionsNow);
        } else {
          guidance
            ..add(l10n.maintainBalanceAllAreas)
            ..add(l10n.trustNaturalFlowEvents);
        }
    }

    // Add general guidance based on emotional tone
    if (emotionalTone == 'urgent') {
      guidance.add(l10n.takeTimeReflectActing);
      warnings.add(l10n.avoidRushedDecisions);
    } else if (emotionalTone == 'negative') {
      guidance.add(l10n.practiceGratitudePositiveThinking);
      affirmations.add(l10n.chooseSeeGoodEverySituation);
    }

    return {
      'actions': guidance,
      'affirmations': affirmations,
      'warnings': warnings,
      'focusAreas': _getFocusAreas(cards, category, l10n),
    };
  }

  /// [_getFocusAreas] - Get areas to focus on based on selected cards
  static List<String> _getFocusAreas(
    List<Map<String, dynamic>> cards,
    String category,
    AppLocalizations l10n,
  ) {
    final focusAreas = <String>[];

    for (final card in cards) {
      final cardName = card['name']?.toString() ?? '';

      if (cardName.contains('High Priestess')) {
        focusAreas.add(l10n.intuitionInnerWisdom);
      } else if (cardName.contains('Hermit')) {
        focusAreas.add(l10n.selfReflectionSolitude);
      } else if (cardName.contains('Temperance')) {
        focusAreas.add(l10n.balanceModeration);
      } else if (cardName.contains('Justice')) {
        focusAreas.add(l10n.fairnessTruth);
      } else if (cardName.contains('Strength')) {
        focusAreas.add(l10n.innerStrengthCourage);
      }
    }

    // Add category-specific focus areas
    switch (category) {
      case 'love':
        focusAreas.add(l10n.emotionalCommunication);
        focusAreas.add(l10n.selfLoveBoundaries);
      case 'career':
        focusAreas.add(l10n.skillDevelopment);
        focusAreas.add(l10n.professionalNetworking);
      case 'finance':
        focusAreas.add(l10n.financialPlanning);
        focusAreas.add(l10n.responsibleSpending);
    }

    return focusAreas.take(5).toList(); // Limit to top 5 focus areas
  }

  static Map<String, dynamic> _generateTimingInsights(
    List<Map<String, dynamic>> cards,
    Map<String, dynamic> questionAnalysis,
    AppLocalizations l10n,
  ) {
    final category = questionAnalysis['primaryCategory'] as String;
    final questionType = questionAnalysis['questionType'] as String;

    // Analyze timing patterns in the cards
    final timingPatterns = <String>[];
    final timeframes = <String>[];

    for (final card in cards) {
      final meaning = card['upright_meaning']?.toString() ?? '';
      final lowerMeaning = meaning.toLowerCase();

      if (lowerMeaning.contains('new moon') ||
          lowerMeaning.contains('full moon')) {
        timingPatterns.add(l10n.lunarCyclesInfluenceTiming);
      } else if (lowerMeaning.contains('seasons') ||
          lowerMeaning.contains('cycles')) {
        timingPatterns.add(l10n.naturalCyclesImportant);
      } else if (lowerMeaning.contains('patience') ||
          lowerMeaning.contains('wait')) {
        timingPatterns.add(l10n.patienceRequired);
      }
    }

    // Generate timeframes based on category and question type
    switch (category) {
      case 'love':
        if (questionType == 'timing') {
          timeframes
            ..add(l10n.within1To3MonthsNewConnections)
            ..add(l10n.sixToTwelveMonthsDeeperCommitments);
        }
      case 'career':
        if (questionType == 'timing') {
          timeframes
            ..add(l10n.within3To6MonthsCareerChanges)
            ..add(l10n.oneToTwoYearsMajorCareerGrowth);
        }
      case 'finance':
        if (questionType == 'timing') {
          timeframes
            ..add(l10n.within6To12MonthsFinancialImprovement)
            ..add(l10n.twoToThreeYearsLongTermFinancialGoals);
        }
    }

    // Add general timing insights
    if (questionType == 'decision') {
      timeframes
        ..add(l10n.takeTimeToReflectBeforeDeciding)
        ..add(l10n.trustIntuitionInTiming);
    }

    return {
      'patterns': timingPatterns,
      'timeframes': timeframes,
      'bestTimes': _getBestTimes(cards, category, l10n),
      'considerations': _getTimingConsiderations(cards, l10n),
    };
  }

  /// [_getBestTimes] - Get best times for action based on cards
  static List<String> _getBestTimes(
    List<Map<String, dynamic>> cards,
    String category,
    AppLocalizations l10n,
  ) {
    final bestTimes = <String>[];

    // Analyze cards for timing indicators
    var hasMoonCards = false;
    var hasSunCards = false;
    var hasSeasonalCards = false;

    for (final card in cards) {
      final cardName = card['name']?.toString() ?? '';
      if (cardName.contains('Moon')) hasMoonCards = true;
      if (cardName.contains('Sun')) hasSunCards = true;
      if (cardName.contains('Wheel') || cardName.contains('Tower')) {
        hasSeasonalCards = true;
      }
    }

    if (hasMoonCards) {
      bestTimes
        ..add(l10n.newMoonNewBeginnings)
        ..add(l10n.fullMoonCompletionClarity);
    }

    if (hasSunCards) {
      bestTimes
        ..add(l10n.daytimeHoursPositiveActions)
        ..add(l10n.sunnyDaysImportantDecisions);
    }

    if (hasSeasonalCards) {
      bestTimes
        ..add(l10n.springNewProjectsGrowth)
        ..add(l10n.autumnReflectionPlanning);
    }

    // Add category-specific timing
    switch (category) {
      case 'love':
        bestTimes.add(l10n.fridayEveningsRomanticActivities);
        bestTimes.add(l10n.venusRuledHoursRelationshipDecisions);
      case 'career':
        bestTimes.add(l10n.mondayMorningsNewInitiatives);
        bestTimes.add(l10n.mercuryRuledHoursCommunication);
      case 'finance':
        bestTimes.add(l10n.newMoonFinancialPlanning);
        bestTimes.add(l10n.jupiterRuledHoursAbundanceWork);
    }

    return bestTimes;
  }

  /// [_getTimingConsiderations] - Get important timing considerations
  static List<String> _getTimingConsiderations(
    List<Map<String, dynamic>> cards,
    AppLocalizations l10n,
  ) {
    final considerations = <String>[];

    // Check for specific timing cards
    for (final card in cards) {
      final cardName = card['name']?.toString() ?? '';

      if (cardName.contains('Hanged Man')) {
        considerations.add(l10n.patienceRequiredTimingNotRight);
      } else if (cardName.contains('Wheel of Fortune')) {
        considerations.add(l10n.changeConstantBeFlexible);
      } else if (cardName.contains('Death')) {
        considerations.add(l10n.endingsCreateSpaceNewBeginnings);
      } else if (cardName.contains('Tower')) {
        considerations.add(l10n.suddenChangesAccelerateTiming);
      }
    }

    // Add general considerations
    considerations
      ..add(l10n.trustIntuitionAboutTiming)
      ..add(l10n.externalFactorsInfluenceTiming)
      ..add(l10n.personalReadinessImportantTiming);

    return considerations;
  }

  /// [_generateEmotionalInsights] - Generate emotional intelligence insights
  static Map<String, dynamic> _generateEmotionalInsights(
    List<Map<String, dynamic>> cards,
    Map<String, dynamic> questionAnalysis,
    Map<String, dynamic> cardAnalysis,
    AppLocalizations l10n,
  ) {
    final emotionalPatterns = <String>[];
    final emotionalStates = <String>[];
    final emotionalGrowth = <String>[];
    final emotionalChallenges = <String>[];

    // Analyze emotional patterns in cards
    for (final card in cards) {
      final meaning = card['upright_meaning']?.toString() ?? '';
      final reversedMeaning = card['reversed_meaning']?.toString() ?? '';
      final isReversed = card['is_reversed'] == true;
      final cardMeaning = isReversed ? reversedMeaning : meaning;

      if (cardMeaning.contains('emotion') || cardMeaning.contains('feeling')) {
        emotionalPatterns.add(l10n.emotionalAwarenessHighlighted);
      }
      if (cardMeaning.contains('intuition') ||
          cardMeaning.contains('psychic')) {
        emotionalPatterns.add(l10n.intuitiveAbilitiesEnhanced);
      }
      if (cardMeaning.contains('healing') || cardMeaning.contains('recovery')) {
        emotionalGrowth.add(l10n.emotionalHealingGrowth);
      }
      if (cardMeaning.contains('conflict') ||
          cardMeaning.contains('struggle')) {
        emotionalChallenges.add(l10n.emotionalChallengesOvercome);
      }
    }

    // Add question-based emotional insights
    final emotionalTone = questionAnalysis['emotionalTone'] as String;
    switch (emotionalTone) {
      case 'urgent':
        emotionalStates.add(l10n.feelingPressuredRushed);
        emotionalGrowth.add(l10n.practiceEmotionalRegulation);
      case 'negative':
        emotionalStates.add(l10n.experiencingDifficultEmotions);
        emotionalGrowth.add(l10n.focusOnEmotionalSelfCare);
      case 'positive':
        emotionalStates.add(l10n.feelingOptimisticHopeful);
        emotionalGrowth.add(l10n.sharePositiveEnergyOthers);
      default:
        emotionalStates.add(l10n.maintainingEmotionalBalance);
        emotionalGrowth.add(l10n.continueEmotionalAwarenessPractices);
    }

    return {
      'patterns': emotionalPatterns,
      'currentStates': emotionalStates,
      'growthAreas': emotionalGrowth,
      'challenges': emotionalChallenges,
      'recommendations': _getEmotionalRecommendations(cards, emotionalTone),
    };
  }

  /// [_getEmotionalRecommendations] - Get emotional self-care recommendations
  static List<String> _getEmotionalRecommendations(
    List<Map<String, dynamic>> cards,
    String emotionalTone,
  ) {
    final recommendations = <String>[];

    // Card-based recommendations
    for (final card in cards) {
      final cardName = card['name']?.toString() ?? '';
      if (cardName.contains('High Priestess')) {
        recommendations.add('Practice meditation and quiet reflection');
      } else if (cardName.contains('Strength')) {
        recommendations.add('Use inner strength to manage emotions');
      } else if (cardName.contains('Temperance')) {
        recommendations.add('Find balance in emotional responses');
      }
    }

    // Tone-based recommendations
    switch (emotionalTone) {
      case 'urgent':
        recommendations
          ..add('Take deep breaths before making decisions')
          ..add('Use grounding techniques like 5-4-3-2-1 method');
      case 'negative':
        recommendations
          ..add('Practice self-compassion and kindness')
          ..add('Engage in activities that bring joy');
      case 'positive':
        recommendations
          ..add('Share your positive energy with others')
          ..add('Document your positive experiences');
    }

    return recommendations.take(5).toList();
  }

  /// [_generateNumerologicalInsights] - Generate numerological insights from cards
  static Map<String, dynamic> _generateNumerologicalInsights(
    List<Map<String, dynamic>> cards,
  ) {
    final numerologicalMeanings = <String>[];
    final lifePathNumbers = <int>[];
    final karmicNumbers = <int>[];

    for (final card in cards) {
      final cardName = card['name']?.toString() ?? '';

      // Extract numbers from card names
      final numbers = RegExp(r'\d+').allMatches(cardName);
      for (final match in numbers) {
        final number = int.parse(match.group(0)!);
        lifePathNumbers.add(number);

        // Calculate karmic number (sum of digits)
        final karmicNumber = _calculateKarmicNumber(number);
        karmicNumbers.add(karmicNumber);

        numerologicalMeanings.add(_getNumerologicalMeaning(number));
      }
    }

    // Calculate overall numerological energy
    final totalEnergy = lifePathNumbers.fold(0, (sum, number) => sum + number);
    final reducedEnergy = _reduceToSingleDigit(totalEnergy);

    return {
      'lifePathNumbers': lifePathNumbers,
      'karmicNumbers': karmicNumbers,
      'totalEnergy': totalEnergy,
      'reducedEnergy': reducedEnergy,
      'meanings': numerologicalMeanings,
      'overallVibration': _getNumerologicalVibration(reducedEnergy),
    };
  }

  /// [_calculateKarmicNumber] - Calculate karmic number from a number
  static int _calculateKarmicNumber(int number) {
    if (number < 10) return number;
    return _reduceToSingleDigit(number);
  }

  /// [_reduceToSingleDigit] - Reduce a number to single digit
  static int _reduceToSingleDigit(int number) {
    if (number < 10) return number;
    final digits = number.toString().split('').map(int.parse).toList();
    final sum = digits.fold(0, (sum, digit) => sum + digit);
    return _reduceToSingleDigit(sum);
  }

  /// [_getNumerologicalMeaning] - Get meaning for a specific number
  static String _getNumerologicalMeaning(int number) {
    switch (number) {
      case 1:
        return 'Leadership, independence, new beginnings';
      case 2:
        return 'Partnership, balance, harmony';
      case 3:
        return 'Creativity, self-expression, joy';
      case 4:
        return 'Stability, foundation, hard work';
      case 5:
        return 'Change, freedom, adventure';
      case 6:
        return 'Love, responsibility, nurturing';
      case 7:
        return 'Spirituality, wisdom, introspection';
      case 8:
        return 'Power, abundance, achievement';
      case 9:
        return 'Completion, humanitarianism, wisdom';
      default:
        return 'Universal energy and potential';
    }
  }

  /// [_getNumerologicalVibration] - Get overall numerological vibration
  static String _getNumerologicalVibration(int number) {
    switch (number) {
      case 1:
        return 'High energy for new beginnings and leadership';
      case 2:
        return 'Balanced energy for partnerships and harmony';
      case 3:
        return 'Creative energy for self-expression and joy';
      case 4:
        return 'Stable energy for building foundations';
      case 5:
        return 'Dynamic energy for change and growth';
      case 6:
        return 'Nurturing energy for love and responsibility';
      case 7:
        return 'Spiritual energy for wisdom and insight';
      case 8:
        return 'Powerful energy for achievement and abundance';
      case 9:
        return 'Wise energy for completion and service';
      default:
        return 'Universal energy for transformation';
    }
  }

  /// [_generateAstrologicalInsights] - Generate astrological correspondences
  static Map<String, dynamic> _generateAstrologicalInsights(
    List<Map<String, dynamic>> cards,
  ) {
    final planetaryRulers = <String>[];
    final zodiacSigns = <String>[];
    final astrologicalHouses = <String>[];
    final cosmicInfluences = <String>[];

    for (final card in cards) {
      final cardName = card['name']?.toString() ?? '';

      // Planetary correspondences
      if (cardName.contains('Sun')) {
        planetaryRulers.add('Sun - Vitality and self-expression');
        zodiacSigns.add('Leo - Creative and confident energy');
      } else if (cardName.contains('Moon')) {
        planetaryRulers.add('Moon - Intuition and emotions');
        zodiacSigns.add('Cancer - Nurturing and protective energy');
      } else if (cardName.contains('Star')) {
        planetaryRulers.add('Venus - Love and beauty');
        zodiacSigns.add('Libra - Balance and harmony');
      } else if (cardName.contains('Tower')) {
        planetaryRulers.add('Mars - Action and transformation');
        zodiacSigns.add('Aries - Bold and pioneering energy');
      } else if (cardName.contains('Hermit')) {
        planetaryRulers.add('Mercury - Communication and wisdom');
        zodiacSigns.add('Virgo - Analytical and practical energy');
      }

      // House correspondences based on card themes
      if (cardName.contains('Love') || cardName.contains('Lovers')) {
        astrologicalHouses.add('7th House - Partnerships and relationships');
      } else if (cardName.contains('Money') || cardName.contains('Pentacles')) {
        astrologicalHouses.add('2nd House - Values and resources');
      } else if (cardName.contains('Career') || cardName.contains('Magician')) {
        astrologicalHouses.add('10th House - Career and public image');
      } else if (cardName.contains('Home') ||
          cardName.contains('Four of Wands')) {
        astrologicalHouses.add('4th House - Home and family');
      }
    }

    // Add cosmic timing insights
    final currentMonth = DateTime.now().month;
    if (currentMonth >= 3 && currentMonth <= 5) {
      cosmicInfluences.add('Spring Equinox energy - New beginnings and growth');
    } else if (currentMonth >= 6 && currentMonth <= 8) {
      cosmicInfluences.add(
        'Summer Solstice energy - Peak manifestation and abundance',
      );
    } else if (currentMonth >= 9 && currentMonth <= 11) {
      cosmicInfluences.add('Autumn Equinox energy - Harvest and reflection');
    } else {
      cosmicInfluences.add(
        'Winter Solstice energy - Introspection and renewal',
      );
    }

    return {
      'planetaryRulers': planetaryRulers,
      'zodiacSigns': zodiacSigns,
      'astrologicalHouses': astrologicalHouses,
      'cosmicInfluences': cosmicInfluences,
      'currentTransits': _getCurrentAstrologicalTransits(),
    };
  }

  /// [_getCurrentAstrologicalTransits] - Get current astrological influences
  static List<String> _getCurrentAstrologicalTransits() {
    final transits = <String>[];
    final now = DateTime.now();

    // Add seasonal influences
    if (now.month == 3 && now.day >= 20) {
      transits.add('Aries season - Bold new beginnings and leadership');
    } else if (now.month == 4) {
      transits.add('Taurus season - Stability and material abundance');
    } else if (now.month == 5) {
      transits.add('Gemini season - Communication and intellectual growth');
    }

    // Add lunar phase influence
    final daysSinceNewMoon = _calculateDaysSinceNewMoon(now);
    if (daysSinceNewMoon <= 3) {
      transits.add('New Moon phase - Setting intentions and new beginnings');
    } else if (daysSinceNewMoon >= 12 && daysSinceNewMoon <= 15) {
      transits.add('Full Moon phase - Manifestation and completion');
    }

    return transits;
  }

  /// [_calculateDaysSinceNewMoon] - Calculate days since last new moon
  static int _calculateDaysSinceNewMoon(DateTime date) {
    // Simplified calculation - in production, use astronomical data
    const lunarCycle = 29.53; // days
    final knownNewMoon = DateTime(2024, 1, 11); // Known new moon date
    final daysDiff = date.difference(knownNewMoon).inDays;
    return (daysDiff % lunarCycle).round();
  }

  /// [_generateSeasonalInsights] - Generate seasonal and elemental insights
  static Map<String, dynamic> _generateSeasonalInsights(
    List<Map<String, dynamic>> cards,
  ) {
    final elementalEnergies = <String>[];
    final seasonalThemes = <String>[];
    final naturalCycles = <String>[];

    // Analyze elemental correspondences
    var fireCount = 0;
    var waterCount = 0;
    var airCount = 0;
    var earthCount = 0;

    for (final card in cards) {
      final suit = card['suit']?.toString() ?? '';
      final cardName = card['name']?.toString() ?? '';

      // Suit-based elemental analysis
      switch (suit.toLowerCase()) {
        case 'wands':
          fireCount++;
          elementalEnergies.add(
            'Fire - Passion, creativity, and transformation',
          );
        case 'cups':
          waterCount++;
          elementalEnergies.add(
            'Water - Emotions, intuition, and relationships',
          );
        case 'swords':
          airCount++;
          elementalEnergies.add('Air - Intellect, communication, and clarity');
        case 'pentacles':
          earthCount++;
          elementalEnergies.add(
            'Earth - Material world, stability, and abundance',
          );
      }

      // Card-specific seasonal themes
      if (cardName.contains('Sun')) {
        seasonalThemes.add('Summer energy - Peak manifestation and joy');
      } else if (cardName.contains('Moon')) {
        seasonalThemes.add('Night energy - Intuition and subconscious');
      } else if (cardName.contains('Star')) {
        seasonalThemes.add('Starry night energy - Hope and inspiration');
      } else if (cardName.contains('Death')) {
        seasonalThemes.add('Autumn energy - Transformation and letting go');
      } else if (cardName.contains('Fool')) {
        seasonalThemes.add('Spring energy - New beginnings and innocence');
      }
    }

    // Determine dominant element
    final elementCounts = {
      'fire': fireCount,
      'water': waterCount,
      'air': airCount,
      'earth': earthCount,
    };

    final dominantElement =
        elementCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    // Add natural cycle insights
    final currentSeason = _getCurrentSeason();
    naturalCycles
      ..add('Current season: $currentSeason')
      ..add(
        'Dominant element: ${_getElementDescription(dominantElement)}',
      );

    return {
      'elementalEnergies': elementalEnergies,
      'seasonalThemes': seasonalThemes,
      'naturalCycles': naturalCycles,
      'dominantElement': dominantElement,
      'elementalBalance': _getElementalBalance(elementCounts),
      'seasonalRecommendations': _getSeasonalRecommendations(
        currentSeason,
        dominantElement,
      ),
    };
  }

  /// [_getCurrentSeason] - Get current season
  static String _getCurrentSeason() {
    final now = DateTime.now();
    final month = now.month;

    if (month >= 3 && month <= 5) return 'Spring';
    if (month >= 6 && month <= 8) return 'Summer';
    if (month >= 9 && month <= 11) return 'Autumn';
    return 'Winter';
  }

  /// [_getElementDescription] - Get description for an element
  static String _getElementDescription(String element) {
    switch (element) {
      case 'fire':
        return 'Passionate, creative, and transformative energy';
      case 'water':
        return 'Emotional, intuitive, and flowing energy';
      case 'air':
        return 'Intellectual, communicative, and adaptable energy';
      case 'earth':
        return 'Stable, practical, and grounding energy';
      default:
        return 'Balanced elemental energy';
    }
  }

  /// [_getElementalBalance] - Get elemental balance analysis
  static Map<String, dynamic> _getElementalBalance(
    Map<String, int> elementCounts,
  ) {
    final total = elementCounts.values.fold(0, (sum, count) => sum + count);
    if (total == 0) {
      return {
        'status': 'balanced',
        'message': 'No elemental influence detected',
      };
    }

    final maxCount = elementCounts.values.reduce((a, b) => a > b ? a : b);
    final minCount = elementCounts.values.reduce((a, b) => a < b ? a : b);
    final balance = maxCount - minCount;

    if (balance <= 1) {
      return {
        'status': 'balanced',
        'message': 'Elements are well-balanced, indicating harmony',
      };
    } else if (balance <= 2) {
      return {
        'status': 'slightly_unbalanced',
        'message': 'Elements show slight imbalance, consider grounding',
      };
    } else {
      return {
        'status': 'unbalanced',
        'message': 'Elements are significantly unbalanced, seek equilibrium',
      };
    }
  }

  /// [_getSeasonalRecommendations] - Get seasonal recommendations
  static List<String> _getSeasonalRecommendations(
    String season,
    String dominantElement,
  ) {
    final recommendations = <String>[];

    switch (season) {
      case 'Spring':
        recommendations
          ..add('Focus on new beginnings and growth')
          ..add('Plant seeds for future success');
      case 'Summer':
        recommendations
          ..add('Harness peak energy for manifestation')
          ..add('Celebrate achievements and abundance');
      case 'Autumn':
        recommendations
          ..add('Reflect on accomplishments and lessons')
          ..add('Prepare for winter introspection');
      case 'Winter':
        recommendations
          ..add('Use quiet time for planning and reflection')
          ..add('Conserve energy for spring renewal');
    }

    // Add element-specific recommendations
    switch (dominantElement) {
      case 'fire':
        recommendations.add('Channel passion into productive action');
      case 'water':
        recommendations.add('Trust your intuition and emotional wisdom');
      case 'air':
        recommendations.add('Communicate clearly and seek clarity');
      case 'earth':
        recommendations.add('Focus on practical steps and stability');
    }

    return recommendations;
  }

  /// [_analyzeCardCombinations] - Analyze special card combinations and patterns
  static Map<String, dynamic> _analyzeCardCombinations(
    List<Map<String, dynamic>> cards,
  ) {
    final combinations = <String>[];
    final specialPatterns = <String>[];
    final archetypalThemes = <String>[];

    if (cards.length < 2) {
      return {
        'combinations': combinations,
        'specialPatterns': specialPatterns,
        'archetypalThemes': archetypalThemes,
      };
    }

    // Check for major arcana combinations
    final majorArcana = cards
        .where(
          (card) =>
              card['type'] == 'major' ||
              // ignore: use_if_null_to_convert_nulls_to_bools
              card['name']?.toString().contains('The ') == true,
        )
        .toList();

    if (majorArcana.length >= 2) {
      combinations.add(
        'Multiple Major Arcana - Significant life themes and lessons',
      );

      // Check for specific major arcana combinations
      final hasFool = majorArcana.any(
        (card) => card['name']?.toString().contains('Fool') ?? false,
      );
      final hasMagician = majorArcana.any(
        (card) => card['name']?.toString().contains('Magician') ?? false,
      );
      final hasHighPriestess = majorArcana.any(
        (card) => card['name']?.toString().contains('High Priestess') ?? false,
      );

      if (hasFool && hasMagician) {
        combinations.add(
          'Fool + Magician - New beginnings with powerful manifestation energy',
        );
      }
      if (hasFool && hasHighPriestess) {
        combinations.add(
          'Fool + High Priestess - Innocent wisdom and intuitive guidance',
        );
      }
    }

    // Check for suit combinations
    final suits = cards.map((card) => card['suit']?.toString() ?? '').toSet();
    if (suits.length == 4) {
      combinations.add(
        'All Four Suits - Balanced elemental energy and comprehensive perspective',
      );
    } else if (suits.length == 1) {
      final dominantSuit = suits.first;
      combinations.add(
        'Single Suit Dominance - Focused energy in ${_getSuitDescription(dominantSuit)}',
      );
    }

    // Check for number patterns
    final numbers = <int>[];
    for (final card in cards) {
      final cardName = card['name']?.toString() ?? '';
      final numberMatches = RegExp(r'\d+').allMatches(cardName);
      for (final match in numberMatches) {
        numbers.add(int.parse(match.group(0)!));
      }
    }

    if (numbers.length >= 2) {
      // Check for sequential numbers
      numbers.sort();
      var hasSequential = false;
      for (var i = 0; i < numbers.length - 1; i++) {
        if (numbers[i + 1] - numbers[i] == 1) {
          hasSequential = true;
          break;
        }
      }
      if (hasSequential) {
        combinations.add(
          'Sequential Numbers - Progressive development and natural flow',
        );
      }

      // Check for repeating numbers
      final numberCounts = <int, int>{};
      for (final number in numbers) {
        numberCounts[number] = (numberCounts[number] ?? 0) + 1;
      }
      final repeatingNumbers = numberCounts.entries
          .where((entry) => entry.value > 1)
          .map((entry) => entry.key)
          .toList();

      if (repeatingNumbers.isNotEmpty) {
        combinations.add(
          'Repeating Numbers - Amplified energy and emphasis on ${repeatingNumbers.join(", ")}',
        );
      }
    }

    // Check for shadow work indicators
    final shadowCards = cards.where((card) {
      final cardName = card['name']?.toString() ?? '';
      return cardName.contains('Death') ||
          cardName.contains('Tower') ||
          cardName.contains('Devil') ||
          cardName.contains('Moon') ||
          cardName.contains('Hanged Man');
    }).toList();

    if (shadowCards.isNotEmpty) {
      specialPatterns.add(
        'Shadow Work - Deep transformation and facing inner challenges',
      );
      archetypalThemes.add(
        'Shadow Integration - Embracing difficult aspects for growth',
      );
    }

    // Check for abundance indicators
    final abundanceCards = cards.where((card) {
      final cardName = card['name']?.toString() ?? '';
      return cardName.contains('Sun') ||
          cardName.contains('Star') ||
          cardName.contains('Ten of Pentacles') ||
          cardName.contains('Nine of Cups');
    }).toList();

    if (abundanceCards.isNotEmpty) {
      specialPatterns.add(
        'Abundance Energy - Prosperity, joy, and fulfillment',
      );
      archetypalThemes.add('Manifestation - Creating positive outcomes');
    }

    // Check for spiritual growth indicators
    final spiritualCards = cards.where((card) {
      final cardName = card['name']?.toString() ?? '';
      return cardName.contains('High Priestess') ||
          cardName.contains('Hermit') ||
          cardName.contains('Hierophant') ||
          cardName.contains('Temperance');
    }).toList();

    if (spiritualCards.isNotEmpty) {
      specialPatterns.add(
        'Spiritual Growth - Inner wisdom and spiritual development',
      );
      archetypalThemes.add(
        'Divine Guidance - Higher wisdom and spiritual connection',
      );
    }

    return {
      'combinations': combinations,
      'specialPatterns': specialPatterns,
      'archetypalThemes': archetypalThemes,
      'majorArcanaCount': majorArcana.length,
      'suitDiversity': suits.length,
      'numberPatterns': _analyzeNumberPatterns(numbers),
    };
  }

  /// [_getSuitDescription] - Get description for a suit
  static String _getSuitDescription(String suit) {
    switch (suit.toLowerCase()) {
      case 'wands':
        return 'passion, creativity, and spiritual growth';
      case 'cups':
        return 'emotions, relationships, and intuition';
      case 'swords':
        return 'intellect, communication, and mental clarity';
      case 'pentacles':
        return 'material world, finances, and practical matters';
      default:
        return 'universal energy';
    }
  }

  /// [_analyzeNumberPatterns] - Analyze patterns in card numbers
  static Map<String, dynamic> _analyzeNumberPatterns(List<int> numbers) {
    if (numbers.isEmpty) return {};

    final patterns = <String>[];
    final dominantNumbers = <int>[];
    final numerologicalThemes = <String>[];

    // Find most common numbers
    final numberCounts = <int, int>{};
    for (final number in numbers) {
      numberCounts[number] = (numberCounts[number] ?? 0) + 1;
    }

    final sortedNumbers = numberCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (sortedNumbers.isNotEmpty) {
      final mostCommon = sortedNumbers.first;
      dominantNumbers.add(mostCommon.key);
      patterns.add(
        'Dominant number: ${mostCommon.key} (appears ${mostCommon.value} times)',
      );
    }

    // Check for master numbers (11, 22, 33)
    final masterNumbers =
        numbers.where((n) => n == 11 || n == 22 || n == 33).toList();
    if (masterNumbers.isNotEmpty) {
      patterns.add(
        'Master numbers present: ${masterNumbers.join(", ")} - Higher spiritual vibration',
      );
      numerologicalThemes.add(
        'Master Number Energy - Enhanced spiritual potential and karmic lessons',
      );
    }

    // Check for karmic numbers (13, 14, 16, 19)
    final karmicNumbers =
        numbers.where((n) => n == 13 || n == 14 || n == 16 || n == 19).toList();
    if (karmicNumbers.isNotEmpty) {
      patterns.add(
        'Karmic numbers present: ${karmicNumbers.join(", ")} - Past life lessons and growth',
      );
      numerologicalThemes.add(
        'Karmic Lessons - Working through past patterns and challenges',
      );
    }

    return {
      'patterns': patterns,
      'dominantNumbers': dominantNumbers,
      'numerologicalThemes': numerologicalThemes,
      'totalNumbers': numbers.length,
      'uniqueNumbers': numbers.toSet().length,
    };
  }

  /// [_generateShadowWorkInsights] - Generate insights for shadow work and transformation
  static Map<String, dynamic> _generateShadowWorkInsights(
    List<Map<String, dynamic>> cards,
    Map<String, dynamic> questionAnalysis,
  ) {
    final shadowThemes = <String>[];
    final transformationAreas = <String>[];
    final healingPractices = <String>[];
    final growthOpportunities = <String>[];

    // Identify shadow work cards
    final shadowCards = cards.where((card) {
      final cardName = card['name']?.toString() ?? '';
      return cardName.contains('Death') ||
          cardName.contains('Tower') ||
          cardName.contains('Devil') ||
          cardName.contains('Moon') ||
          cardName.contains('Hanged Man') ||
          cardName.contains('Eight of Cups') ||
          cardName.contains('Five of Pentacles');
    }).toList();

    for (final card in shadowCards) {
      final cardName = card['name']?.toString() ?? '';

      if (cardName.contains('Death')) {
        shadowThemes.add('Transformation and letting go of old patterns');
        transformationAreas.add('Ending cycles and embracing change');
        healingPractices.add('Practice acceptance of natural endings');
      } else if (cardName.contains('Tower')) {
        shadowThemes.add('Sudden change and breaking down of illusions');
        transformationAreas.add('Rebuilding after disruption');
        healingPractices.add('Embrace the chaos as a catalyst for growth');
      } else if (cardName.contains('Devil')) {
        shadowThemes.add('Facing attachments and limiting beliefs');
        transformationAreas.add('Breaking free from unhealthy patterns');
        healingPractices.add('Identify and release what no longer serves you');
      } else if (cardName.contains('Moon')) {
        shadowThemes.add('Working with subconscious and intuition');
        transformationAreas.add('Trusting inner wisdom and dreams');
        healingPractices.add('Practice dream journaling and moon rituals');
      } else if (cardName.contains('Hanged Man')) {
        shadowThemes.add('Surrendering control and gaining new perspective');
        transformationAreas.add('Finding wisdom in stillness and sacrifice');
        healingPractices.add(
          'Practice meditation and surrender to the process',
        );
      }
    }

    // Add question-based shadow work insights
    final category = questionAnalysis['primaryCategory'] as String;
    switch (category) {
      case 'love':
        shadowThemes.add('Examining relationship patterns and self-worth');
        transformationAreas.add('Healing from past relationship wounds');
        healingPractices.add('Practice self-love and boundary setting');
      case 'career':
        shadowThemes.add('Facing career fears and limiting beliefs');
        transformationAreas.add('Overcoming imposter syndrome and self-doubt');
        healingPractices.add('Acknowledge your achievements and capabilities');
      case 'finance':
        shadowThemes.add('Examining money mindset and abundance blocks');
        transformationAreas.add('Releasing scarcity thinking and fear');
        healingPractices.add('Practice gratitude and abundance affirmations');
    }

    // Add growth opportunities based on shadow work
    if (shadowThemes.isNotEmpty) {
      growthOpportunities
        ..add('Embrace vulnerability as a strength')
        ..add('Use challenges as opportunities for growth')
        ..add('Practice self-compassion during difficult times')
        ..add('Seek support from trusted friends or professionals')
        ..add('Document your transformation journey');
    }

    return {
      'shadowThemes': shadowThemes,
      'transformationAreas': transformationAreas,
      'healingPractices': healingPractices,
      'growthOpportunities': growthOpportunities,
      'shadowCardCount': shadowCards.length,
      'intensity': _calculateShadowWorkIntensity(shadowCards),
    };
  }

  /// [_calculateShadowWorkIntensity] - Calculate the intensity of shadow work needed
  static String _calculateShadowWorkIntensity(
    List<Map<String, dynamic>> shadowCards,
  ) {
    if (shadowCards.isEmpty) return 'minimal';

    var intensityScore = 0;
    for (final card in shadowCards) {
      final cardName = card['name']?.toString() ?? '';
      final isReversed = card['is_reversed'] == true;

      // Assign intensity scores to different shadow cards
      if (cardName.contains('Death')) {
        intensityScore += isReversed ? 3 : 4;
      } else if (cardName.contains('Tower')) {
        intensityScore += isReversed ? 4 : 5;
      } else if (cardName.contains('Devil')) {
        intensityScore += isReversed ? 4 : 5;
      } else if (cardName.contains('Moon')) {
        intensityScore += isReversed ? 2 : 3;
      } else if (cardName.contains('Hanged Man')) {
        intensityScore += isReversed ? 3 : 4;
      }
    }

    if (intensityScore <= 3) return 'mild';
    if (intensityScore <= 6) return 'moderate';
    if (intensityScore <= 9) return 'intense';
    return 'profound';
  }

  /// [_generateArchetypalInsights] - Generate archetypal and psychological insights
  static Map<String, dynamic> _generateArchetypalInsights(
    List<Map<String, dynamic>> cards,
  ) {
    final archetypes = <String>[];
    final psychologicalThemes = <String>[];
    final personalityInsights = <String>[];
    final growthArchetypes = <String>[];

    for (final card in cards) {
      final cardName = card['name']?.toString() ?? '';

      // Major arcana archetypes
      if (cardName.contains('Fool')) {
        archetypes.add('The Fool - Innocence, new beginnings, and trust');
        psychologicalThemes.add(
          'Embracing uncertainty and taking leaps of faith',
        );
        personalityInsights.add(
          'You have a natural ability to start fresh and trust the journey',
        );
      } else if (cardName.contains('Magician')) {
        archetypes.add('The Magician - Manifestation, power, and skill');
        psychologicalThemes.add(
          'Using your talents and resources to create change',
        );
        personalityInsights.add(
          'You possess the tools and abilities to manifest your desires',
        );
      } else if (cardName.contains('High Priestess')) {
        archetypes.add('The High Priestess - Intuition, wisdom, and mystery');
        psychologicalThemes.add(
          'Trusting your inner knowing and subconscious mind',
        );
        personalityInsights.add(
          'Your intuition is a powerful guide - listen to it',
        );
      } else if (cardName.contains('Empress')) {
        archetypes.add('The Empress - Nurturing, abundance, and creativity');
        psychologicalThemes.add('Creating and nurturing what you value');
        personalityInsights.add(
          'You have a natural ability to create and nurture',
        );
      } else if (cardName.contains('Emperor')) {
        archetypes.add('The Emperor - Authority, structure, and leadership');
        psychologicalThemes.add('Taking charge and creating order');
        personalityInsights.add(
          'You have strong leadership qualities and organizational skills',
        );
      }

      // Minor arcana personality insights
      if (cardName.contains('Ace')) {
        growthArchetypes.add('New beginnings and fresh starts');
      } else if (cardName.contains('Two')) {
        growthArchetypes.add('Partnerships and balance');
      } else if (cardName.contains('Three')) {
        growthArchetypes.add('Creativity and self-expression');
      } else if (cardName.contains('Four')) {
        growthArchetypes.add('Stability and foundation building');
      } else if (cardName.contains('Five')) {
        growthArchetypes.add('Change and adaptation');
      }
    }

    // Add psychological themes based on card combinations
    if (archetypes.length >= 2) {
      psychologicalThemes.add(
        'Multiple archetypes present - Complex personality integration',
      );
      personalityInsights.add(
        'You are working with multiple aspects of your personality',
      );
    }

    return {
      'archetypes': archetypes,
      'psychologicalThemes': psychologicalThemes,
      'personalityInsights': personalityInsights,
      'growthArchetypes': growthArchetypes,
      'archetypeCount': archetypes.length,
      'complexity': archetypes.length > 2 ? 'high' : 'moderate',
    };
  }

  /// [_generateComprehensiveSummary] - Generate comprehensive summary and key takeaways
  static Map<String, dynamic> _generateComprehensiveSummary(
    Map<String, dynamic> questionAnalysis,
    Map<String, dynamic> cardAnalysis,
    Map<String, dynamic> emotionalInsights,
    Map<String, dynamic> numerologicalInsights,
    Map<String, dynamic> astrologicalInsights,
    Map<String, dynamic> seasonalInsights,
    Map<String, dynamic> cardCombinations,
    Map<String, dynamic> shadowWorkInsights,
    Map<String, dynamic> archetypalInsights,
    AppLocalizations l10n,
  ) {
    final keyThemes = <String>[];
    final mainMessages = <String>[];
    final actionSteps = <String>[];
    final growthAreas = <String>[];
    final warnings = <String>[];
    final affirmations = <String>[];

    // Extract key themes from various analyses
    final category = questionAnalysis['primaryCategory'] as String;
    final emotionalTone = questionAnalysis['emotionalTone'] as String;
    final balance = (cardAnalysis['balance']
            as Map<String, dynamic>?)?['balance'] as String? ??
        'balanced';

    // Main theme based on category and balance
    keyThemes.add(
      '${_getCategoryDescription(category, l10n).toUpperCase()} - ${_getBalanceDescription(balance)}',
    );

    // Emotional themes
    if (emotionalInsights['patterns'] is List &&
        (emotionalInsights['patterns'] as List).isNotEmpty) {
      keyThemes.add(
        'Emotional Awareness - ${(emotionalInsights['patterns'] as List).first}',
      );
    }

    // Numerological themes
    final overallVibration =
        numerologicalInsights['overallVibration'] as String?;
    if (overallVibration?.isNotEmpty ?? false) {
      keyThemes.add(
        'Numerological Energy - $overallVibration',
      );
    }

    // Astrological themes
    if (astrologicalInsights['planetaryRulers'] is List &&
        (astrologicalInsights['planetaryRulers'] as List).isNotEmpty) {
      keyThemes.add(
        'Cosmic Influence - ${(astrologicalInsights['planetaryRulers'] as List).first}',
      );
    }

    // Seasonal themes
    final dominantElement = seasonalInsights['dominantElement'] as String?;
    if (dominantElement?.isNotEmpty ?? false) {
      keyThemes.add(
        'Elemental Energy - ${dominantElement!.toUpperCase()}',
      );
    }

    // Main messages based on overall analysis
    if (balance == 'positive') {
      mainMessages
        ..add('The energy is supportive and positive for your goals')
        ..add('Trust the process and take confident action');
    } else if (balance == 'negative') {
      mainMessages
        ..add('Challenges are present but offer growth opportunities')
        ..add('Focus on inner strength and resilience');
    } else {
      mainMessages
        ..add('Balance and harmony are key themes')
        ..add('Maintain equilibrium in all areas of life');
    }

    // Action steps based on insights
    if (shadowWorkInsights['healingPractices'] is List &&
        (shadowWorkInsights['healingPractices'] as List).isNotEmpty) {
      actionSteps.addAll(
        (shadowWorkInsights['healingPractices'] as List).take(3).cast<String>(),
      );
    }

    if (seasonalInsights['seasonalRecommendations'] is List &&
        (seasonalInsights['seasonalRecommendations'] as List).isNotEmpty) {
      actionSteps.addAll(
        (seasonalInsights['seasonalRecommendations'] as List)
            .take(2)
            .cast<String>(),
      );
    }

    // Growth areas
    if (archetypalInsights['growthArchetypes'] is List &&
        (archetypalInsights['growthArchetypes'] as List).isNotEmpty) {
      growthAreas.addAll(
        (archetypalInsights['growthArchetypes'] as List).cast<String>(),
      );
    }

    if (emotionalInsights['growthAreas'] is List &&
        (emotionalInsights['growthAreas'] as List).isNotEmpty) {
      growthAreas.addAll(
        (emotionalInsights['growthAreas'] as List).cast<String>(),
      );
    }

    // Warnings based on analysis
    if (emotionalTone == 'urgent') {
      warnings.add('Avoid making rushed decisions - take time to reflect');
    }

    if (shadowWorkInsights['intensity'] == 'intense' ||
        shadowWorkInsights['intensity'] == 'profound') {
      warnings.add(
        'This is a period of deep transformation - be gentle with yourself',
      );
    }

    // Affirmations based on positive aspects
    if (balance == 'positive') {
      affirmations
        ..add('I trust the positive energy flowing through my life')
        ..add('I am capable of achieving my goals');
    } else if (balance == 'negative') {
      affirmations
        ..add('I grow stronger through challenges')
        ..add('I trust my ability to overcome obstacles');
    } else {
      affirmations
        ..add('I maintain balance and harmony in all areas')
        ..add('I trust the natural flow of life');
    }

    // Add category-specific affirmations
    switch (category) {
      case 'love':
        affirmations.add('I am worthy of love and respect');
      case 'career':
        affirmations.add('I have the skills and abilities to succeed');
      case 'finance':
        affirmations.add('I attract abundance and prosperity');
      case 'health':
        affirmations.add('I prioritize my well-being and healing');
    }

    return {
      'keyThemes': keyThemes.take(5).toList(),
      'mainMessages': mainMessages.take(3).toList(),
      'actionSteps': actionSteps.take(5).toList(),
      'growthAreas': growthAreas.take(5).toList(),
      'warnings': warnings.take(3).toList(),
      'affirmations': affirmations.take(5).toList(),
      'overallTone': _getOverallTone(
        balance,
        emotionalTone,
        shadowWorkInsights,
      ),
      'priorityLevel': _getPriorityLevel(emotionalTone, shadowWorkInsights),
      'timeframe': _getSummaryTimeframe(cardAnalysis, seasonalInsights),
    };
  }

  /// [_getBalanceDescription] - Get description for balance status
  static String _getBalanceDescription(String balance) {
    switch (balance) {
      case 'positive':
        return 'Favorable Energy';
      case 'negative':
        return 'Challenging Energy';
      case 'balanced':
        return 'Harmonious Energy';
      default:
        return 'Neutral Energy';
    }
  }

  /// [_getOverallTone] - Get overall tone of the reading
  static String _getOverallTone(
    String balance,
    String emotionalTone,
    Map<String, dynamic> shadowWorkInsights,
  ) {
    if (shadowWorkInsights['intensity'] == 'profound') {
      return 'Transformative and intense';
    } else if (shadowWorkInsights['intensity'] == 'intense') {
      return 'Challenging but growth-oriented';
    } else if (balance == 'positive') {
      return 'Supportive and encouraging';
    } else if (balance == 'negative') {
      return 'Challenging but manageable';
    } else {
      return 'Balanced and harmonious';
    }
  }

  /// [_getPriorityLevel] - Get priority level for action
  static String _getPriorityLevel(
    String emotionalTone,
    Map<String, dynamic> shadowWorkInsights,
  ) {
    if (emotionalTone == 'urgent') {
      return 'High - Immediate attention needed';
    } else if (shadowWorkInsights['intensity'] == 'profound') {
      return 'High - Deep transformation in progress';
    } else if (shadowWorkInsights['intensity'] == 'intense') {
      return 'Medium-High - Significant growth opportunity';
    } else {
      return 'Medium - Steady progress and development';
    }
  }

  /// [_getSummaryTimeframe] - Get a general timeframe for the reading
  static String _getSummaryTimeframe(
    Map<String, dynamic> cardAnalysis,
    Map<String, dynamic> seasonalInsights,
  ) {
    final balance = (cardAnalysis['balance']
            as Map<String, dynamic>?)?['balance'] as String? ??
        'balanced';
    final dominantElement =
        seasonalInsights['dominantElement'] as String? ?? 'balanced';

    if (dominantElement == 'fire') {
      return 'Short-term (1-2 months) for immediate manifestation and action.';
    } else if (dominantElement == 'water') {
      return 'Medium-term (3-6 months) for emotional healing and deep transformation.';
    } else if (dominantElement == 'air') {
      return 'Long-term (6-12 months) for intellectual growth and strategic planning.';
    } else if (dominantElement == 'earth') {
      return 'Long-term (1-2 years) for stability and long-term goals.';
    } else if (balance == 'positive') {
      return 'Medium-term (3-6 months) for positive growth and progress.';
    } else if (balance == 'negative') {
      return 'Short-term (1-2 months) for overcoming challenges and resilience.';
    } else {
      return 'Medium-term (3-6 months) for steady progress and development.';
    }
  }
}

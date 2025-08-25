/// [TarotResponseEngine] - Intelligent Tarot Response and Interpretation Engine
/// Provides contextual, meaningful responses based on user questions and card combinations
/// Follows Apple Human Interface Guidelines for user experience and clean architecture principles
/// Production-ready implementation for reliable tarot readings

// ignore_for_file: avoid_dynamic_calls, document_ignores

library;

import 'package:flutter/foundation.dart' show kDebugMode;

/// [TarotResponseEngine] - Core engine for generating intelligent tarot responses
class TarotResponseEngine {
  /// [generateContextualReading] - Generate contextual reading based on question and cards
  /// Analyzes question intent, card meanings, and relationships to provide meaningful insights
  static Map<String, dynamic> generateContextualReading({
    required String question,
    required List<Map<String, dynamic>> selectedCards,
    required String readingType,
  }) {
    try {
      if (kDebugMode) {
        print('[TarotResponseEngine] Generating contextual reading...');
        print('  Question: $question');
        print('  Cards: ${selectedCards.length}');
        print('  Reading Type: $readingType');
      }

      // Analyze question intent and categorize
      final questionAnalysis = _analyzeQuestionIntent(question);

      // Analyze card relationships and patterns
      final cardAnalysis = _analyzeCardRelationships(selectedCards);

      // Generate contextual interpretation
      final contextualInterpretation = _generateContextualInterpretation(
        question,
        questionAnalysis,
        selectedCards,
        cardAnalysis,
        readingType,
      );

      // Generate actionable guidance
      final guidance = _generateActionableGuidance(
        questionAnalysis,
        cardAnalysis,
        selectedCards,
      );

      // Generate timing insights
      final timingInsights = _generateTimingInsights(
        selectedCards,
        questionAnalysis,
      );

      final response = {
        'question': question,
        'readingType': readingType,
        'questionAnalysis': questionAnalysis,
        'cardAnalysis': cardAnalysis,
        'contextualInterpretation': contextualInterpretation,
        'guidance': guidance,
        'timingInsights': timingInsights,
        'timestamp': DateTime.now().toIso8601String(),
      };

      if (kDebugMode) {
        print(
          '[TarotResponseEngine] Contextual reading generated successfully',
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
  ) {
    final category = questionAnalysis['primaryCategory'] as String;
    final questionType = questionAnalysis['questionType'] as String;
    final emotionalTone = questionAnalysis['emotionalTone'] as String;
    final balance =
        cardAnalysis['balance']?['balance'] as String? ?? 'balanced';

    final interpretation = StringBuffer()
      // Opening based on reading type
      ..writeln(_getReadingTypeOpening(readingType))
      ..writeln()
      // Question context
      ..writeln(
        'Your question about ${_getCategoryDescription(category)} reveals important insights.',
      )
      ..writeln();

    // Card-by-card interpretation with context
    for (var i = 0; i < cards.length; i++) {
      final card = cards[i];
      final position = i + 1;
      final isReversed = card['is_reversed'] == true;

      interpretation
        ..writeln('**Card $position: ${card['name']}**')
        ..writeln(isReversed ? 'Reversed' : 'Upright');

      final meaning = isReversed
          ? (card['reversed_meaning'] ?? 'No reversed meaning available')
          : (card['upright_meaning'] ?? 'No upright meaning available');

      interpretation.writeln('Meaning: $meaning');

      // Add contextual interpretation
      final contextualMeaning = _getContextualMeaning(
        card,
        category,
        questionType,
        position,
        readingType,
      );
      if (contextualMeaning.isNotEmpty) {
        interpretation.writeln('In your situation: $contextualMeaning');
      }

      interpretation.writeln();
    }

    // Overall message based on balance
    interpretation
      ..writeln('**Overall Message:**')
      ..writeln(
        _getOverallMessage(balance, category, emotionalTone),
      )
      ..writeln();

    // Timing insights
    if (questionType == 'timing' || questionType == 'decision') {
      interpretation
        ..writeln('**Timing:**')
        ..writeln(_getTimingMessage(cards, balance));
    }

    return interpretation.toString();
  }

  /// [_getReadingTypeOpening] - Get opening message based on reading type
  static String _getReadingTypeOpening(String readingType) {
    switch (readingType) {
      case 'single_card':
        return '**Single Card Reading** - A focused insight into your question';
      case 'three_card':
        return '**Three Card Reading** - Past, Present, and Future perspectives on your situation';
      case 'celtic_cross':
        return '**Celtic Cross Reading** - A comprehensive exploration of your question with deep insights';
      case 'horseshoe':
        return '**Horseshoe Reading** - Guidance on timing and progression of events';
      case 'daily_draw':
        return "**Daily Draw** - Today's guidance and reflection for your journey";
      default:
        return '**Tarot Reading** - Divine guidance and insight for your question';
    }
  }

  /// [_getCategoryDescription] - Get human-readable category description
  static String _getCategoryDescription(String category) {
    switch (category) {
      case 'love':
        return 'love and relationships';
      case 'career':
        return 'career and professional life';
      case 'finance':
        return 'financial matters and abundance';
      case 'health':
        return 'health and wellness';
      case 'spirituality':
        return 'spiritual growth and purpose';
      case 'family':
        return 'family and home life';
      case 'travel':
        return 'travel and new experiences';
      case 'decision':
        return 'important decisions and choices';
      case 'timing':
        return 'timing and life cycles';
      default:
        return 'your life path';
    }
  }

  /// [_getContextualMeaning] - Get contextual meaning for a card based on question
  static String _getContextualMeaning(
    Map<String, dynamic> card,
    String category,
    String questionType,
    int position,
    String readingType,
  ) {
    final cardName = card['name']?.toString() ?? '';
    final isReversed = card['is_reversed'] == true;

    // Position-based interpretation for multi-card readings
    if (readingType == 'three_card') {
      switch (position) {
        case 1:
          return _getPastContext(cardName, category, isReversed);
        case 2:
          return _getPresentContext(cardName, category, isReversed);
        case 3:
          return _getFutureContext(cardName, category, isReversed);
      }
    }

    // Category-based interpretation
    return _getCategoryContext(cardName, category, isReversed);
  }

  /// [_getPastContext] - Get past context for a card
  static String _getPastContext(
    String cardName,
    String category,
    bool isReversed,
  ) {
    if (cardName.contains('Death') || cardName.contains('Tower')) {
      return 'This represents a significant transformation or ending that has shaped your current situation.';
    } else if (cardName.contains('Fool') || cardName.contains('Magician')) {
      return 'This reflects a new beginning or skill development that started your journey.';
    }
    return 'This card represents past influences that are still affecting your current circumstances.';
  }

  /// [_getPresentContext] - Get present context for a card
  static String _getPresentContext(
    String cardName,
    String category,
    bool isReversed,
  ) {
    if (cardName.contains('High Priestess') || cardName.contains('Hermit')) {
      return 'You are currently in a period of introspection and inner wisdom. Trust your intuition.';
    } else if (cardName.contains('Chariot') || cardName.contains('Strength')) {
      return 'You are actively working towards your goals with determination and control.';
    }
    return 'This card represents your current situation and the energy you are working with.';
  }

  /// [_getFutureContext] - Get future context for a card
  static String _getFutureContext(
    String cardName,
    String category,
    bool isReversed,
  ) {
    if (cardName.contains('Sun') || cardName.contains('Star')) {
      return 'A bright and positive outcome awaits you if you continue on your current path.';
    } else if (cardName.contains('Moon') || cardName.contains('Devil')) {
      return 'Be aware of potential challenges or illusions that may arise.';
    }
    return 'This card shows the direction your path is taking and what you can expect.';
  }

  /// [_getCategoryContext] - Get category-specific context for a card
  static String _getCategoryContext(
    String cardName,
    String category,
    bool isReversed,
  ) {
    switch (category) {
      case 'love':
        if (cardName.contains('Lovers')) {
          return 'This represents a significant relationship decision or partnership opportunity.';
        } else if (cardName.contains('Two of Cups')) {
          return 'A new romantic connection or deepening of existing love is indicated.';
        }
      case 'career':
        if (cardName.contains('Magician')) {
          return 'You have the skills and resources to manifest your career goals.';
        } else if (cardName.contains('Chariot')) {
          return 'Your determination and focus will lead to career success.';
        }
      case 'finance':
        if (cardName.contains('Six of Pentacles')) {
          return 'Financial balance and generosity are key themes in your situation.';
        } else if (cardName.contains('Ten of Pentacles')) {
          return 'Long-term financial security and family wealth are indicated.';
        }
    }

    return "This card's energy is particularly relevant to your ${_getCategoryDescription(category)}.";
  }

  /// [_getOverallMessage] - Get overall message based on card balance and category
  static String _getOverallMessage(
    String balance,
    String category,
    String emotionalTone,
  ) {
    switch (balance) {
      case 'positive':
        return _getPositiveOverallMessage(category, emotionalTone);
      case 'negative':
        return _getNegativeOverallMessage(category, emotionalTone);
      default:
        return _getBalancedOverallMessage(category, emotionalTone);
    }
  }

  /// [_getPositiveOverallMessage] - Get positive overall message
  static String _getPositiveOverallMessage(
    String category,
    String emotionalTone,
  ) {
    switch (category) {
      case 'love':
        return 'The cards show positive energy in your love life. Trust the process and remain open to love.';
      case 'career':
        return 'Your career path is well-aligned with positive outcomes. Continue with confidence and determination.';
      case 'finance':
        return 'Financial abundance and prosperity are indicated. Your efforts will be rewarded.';
      default:
        return 'The overall energy is positive and supportive. Trust your path and embrace the opportunities ahead.';
    }
  }

  /// [_getNegativeOverallMessage] - Get negative overall message
  static String _getNegativeOverallMessage(
    String category,
    String emotionalTone,
  ) {
    switch (category) {
      case 'love':
        return 'The cards suggest challenges in relationships. This is a time for self-reflection and healing.';
      case 'career':
        return 'Career obstacles may arise, but these are opportunities for growth and learning.';
      case 'finance':
        return 'Financial challenges may be present, but they are temporary. Focus on stability and planning.';
      default:
        return 'While challenges are indicated, remember that difficulties often lead to growth and transformation.';
    }
  }

  /// [_getBalancedOverallMessage] - Get balanced overall message
  static String _getBalancedOverallMessage(
    String category,
    String emotionalTone,
  ) {
    switch (category) {
      case 'love':
        return 'Your love life shows balance between giving and receiving. Maintain harmony in relationships.';
      case 'career':
        return 'Your career path shows steady progress. Balance work with personal growth.';
      case 'finance':
        return 'Financial stability is indicated. Balance spending with saving for long-term security.';
      default:
        return 'The cards show a balanced energy. This is a time of stability and steady progress.';
    }
  }

  /// [_getTimingMessage] - Get timing insights from the cards
  static String _getTimingMessage(
    List<Map<String, dynamic>> cards,
    String balance,
  ) {
    if (cards.isEmpty) return 'Timing information is not available.';

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
      return 'The cards indicate that changes or answers will come soon. Stay alert and prepared.';
    } else if (timingKeywords.contains('patience')) {
      return 'Patience is required. The timing is not yet right, but trust the process.';
    } else if (timingKeywords.contains('long-term')) {
      return 'This is a long-term situation that will develop gradually. Focus on steady progress.';
    }

    // Default timing based on balance
    switch (balance) {
      case 'positive':
        return 'Positive outcomes are likely to manifest within the next few weeks to months.';
      case 'negative':
        return 'Challenges may arise soon, but they will pass. Focus on growth and learning.';
      default:
        return 'The timing suggests steady progress over the coming months.';
    }
  }

  static Map<String, dynamic> _generateActionableGuidance(
    Map<String, dynamic> questionAnalysis,
    Map<String, dynamic> cardAnalysis,
    List<Map<String, dynamic>> cards,
  ) {
    final category = questionAnalysis['primaryCategory'] as String;
    final emotionalTone = questionAnalysis['emotionalTone'] as String;
    final balance =
        cardAnalysis['balance']?['balance'] as String? ?? 'balanced';

    final guidance = <String>[];
    final affirmations = <String>[];
    final warnings = <String>[];

    // Generate guidance based on category and balance
    switch (category) {
      case 'love':
        if (balance == 'positive') {
          guidance
            ..add('Open your heart to new possibilities')
            ..add('Express your feelings authentically');
          affirmations.add('I am worthy of love and respect');
        } else if (balance == 'negative') {
          guidance
            ..add('Focus on self-love and healing')
            ..add('Communicate openly about concerns');
          warnings.add('Avoid rushing into new relationships');
        } else {
          guidance
            ..add('Maintain balance in giving and receiving')
            ..add('Practice patience in relationships');
        }

      case 'career':
        if (balance == 'positive') {
          guidance
            ..add('Take confident action towards your goals')
            ..add('Network and build professional relationships');
          affirmations.add('I have the skills to succeed');
        } else if (balance == 'negative') {
          guidance
            ..add('Address any skill gaps or obstacles')
            ..add('Seek mentorship or guidance');
          warnings.add('Avoid making hasty career decisions');
        } else {
          guidance
            ..add('Focus on steady, consistent progress')
            ..add('Balance work with personal development');
        }

      case 'finance':
        if (balance == 'positive') {
          guidance
            ..add('Invest in your future wisely')
            ..add('Share your abundance with others');
          affirmations.add('I attract financial prosperity');
        } else if (balance == 'negative') {
          guidance
            ..add('Create a budget and financial plan')
            ..add('Avoid unnecessary expenses');
          warnings.add('Be cautious with financial decisions');
        } else {
          guidance
            ..add('Maintain financial discipline')
            ..add('Build long-term financial security');
        }

      default:
        if (balance == 'positive') {
          guidance
            ..add('Embrace the positive energy around you')
            ..add('Take action on your goals');
          affirmations.add('I am capable and confident');
        } else if (balance == 'negative') {
          guidance
            ..add('Practice self-care and patience')
            ..add('Seek support when needed');
          warnings.add('Avoid making major decisions now');
        } else {
          guidance
            ..add('Maintain balance in all areas of life')
            ..add('Trust the natural flow of events');
        }
    }

    // Add general guidance based on emotional tone
    if (emotionalTone == 'urgent') {
      guidance.add('Take time to reflect before acting');
      warnings.add('Avoid making rushed decisions');
    } else if (emotionalTone == 'negative') {
      guidance.add('Practice gratitude and positive thinking');
      affirmations.add('I choose to see the good in every situation');
    }

    return {
      'actions': guidance,
      'affirmations': affirmations,
      'warnings': warnings,
      'focusAreas': _getFocusAreas(cards, category),
    };
  }

  /// [_getFocusAreas] - Get areas to focus on based on selected cards
  static List<String> _getFocusAreas(
    List<Map<String, dynamic>> cards,
    String category,
  ) {
    final focusAreas = <String>[];

    for (final card in cards) {
      final cardName = card['name']?.toString() ?? '';

      if (cardName.contains('High Priestess')) {
        focusAreas.add('Intuition and inner wisdom');
      } else if (cardName.contains('Hermit')) {
        focusAreas.add('Self-reflection and solitude');
      } else if (cardName.contains('Temperance')) {
        focusAreas.add('Balance and moderation');
      } else if (cardName.contains('Justice')) {
        focusAreas.add('Fairness and truth');
      } else if (cardName.contains('Strength')) {
        focusAreas.add('Inner strength and courage');
      }
    }

    // Add category-specific focus areas
    switch (category) {
      case 'love':
        focusAreas.add('Emotional communication');
        focusAreas.add('Self-love and boundaries');
      case 'career':
        focusAreas.add('Skill development');
        focusAreas.add('Professional networking');
      case 'finance':
        focusAreas.add('Financial planning');
        focusAreas.add('Responsible spending');
    }

    return focusAreas.take(5).toList(); // Limit to top 5 focus areas
  }

  static Map<String, dynamic> _generateTimingInsights(
    List<Map<String, dynamic>> cards,
    Map<String, dynamic> questionAnalysis,
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
        timingPatterns.add('Lunar cycles may influence timing');
      } else if (lowerMeaning.contains('seasons') ||
          lowerMeaning.contains('cycles')) {
        timingPatterns.add('Natural cycles are important');
      } else if (lowerMeaning.contains('patience') ||
          lowerMeaning.contains('wait')) {
        timingPatterns.add('Patience is required');
      }
    }

    // Generate timeframes based on category and question type
    switch (category) {
      case 'love':
        if (questionType == 'timing') {
          timeframes
            ..add('Within 1-3 months for new connections')
            ..add('6-12 months for deeper commitments');
        }
      case 'career':
        if (questionType == 'timing') {
          timeframes
            ..add('Within 3-6 months for career changes')
            ..add('1-2 years for major career growth');
        }
      case 'finance':
        if (questionType == 'timing') {
          timeframes
            ..add('Within 6-12 months for financial improvement')
            ..add('2-3 years for long-term financial goals');
        }
    }

    // Add general timing insights
    if (questionType == 'decision') {
      timeframes
        ..add('Take time to reflect before deciding')
        ..add('Trust your intuition in timing');
    }

    return {
      'patterns': timingPatterns,
      'timeframes': timeframes,
      'bestTimes': _getBestTimes(cards, category),
      'considerations': _getTimingConsiderations(cards),
    };
  }

  /// [_getBestTimes] - Get best times for action based on cards
  static List<String> _getBestTimes(
    List<Map<String, dynamic>> cards,
    String category,
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
        ..add('New moon for new beginnings')
        ..add('Full moon for completion and clarity');
    }

    if (hasSunCards) {
      bestTimes
        ..add('Daytime hours for positive actions')
        ..add('Sunny days for important decisions');
    }

    if (hasSeasonalCards) {
      bestTimes
        ..add('Spring for new projects and growth')
        ..add('Autumn for reflection and planning');
    }

    // Add category-specific timing
    switch (category) {
      case 'love':
        bestTimes.add('Friday evenings for romantic activities');
        bestTimes.add('Venus-ruled hours for relationship decisions');
      case 'career':
        bestTimes.add('Monday mornings for new initiatives');
        bestTimes.add('Mercury-ruled hours for communication');
      case 'finance':
        bestTimes.add('New moon for financial planning');
        bestTimes.add('Jupiter-ruled hours for abundance work');
    }

    return bestTimes;
  }

  /// [_getTimingConsiderations] - Get important timing considerations
  static List<String> _getTimingConsiderations(
    List<Map<String, dynamic>> cards,
  ) {
    final considerations = <String>[];

    // Check for specific timing cards
    for (final card in cards) {
      final cardName = card['name']?.toString() ?? '';

      if (cardName.contains('Hanged Man')) {
        considerations.add('Patience is required - timing is not yet right');
      } else if (cardName.contains('Wheel of Fortune')) {
        considerations.add('Change is constant - be flexible with timing');
      } else if (cardName.contains('Death')) {
        considerations.add('Endings create space for new beginnings');
      } else if (cardName.contains('Tower')) {
        considerations.add('Sudden changes may accelerate timing');
      }
    }

    // Add general considerations
    considerations
      ..add('Trust your intuition about timing')
      ..add('External factors may influence timing')
      ..add('Personal readiness is as important as external timing');

    return considerations;
  }
}

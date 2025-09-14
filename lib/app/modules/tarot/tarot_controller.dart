import 'dart:convert';
import 'dart:math';

import 'package:astro_iztro/core/engines/tarot_response_engine.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

/// [TarotController] - Controller for Tarot card readings and interpretations
/// Manages card selection, reading types, and provides card data and meanings
class TarotController extends GetxController {
  // Reactive state variables for tarot functionality
  final RxList<Map<String, dynamic>> selectedCards =
      <Map<String, dynamic>>[].obs;
  final RxString selectedReadingType = 'single_card'.obs;
  final RxBool isReadingInProgress = false.obs;
  final RxBool isCardReversed = false.obs;
  final RxString currentQuestion = ''.obs;
  final RxString readingInterpretation = ''.obs;

  // Enhanced reading data from TarotResponseEngine
  final RxMap<String, dynamic> enhancedReadingData = <String, dynamic>{}.obs;

  // Tarot card data
  final RxList<Map<String, dynamic>> allCards = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> majorArcana = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> minorArcana = <Map<String, dynamic>>[].obs;

  // Reading types available
  final List<String> readingTypes = [
    'single_card',
    'three_card',
    'celtic_cross',
    'horseshoe',
    'daily_draw',
  ];

  @override
  void onInit() {
    super.onInit();
    // [TarotController.onInit] - Loading tarot card data on initialization
    // Initialize with empty data first to prevent null access errors
    selectedCards.clear();
    selectedReadingType.value = 'single_card';
    isReadingInProgress.value = false;
    isCardReversed.value = false;
    currentQuestion.value = '';
    readingInterpretation.value = '';

    // Load tarot cards data
    _loadTarotCards();
  }

  /// [loadTarotCards] - Load tarot card data from JSON assets
  Future<void> _loadTarotCards() async {
    try {
      // Ensure lists are properly initialized
      majorArcana.clear();
      minorArcana.clear();
      allCards.clear();

      // Load tarot cards data from assets
      final jsonString = await rootBundle.loadString(
        'assets/tarot_cards.json',
      );
      // Decode the JSON string and ensure the result is a Map<String, dynamic>
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;

      // Extract major arcana cards safely as a List<dynamic>
      final majorArcanaData = jsonData['major_arcana'] as List<dynamic>? ?? [];
      for (final card in majorArcanaData) {
        if (card is Map<String, dynamic>) {
          majorArcana.add(Map<String, dynamic>.from(card));
        }
      }

      // Extract minor arcana cards
      final minorArcanaData =
          jsonData['minor_arcana'] as Map<String, dynamic>? ??
              <String, dynamic>{};
      final allMinorCards = <Map<String, dynamic>>[];

      // Combine all minor arcana suits
      for (final entry in minorArcanaData.entries) {
        final cards = entry.value;
        if (cards is List) {
          for (final card in cards) {
            if (card is Map<String, dynamic>) {
              allMinorCards.add(Map<String, dynamic>.from(card));
            }
          }
        }
      }
      minorArcana.assignAll(allMinorCards);

      // Combine all cards for general use
      allCards.assignAll([...majorArcana, ...minorArcana]);

      if (kDebugMode) {
        print(
          '[TarotController] Loaded ${allCards.length} tarot cards successfully',
        );
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[TarotController] Error loading tarot cards: $e');
      }
      Get.snackbar(
        AppLocalizations.of(Get.context!)!.errorLoadingTarotCards,
        AppLocalizations.of(Get.context!)!.failedToLoadTarotCards(e.toString()),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// [setReadingType] - Set the type of tarot reading to perform
  void setReadingType(String readingType) {
    if (readingTypes.contains(readingType)) {
      selectedReadingType.value = readingType;
      // Clear previous reading when changing type
      _clearCurrentReading();
      if (kDebugMode) {
        print('[TarotController] Reading type set to: $readingType');
      }
    }
  }

  /// [setQuestion] - Set the question for the tarot reading
  void setQuestion(String question) {
    currentQuestion.value = question.trim();
    if (kDebugMode) {
      print('[TarotController] Question set: $question');
    }
  }

  /// [performReading] - Perform the selected type of tarot reading
  Future<void> performReading() async {
    if (currentQuestion.value.isEmpty) {
      Get.snackbar(
        AppLocalizations.of(Get.context!)!.questionRequired,
        AppLocalizations.of(Get.context!)!.pleaseEnterQuestionForReading,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isReadingInProgress.value = true;

      // Clear previous reading
      _clearCurrentReading();

      // Select cards based on reading type
      await _selectCardsForReading();

      // Generate interpretation
      await _generateReadingInterpretation();

      if (kDebugMode) {
        print('[TarotController] Reading completed successfully');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[TarotController] Error performing reading: $e');
      }
      Get.snackbar(
        AppLocalizations.of(Get.context!)!.readingError,
        AppLocalizations.of(Get.context!)!
            .failedToCompleteReading(e.toString()),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isReadingInProgress.value = false;
    }
  }

  /// [selectCardsForReading] - Select appropriate number of cards for the reading type
  Future<void> _selectCardsForReading() async {
    final random = Random();
    final numberOfCards = _getNumberOfCardsForReadingType();

    // Create a copy of all cards to avoid modifying the original list
    final availableCards = List<Map<String, dynamic>>.from(allCards);
    final selected = <Map<String, dynamic>>[];

    for (var i = 0; i < numberOfCards && availableCards.isNotEmpty; i++) {
      // Randomly select a card
      final randomIndex = random.nextInt(availableCards.length);
      final selectedCard = availableCards.removeAt(
        randomIndex,
      );

      // Determine if card is reversed (50% chance)
      final isReversed = random.nextBool();

      // Add card with orientation information
      selected.add({
        ...selectedCard,
        'is_reversed': isReversed,
        'position': i + 1,
      });
    }

    selectedCards.assignAll(selected);
    if (kDebugMode) {
      print(
        '[TarotController] Selected ${selectedCards.length} cards for reading',
      );
    }
  }

  /// [getNumberOfCardsForReadingType] - Get the number of cards needed for the reading type
  int _getNumberOfCardsForReadingType() {
    switch (selectedReadingType.value) {
      case 'single_card':
        return 1;
      case 'three_card':
        return 3;
      case 'celtic_cross':
        return 10;
      case 'horseshoe':
        return 7;
      case 'daily_draw':
        return 1;
      default:
        return 1;
    }
  }

  /// [generateReadingInterpretation] - Generate interpretation for the selected cards
  Future<void> _generateReadingInterpretation() async {
    if (selectedCards.isEmpty) return;

    try {
      // Use the new TarotResponseEngine to generate contextual reading
      final response = TarotResponseEngine.generateContextualReading(
        question: currentQuestion.value,
        selectedCards: selectedCards,
        readingType: selectedReadingType.value,
        l10n: AppLocalizations.of(Get.context!)!,
      );

      // Store the enhanced reading data for the enhanced widget
      enhancedReadingData.assignAll({
        ...response,
        'selectedCards':
            selectedCards.toList(), // Explicitly add selected cards
      });

      // Generate the interpretation using the response engine
      final interpretation = StringBuffer()
        // Add the contextual interpretation from the engine
        ..writeln(response['contextualInterpretation'] as String)
        ..writeln();

      final l10n = AppLocalizations.of(Get.context!)!;

      // Add actionable guidance section
      final guidance = response['guidance'] as Map<String, dynamic>?;
      final actions = guidance?['actions'] as List<dynamic>?;
      if (actions?.isNotEmpty ?? false) {
        interpretation.writeln(l10n.actionableGuidance);
        for (final action in actions!) {
          interpretation.writeln('• $action');
        }
        interpretation.writeln();
      }

      // Add affirmations section
      final affirmations = guidance?['affirmations'] as List<dynamic>?;
      if (affirmations?.isNotEmpty ?? false) {
        interpretation.writeln(l10n.affirmations);
        for (final affirmation in affirmations!) {
          interpretation.writeln('• $affirmation');
        }
        interpretation.writeln();
      }

      // Add warnings section
      final warnings = guidance?['warnings'] as List<dynamic>?;
      if (warnings?.isNotEmpty ?? false) {
        interpretation.writeln(l10n.considerations);
        for (final warning in warnings!) {
          interpretation.writeln('• $warning');
        }
        interpretation.writeln();
      }

      // Add focus areas section
      final focusAreas = guidance?['focusAreas'] as List<dynamic>?;
      if (focusAreas?.isNotEmpty ?? false) {
        interpretation.writeln(l10n.focusAreas);
        for (final focusArea in focusAreas!) {
          interpretation.writeln('• $focusArea');
        }
        interpretation.writeln();
      }

      // Add timing insights section
      final timingInsights =
          response['timingInsights'] as Map<String, dynamic>?;
      final timeframes = timingInsights?['timeframes'] as List<dynamic>?;
      if (timeframes?.isNotEmpty ?? false) {
        interpretation.writeln(l10n.timingInsights);
        for (final timeframe in timeframes!) {
          interpretation.writeln('• $timeframe');
        }
        interpretation.writeln();
      }

      final bestTimes = timingInsights?['bestTimes'] as List<dynamic>?;
      if (bestTimes?.isNotEmpty ?? false) {
        interpretation.writeln(l10n.bestTimesForAction);
        for (final bestTime in bestTimes!) {
          interpretation.writeln('• $bestTime');
        }
        interpretation.writeln();
      }

      readingInterpretation.value = interpretation.toString();

      if (kDebugMode) {
        print(
          '[TarotController] Enhanced reading interpretation generated using TarotResponseEngine',
        );
        print(
          '[TarotController] Question analysis: ${response['questionAnalysis']}',
        );
        print('[TarotController] Card analysis: ${response['cardAnalysis']}');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[TarotController] Error generating enhanced reading: $e');
      }
      // Fallback to basic interpretation if engine fails
      _generateBasicInterpretation();
    }
  }

  /// [_generateBasicInterpretation] - Fallback basic interpretation method
  void _generateBasicInterpretation() {
    final l10n = AppLocalizations.of(Get.context!)!;
    final interpretation = StringBuffer()
      // Add reading type description
      ..writeln(_getReadingTypeDescription())
      ..writeln()
      // Add question
      ..writeln(l10n.questionLabel(currentQuestion.value))
      ..writeln();

    // Add card interpretations
    for (final card in selectedCards) {
      // Safely extract card name, ensuring it's a String
      final cardName =
          card['name'] is String ? card['name'] as String : l10n.unknownCard;

      // Safely extract isReversed, ensuring it's a bool
      final isReversed =
          card['is_reversed'] is bool && card['is_reversed'] as bool;

      // Safely extract position, ensuring it's an int
      final position = card['position'] is int ? card['position'] as int : 1;

      final orientation = isReversed ? l10n.reversed : l10n.upright;

      interpretation
        ..writeln(l10n.cardPositionLabel(position, cardName))
        ..writeln(l10n.orientationLabel(orientation));

      if (isReversed) {
        interpretation.writeln(
          l10n.meaningLabel(
            (card['reversed_meaning'] as String?) ??
                l10n.noReversedMeaningAvailable,
          ),
        );
      } else {
        interpretation.writeln(
          l10n.meaningLabel(
            (card['upright_meaning'] as String?) ??
                l10n.noUprightMeaningAvailable,
          ),
        );
      }

      interpretation
        ..writeln(
          l10n.descriptionLabel(
            (card['description'] as String?) ?? l10n.noDescriptionAvailable,
          ),
        )
        ..writeln();
    }

    // Add overall interpretation
    interpretation
      ..writeln(l10n.overallInterpretation)
      ..writeln(_generateOverallInterpretation());

    readingInterpretation.value = interpretation.toString();
  }

  /// [getReadingTypeDescription] - Get description for the selected reading type
  String _getReadingTypeDescription() {
    final l10n = AppLocalizations.of(Get.context!)!;
    switch (selectedReadingType.value) {
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

  /// [generateOverallInterpretation] - Generate overall interpretation based on selected cards
  String _generateOverallInterpretation() {
    if (selectedCards.isEmpty) return 'No cards selected for interpretation.';

    // Count upright vs reversed cards
    var uprightCount = 0;
    var reversedCount = 0;

    for (final card in selectedCards) {
      if (card['is_reversed'] == true) {
        reversedCount++;
      } else {
        uprightCount++;
      }
    }

    // Generate interpretation based on card orientations
    if (reversedCount > uprightCount) {
      return 'The predominance of reversed cards suggests internal challenges and the need for introspection. Consider what aspects of your life need attention and transformation.';
    } else if (uprightCount > reversedCount) {
      return 'The predominance of upright cards indicates positive energy and clear direction. You are on the right path, and your intentions are well-aligned.';
    } else {
      return 'The balance of upright and reversed cards suggests a period of transition and growth. Embrace change while maintaining your core values and intentions.';
    }
  }

  /// [clearCurrentReading] - Clear the current reading and reset state
  void _clearCurrentReading() {
    selectedCards.clear();
    readingInterpretation.value = '';
    enhancedReadingData.clear();
    if (kDebugMode) {
      print('[TarotController] Current reading cleared');
    }
  }

  /// [clearReading] - Public method to clear the current reading
  void clearReading() {
    _clearCurrentReading();
    currentQuestion.value = '';
    if (kDebugMode) {
      print('[TarotController] Reading cleared by user');
    }
  }

  /// [getCardImage] - Get the image asset path for a card
  String getCardImage(String cardName) {
    // Convert card name to image asset path
    final imageName =
        cardName.toLowerCase().replaceAll(' ', '_').replaceAll('the_', '');
    return 'assets/images/tarot/$imageName.png';
  }

  /// [getCardKeywords] - Get keywords for a specific card
  List<String> getCardKeywords(String cardName) {
    final card = allCards.firstWhereOrNull(
      (card) => card['name'] == cardName,
    );

    if (card != null && card['keywords'] != null) {
      // Ensure 'keywords' is an Iterable before converting to List<String>
      final keywords = card['keywords'];
      if (keywords is Iterable) {
        return List<String>.from(keywords);
      }
    }

    return [];
  }

  /// [getRandomCard] - Get a random card for daily draws or inspiration
  Map<String, dynamic>? getRandomCard() {
    if (allCards.isEmpty) return null;

    final random = Random();
    final randomIndex = random.nextInt(allCards.length);
    final card = allCards[randomIndex];

    // Determine if card is reversed
    final isReversed = random.nextBool();

    return {
      ...card,
      'is_reversed': isReversed,
    };
  }

  /// [toggleCardSelection] - Toggle card selection for manual card picking
  /// Allows users to manually select specific cards for their reading
  void toggleCardSelection(Map<String, dynamic> card) {
    final existingIndex = selectedCards.indexWhere(
      (selectedCard) => selectedCard['id'] == card['id'],
    );

    if (existingIndex >= 0) {
      // Remove card if already selected
      selectedCards.removeAt(existingIndex);
      if (kDebugMode) {
        print('[TarotController] Card removed: ${card['name']}');
      }
    } else {
      // Add card if not selected
      final cardWithPosition = {
        ...card,
        'position': selectedCards.length + 1,
        'is_reversed': Random().nextBool(), // Random orientation
      };
      selectedCards.add(cardWithPosition);
      if (kDebugMode) {
        print('[TarotController] Card added: ${card['name']}');
      }
    }
  }

  // Card section expansion state management
  final RxMap<String, bool> _expandedSections = <String, bool>{}.obs;

  /// [isCardSectionExpanded] - Check if a card section is expanded
  bool isCardSectionExpanded(String sectionTitle) {
    return _expandedSections[sectionTitle] ?? false;
  }

  /// [toggleCardSectionExpansion] - Toggle expansion state of a card section
  void toggleCardSectionExpansion(String sectionTitle) {
    _expandedSections[sectionTitle] =
        !(_expandedSections[sectionTitle] ?? false);
    if (kDebugMode) {
      print(
        '[TarotController] Section $sectionTitle expansion toggled to ${_expandedSections[sectionTitle]}',
      );
    }
  }

  /// [getCardsBySuit] - Get all cards of a specific suit
  List<Map<String, dynamic>> getCardsBySuit(String suit) {
    if (suit.toLowerCase() == 'major arcana') {
      return List.from(majorArcana);
    } else {
      return List.from(
        minorArcana.where(
          (card) =>
              card['suit']?.toString().toLowerCase() == suit.toLowerCase(),
        ),
      );
    }
  }

  /// Getters for computed values
  bool get hasSelectedCards => selectedCards.isNotEmpty;
  bool get hasEnhancedReadingData => enhancedReadingData.isNotEmpty;
  int get totalCardsLoaded => allCards.length;
  int get majorArcanaCount => majorArcana.length;
  int get minorArcanaCount => minorArcana.length;
}

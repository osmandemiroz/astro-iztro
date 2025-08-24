import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
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
    _loadTarotCards();
  }

  /// [loadTarotCards] - Load tarot card data from JSON assets
  Future<void> _loadTarotCards() async {
    try {
      // Load tarot cards data from assets
      final String jsonString = await rootBundle.loadString(
        'assets/tarot_cards.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Extract major arcana cards
      final List<dynamic> majorArcanaData = jsonData['major_arcana'] ?? [];
      for (final card in majorArcanaData) {
        if (card is Map<String, dynamic>) {
          majorArcana.add(Map<String, dynamic>.from(card));
        }
      }

      // Extract minor arcana cards
      final Map<String, dynamic> minorArcanaData =
          jsonData['minor_arcana'] ?? {};
      final List<Map<String, dynamic>> allMinorCards = [];

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

      print(
        '[TarotController] Loaded ${allCards.length} tarot cards successfully',
      );
    } catch (e) {
      print('[TarotController] Error loading tarot cards: $e');
      Get.snackbar(
        'Error',
        'Failed to load tarot cards: $e',
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
      print('[TarotController] Reading type set to: $readingType');
    }
  }

  /// [setQuestion] - Set the question for the tarot reading
  void setQuestion(String question) {
    currentQuestion.value = question.trim();
    print('[TarotController] Question set: $question');
  }

  /// [performReading] - Perform the selected type of tarot reading
  Future<void> performReading() async {
    if (currentQuestion.value.isEmpty) {
      Get.snackbar(
        'Question Required',
        'Please enter a question for your reading',
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

      print('[TarotController] Reading completed successfully');
    } catch (e) {
      print('[TarotController] Error performing reading: $e');
      Get.snackbar(
        'Reading Error',
        'Failed to complete reading: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isReadingInProgress.value = false;
    }
  }

  /// [selectCardsForReading] - Select appropriate number of cards for the reading type
  Future<void> _selectCardsForReading() async {
    final random = Random();
    final int numberOfCards = _getNumberOfCardsForReadingType();

    // Create a copy of all cards to avoid modifying the original list
    final List<Map<String, dynamic>> availableCards = List.from(allCards);
    final List<Map<String, dynamic>> selected = [];

    for (int i = 0; i < numberOfCards && availableCards.isNotEmpty; i++) {
      // Randomly select a card
      final int randomIndex = random.nextInt(availableCards.length);
      final Map<String, dynamic> selectedCard = availableCards.removeAt(
        randomIndex,
      );

      // Determine if card is reversed (50% chance)
      final bool isReversed = random.nextBool();

      // Add card with orientation information
      selected.add({
        ...selectedCard,
        'is_reversed': isReversed,
        'position': i + 1,
      });
    }

    selectedCards.assignAll(selected);
    print(
      '[TarotController] Selected ${selectedCards.length} cards for reading',
    );
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

    final StringBuffer interpretation = StringBuffer();

    // Add reading type description
    interpretation.writeln(_getReadingTypeDescription());
    interpretation.writeln();

    // Add question
    interpretation.writeln('Question: ${currentQuestion.value}');
    interpretation.writeln();

    // Add card interpretations
    for (final Map<String, dynamic> card in selectedCards) {
      final String cardName = card['name'] ?? 'Unknown Card';
      final bool isReversed = card['is_reversed'] ?? false;
      final int position = card['position'] ?? 1;

      interpretation.writeln('Card $position: $cardName');
      interpretation.writeln(
        'Orientation: ${isReversed ? 'Reversed' : 'Upright'}',
      );

      if (isReversed) {
        interpretation.writeln(
          'Meaning: ${card['reversed_meaning'] ?? 'No reversed meaning available'}',
        );
      } else {
        interpretation.writeln(
          'Meaning: ${card['upright_meaning'] ?? 'No upright meaning available'}',
        );
      }

      interpretation.writeln(
        'Description: ${card['description'] ?? 'No description available'}',
      );
      interpretation.writeln();
    }

    // Add overall interpretation
    interpretation.writeln('Overall Interpretation:');
    interpretation.writeln(_generateOverallInterpretation());

    readingInterpretation.value = interpretation.toString();
  }

  /// [getReadingTypeDescription] - Get description for the selected reading type
  String _getReadingTypeDescription() {
    switch (selectedReadingType.value) {
      case 'single_card':
        return 'Single Card Reading - A focused insight into your question';
      case 'three_card':
        return 'Three Card Reading - Past, Present, and Future perspectives';
      case 'celtic_cross':
        return 'Celtic Cross Reading - Comprehensive insight into complex situations';
      case 'horseshoe':
        return 'Horseshoe Reading - Guidance on timing and progression of events';
      case 'daily_draw':
        return 'Daily Draw - Daily guidance and reflection';
      default:
        return 'Tarot Reading - Divine guidance and insight';
    }
  }

  /// [generateOverallInterpretation] - Generate overall interpretation based on selected cards
  String _generateOverallInterpretation() {
    if (selectedCards.isEmpty) return 'No cards selected for interpretation.';

    // Count upright vs reversed cards
    int uprightCount = 0;
    int reversedCount = 0;

    for (final Map<String, dynamic> card in selectedCards) {
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
    print('[TarotController] Current reading cleared');
  }

  /// [clearReading] - Public method to clear the current reading
  void clearReading() {
    _clearCurrentReading();
    currentQuestion.value = '';
    print('[TarotController] Reading cleared by user');
  }

  /// [getCardImage] - Get the image asset path for a card
  String getCardImage(String cardName) {
    // Convert card name to image asset path
    final String imageName = cardName
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('the_', '');
    return 'assets/images/tarot/$imageName.png';
  }

  /// [getCardKeywords] - Get keywords for a specific card
  List<String> getCardKeywords(String cardName) {
    final Map<String, dynamic>? card = allCards.firstWhereOrNull(
      (card) => card['name'] == cardName,
    );

    if (card != null && card['keywords'] != null) {
      return List<String>.from(card['keywords']);
    }

    return [];
  }

  /// [getRandomCard] - Get a random card for daily draws or inspiration
  Map<String, dynamic>? getRandomCard() {
    if (allCards.isEmpty) return null;

    final random = Random();
    final int randomIndex = random.nextInt(allCards.length);
    final Map<String, dynamic> card = allCards[randomIndex];

    // Determine if card is reversed
    final bool isReversed = random.nextBool();

    return {
      ...card,
      'is_reversed': isReversed,
    };
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
  bool get hasQuestion => currentQuestion.value.isNotEmpty;
  bool get hasInterpretation => readingInterpretation.value.isNotEmpty;
  int get totalCardsLoaded => allCards.length;
  int get majorArcanaCount => majorArcana.length;
  int get minorArcanaCount => minorArcana.length;
}

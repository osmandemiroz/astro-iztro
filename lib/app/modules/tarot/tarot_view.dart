import 'package:astro_iztro/app/modules/tarot/tarot_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/core/utils/iz_animated_widgets.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:astro_iztro/shared/widgets/background_image_widget.dart';
import 'package:astro_iztro/shared/widgets/enhanced_tarot_reading_widget.dart';
import 'package:astro_iztro/shared/widgets/liquid_glass_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// [TarotView] - Tarot card reading interface with Apple-inspired design
/// Features modern UI with liquid glass effects, smooth animations, and intuitive navigation
/// Follows Apple's Human Interface Guidelines for sleek, minimal, and engaging user experience
class TarotView extends GetView<TarotController> {
  const TarotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Modern dark theme background with mystical gradient
      body: HomeBackground(
        child: SafeArea(
          child: _buildBody(),
        ),
      ),
    );
  }

  /// [buildBody] - Main body content with tarot reading interface
  Widget _buildBody() {
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        _buildMainContent(),
      ],
    );
  }

  /// [buildAppBar] - Custom app bar with tarot theme
  /// Edge-to-edge design with mystical elements and proper spacing
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 180, // Increased height to accommodate more top spacing
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      stretch: true, // Apple-style stretch effect
      // Remove the title from here to avoid duplication
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.darkSpaceGradient,
          ),
          child: _buildHeaderContent(),
        ),
      ),
    );
  }

  /// [buildHeaderContent] - Header with mystical elements and description
  /// Clean, user-friendly design with single, prominent title
  Widget _buildHeaderContent() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            MainAxisAlignment.center, // Center the title vertically
        children: [
          const SizedBox(
            height: AppConstants.largePadding * 2,
          ), // Much more top spacing for better breathing room
          // Main title with clean, centered positioning and better readability
          IzSlideFadeIn(
            offset: const Offset(0, 20),
            duration: const Duration(milliseconds: 800),
            child: Text(
              'TAROT READING',
              style: AppTheme.headingLarge.copyWith(
                color: AppColors.darkTextPrimary,
                fontFamily: AppConstants.decorativeFont,
                fontWeight:
                    FontWeight.w400, // Slightly bolder for better readability
                letterSpacing:
                    4, // Increased letter spacing for elegance and clarity
                fontSize: 36, // Larger font size for better visibility
              ),
            ),
          ),
          const SizedBox(height: 12), // Space between title and subtitle
          // Subtle subtitle for better user guidance
          TweenAnimationBuilder<double>(
            duration: const Duration(
              milliseconds: 1000,
            ), // Slightly delayed animation
            tween: Tween(begin: 0, end: 1),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 15 * (1 - value)),
                  child: Text(
                    'Discover your path through mystical wisdom',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppColors.darkTextSecondary,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppConstants.defaultPadding), // Bottom spacing
        ],
      ),
    );
  }

  /// [buildMainContent] - Main scrollable content with tarot features
  Widget _buildMainContent() {
    return SliverToBoxAdapter(
      child: IzSlideFadeIn(
        offset: const Offset(0, 30),
        duration: const Duration(milliseconds: 600),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppConstants.borderRadius * 2),
              topRight: Radius.circular(AppConstants.borderRadius * 2),
            ),
            // Add subtle shadow for better visual separation
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: AppConstants.largePadding,
                ), // Increased top spacing for better separation
                // Animate reading type selector with staggered effect
                IzSlideFadeIn(
                  delay: const Duration(milliseconds: 200),
                  child: _buildReadingTypeSelector(),
                ),
                const SizedBox(height: AppConstants.largePadding),
                // Animate card selection interface
                IzSlideFadeIn(
                  delay: const Duration(milliseconds: 300),
                  child: _buildCardSelectionInterface(),
                ),
                const SizedBox(height: AppConstants.largePadding),
                // Animate question input
                IzSlideFadeIn(
                  delay: const Duration(milliseconds: 400),
                  child: _buildQuestionInput(),
                ),
                const SizedBox(height: AppConstants.largePadding),
                // Animate reading button
                IzSlideFadeIn(
                  delay: const Duration(milliseconds: 500),
                  child: _buildReadingButton(),
                ),
                const SizedBox(height: AppConstants.largePadding),
                // Animate selected cards
                IzSlideFadeIn(
                  delay: const Duration(milliseconds: 600),
                  child: _buildSelectedCards(),
                ),
                const SizedBox(height: AppConstants.largePadding),
                // Animate reading interpretation
                IzSlideFadeIn(
                  delay: const Duration(milliseconds: 700),
                  child: _buildReadingInterpretation(),
                ),
                const SizedBox(
                  height: AppConstants.defaultPadding,
                ), // Bottom spacing
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// [buildReadingTypeSelector] - Reading type selection with beautiful cards
  Widget _buildReadingTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Reading Type',
          style: AppTheme.headingSmall.copyWith(
            color: AppColors.darkTextPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppConstants.defaultPadding,
            mainAxisSpacing: AppConstants.defaultPadding,
            childAspectRatio: 1.2,
          ),
          itemCount: controller.readingTypes.length,
          itemBuilder: (context, index) {
            final readingType = controller.readingTypes[index];
            return Obx(() {
              final isSelected =
                  controller.selectedReadingType.value == readingType;
              return IzSlideFadeIn(
                offset: const Offset(0, 20),
                delay: Duration(milliseconds: 100 + (index * 50)),
                child: _buildReadingTypeCard(readingType, isSelected),
              );
            });
          },
        ),
        const SizedBox(
          height: AppConstants.smallPadding,
        ), // Additional bottom spacing
      ],
    );
  }

  /// [buildReadingTypeCard] - Individual reading type card with selection state
  Widget _buildReadingTypeCard(String readingType, bool isSelected) {
    final readingTypeInfo = <String, Map<String, dynamic>>{
      'single_card': {
        'title': 'Single Card',
        'subtitle': 'Quick insight',
        'icon': Icons.style,
        'color': AppColors.lightPurple,
      },
      'three_card': {
        'title': 'Three Card',
        'subtitle': 'Past, Present, Future',
        'icon': Icons.view_column,
        'color': AppColors.lightGold,
      },
      'celtic_cross': {
        'title': 'Celtic Cross',
        'subtitle': 'Comprehensive reading',
        'icon': Icons.grid_4x4,
        'color': AppColors.lightPurple,
      },
      'horseshoe': {
        'title': 'Horseshoe',
        'subtitle': 'Timing & progression',
        'icon': Icons.timeline,
        'color': AppColors.lightGold,
      },
      'daily_draw': {
        'title': 'Daily Draw',
        'subtitle': 'Daily guidance',
        'icon': Icons.wb_sunny,
        'color': AppColors.lightPurple,
      },
    };

    final info =
        readingTypeInfo[readingType] ??
        {
          'title': readingType.replaceAll('_', ' ').toUpperCase(),
          'subtitle': 'Tarot reading',
          'icon': Icons.auto_awesome,
          'color': AppColors.lightPurple,
        };

    return IzTapScale(
      onTap: () => controller.setReadingType(readingType),
      child: LiquidGlassCard(
        onTap: () => controller.setReadingType(readingType),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? (info['color'] as Color) : Colors.transparent,
              width: isSelected ? 2 : 0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                info['icon'] as IconData,
                size: 32,
                color: isSelected
                    ? (info['color'] as Color)
                    : AppColors.darkTextTertiary,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                info['title'] as String,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? (info['color'] as Color)
                      : AppColors.darkTextPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                info['subtitle'] as String,
                style: AppTheme.caption.copyWith(
                  color: isSelected
                      ? (info['color'] as Color)
                      : AppColors.darkTextPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// [buildCardSelectionInterface] - Beautiful card selection interface
  /// Shows available cards with mystical styling and selection states
  Widget _buildCardSelectionInterface() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Available Cards',
              style: AppTheme.headingSmall.copyWith(
                color: AppColors.darkTextPrimary,
              ),
            ),
            Obx(
              () => Text(
                '${controller.selectedCards.length} selected',
                style: AppTheme.caption.copyWith(
                  color: AppColors.lightPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.defaultPadding),

        // Major Arcana section
        _buildCardSection('Major Arcana', controller.majorArcana),
        const SizedBox(height: AppConstants.defaultPadding),

        // Minor Arcana section
        _buildCardSection('Minor Arcana', controller.minorArcana),
      ],
    );
  }

  /// [buildCardSection] - Build a section of cards using responsive grid layout
  /// Prevents overflow and provides better space utilization
  Widget _buildCardSection(String title, RxList<Map<String, dynamic>> cards) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),

        // Responsive grid layout that adapts to screen width
        LayoutBuilder(
          builder: (context, constraints) {
            // Calculate optimal grid layout based on available width
            final availableWidth = constraints.maxWidth;
            const cardWidth = 70.0; // Smaller card width
            const cardHeight = 90.0; // Smaller card height
            const spacing = AppConstants.smallPadding;

            // Calculate how many cards can fit in a row
            final crossAxisCount =
                ((availableWidth + spacing) / (cardWidth + spacing)).floor();
            final effectiveCrossAxisCount = crossAxisCount > 0
                ? crossAxisCount
                : 1;

            // Show only first 12 cards initially to prevent overflow
            final initialCardCount =
                effectiveCrossAxisCount * 2; // Show 2 rows initially
            final shouldShowMore = cards.length > initialCardCount;

            return Column(
              children: [
                // Wrap only the GridView with Obx to make it reactive to expansion state
                Obx(() {
                  final isExpanded = controller.isCardSectionExpanded(title);
                  final itemCount = isExpanded
                      ? cards.length
                      : initialCardCount;

                  // Debug logging
                  if (kDebugMode) {
                    print('[TarotView] Section: $title');
                    print('[TarotView] Total cards: ${cards.length}');
                    print(
                      '[TarotView] Cards per row: $effectiveCrossAxisCount',
                    );
                    print('[TarotView] Initial count: $initialCardCount');
                    print('[TarotView] Should show more: $shouldShowMore');
                    print('[TarotView] Is expanded: $isExpanded');
                    print('[TarotView] Item count: $itemCount');
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: effectiveCrossAxisCount,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                      childAspectRatio: cardWidth / cardHeight,
                    ),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return IzSlideFadeIn(
                        delay: Duration(milliseconds: 200 + (index * 30)),
                        child: _buildSelectableCard(
                          card,
                          controller.selectedCards.any(
                            (selectedCard) => selectedCard['id'] == card['id'],
                          ),
                          cardWidth,
                          cardHeight,
                        ),
                      );
                    },
                  );
                }),

                // Show more/less button if there are more cards
                if (shouldShowMore)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: AppConstants.smallPadding,
                    ),
                    child: _buildExpandableCardsButton(
                      title,
                      cards,
                      effectiveCrossAxisCount,
                      cardWidth,
                      cardHeight,
                      spacing,
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// [buildSelectableCard] - Individual selectable card with beautiful styling
  /// Supports dynamic sizing for responsive grid layout
  Widget _buildSelectableCard(
    Map<String, dynamic> card,
    bool isSelected,
    double width,
    double height,
  ) {
    final cardName = (card['name'] as String?) ?? 'Unknown Card';

    return GestureDetector(
      onTap: () => controller.toggleCardSelection(card),
      child: SizedBox(
        width: width,
        child: Column(
          children: [
            // Card image with selection state
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? AppColors.lightPurple
                      : AppColors.darkBorder,
                  width: isSelected ? 3 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.lightPurple.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: _buildCardImage(card, false, width, height),
              ),
            ),
            const SizedBox(height: 6),

            // Card name with proportional font size
            Text(
              cardName,
              style: AppTheme.caption.copyWith(
                color: isSelected
                    ? AppColors.lightPurple
                    : AppColors.darkTextSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: width * 0.12, // Proportional font size
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// [buildExpandableCardsButton] - Button to expand/collapse card sections
  /// Provides better UX by preventing overwhelming card displays
  Widget _buildExpandableCardsButton(
    String title,
    RxList<Map<String, dynamic>> cards,
    int crossAxisCount,
    double cardWidth,
    double cardHeight,
    double spacing,
  ) {
    return Obx(() {
      final isExpanded = controller.isCardSectionExpanded(title);
      final buttonText = isExpanded ? 'Show Less' : 'Show More';
      final iconData = isExpanded ? Icons.expand_less : Icons.expand_more;

      return GestureDetector(
        onTap: () {
          if (kDebugMode) {
            print('[TarotView] Button tapped for section: $title');
            print(
              '[TarotView] Current expanded state: ${controller.isCardSectionExpanded(title)}',
            );
          }
          controller.toggleCardSectionExpansion(title);
          if (kDebugMode) {
            print(
              '[TarotView] After toggle, expanded state: ${controller.isCardSectionExpanded(title)}',
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: AppConstants.smallPadding,
          ),
          decoration: BoxDecoration(
            color: AppColors.lightPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.lightPurple.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                buttonText,
                style: AppTheme.caption.copyWith(
                  color: AppColors.lightPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                iconData,
                size: 16,
                color: AppColors.lightPurple,
              ),
            ],
          ),
        ),
      );
    });
  }

  /// [buildQuestionInput] - Question input field with mystical styling
  Widget _buildQuestionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Question',
          style: AppTheme.headingSmall.copyWith(
            color: AppColors.darkTextPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        LiquidGlassCard(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              border: Border.all(
                color: AppColors.lightPurple.withValues(alpha: 0.3),
              ),
            ),
            child: TextField(
              onChanged: controller.setQuestion,
              maxLines: 3,
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.darkTextPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Ask the cards for guidance...',
                hintStyle: AppTheme.bodyMedium.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(
                  AppConstants.defaultPadding,
                ),
                // Add subtle focus effect
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                  borderSide: BorderSide(
                    color: AppColors.lightPurple.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: AppConstants.smallPadding,
        ), // Additional bottom spacing
      ],
    );
  }

  /// [buildReadingButton] - Perform reading button with mystical effects
  Widget _buildReadingButton() {
    return LiquidGlassCard(
      onTap: () {
        if (controller.currentQuestion.value.isNotEmpty) {
          controller.performReading();
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => controller.isReadingInProgress.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.lightPurple,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.auto_awesome,
                      color: AppColors.lightPurple,
                      size: 20,
                    ),
            ),
            const SizedBox(width: AppConstants.smallPadding),
            Obx(
              () => Text(
                controller.isReadingInProgress.value
                    ? 'Reading Cards...'
                    : 'Perform Reading',
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: controller.currentQuestion.value.isNotEmpty
                      ? AppColors.lightPurple
                      : AppColors.darkTextTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// [buildSelectedCards] - Display selected cards with beautiful animations
  Widget _buildSelectedCards() {
    return Obx(() {
      if (!controller.hasSelectedCards) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selected Cards',
                style: AppTheme.headingSmall.copyWith(
                  color: AppColors.darkTextPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: controller.clearReading,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('New Reading'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.lightPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          _buildCardsGrid(),
        ],
      );
    });
  }

  /// [buildCardsGrid] - Grid layout for displaying selected cards with dynamic sizing
  /// Shows larger images for fewer cards and maintains beautiful proportions
  Widget _buildCardsGrid() {
    return Obx(() {
      final cards = controller.selectedCards;

      // Dynamic sizing based on number of cards for better visual hierarchy
      if (cards.length == 1) {
        // Single card - show large and prominent
        return Center(
          child: SizedBox(
            width: 200,
            height: 405,
            child: _buildCardDisplay(cards.first, 0, isLarge: true),
          ),
        );
      } else if (cards.length == 2) {
        // Two cards - show side by side with medium size
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 140,
              height: 196,
              child: _buildCardDisplay(cards[0], 0),
            ),
            SizedBox(
              width: 140,
              height: 196,
              child: _buildCardDisplay(cards[1], 1),
            ),
          ],
        );
      } else {
        // Three or more cards - use grid layout
        final crossAxisCount = cards.length <= 3 ? cards.length : 3;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppConstants.defaultPadding,
            mainAxisSpacing: AppConstants.smallPadding,
            childAspectRatio: 0.50,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return _buildCardDisplay(card, index);
          },
        );
      }
    });
  }

  /// [buildCardDisplay] - Individual card display with mystical styling
  /// Supports both large and standard sizes for optimal visual hierarchy
  Widget _buildCardDisplay(
    Map<String, dynamic> card,
    int index, {
    bool isLarge = false,
  }) {
    final cardName = (card['name'] as String?) ?? 'Unknown Card';
    final isReversed = (card['is_reversed'] as bool?) ?? false;
    final position = (card['position'] as int?) ?? 1;

    // Dynamic sizing based on isLarge parameter
    final cardWidth = isLarge ? 200.0 : 60.0;
    final cardHeight = isLarge ? 280.0 : 80.0;
    final fontSize = isLarge ? 16.0 : 12.0;

    return LiquidGlassCard(
      child: Column(
        children: [
          // Card position indicator
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.lightPurple.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Card $position',
              style: AppTheme.caption.copyWith(
                color: AppColors.lightPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),

          // Card image from URL with beautiful styling and fallback
          Container(
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isReversed ? AppColors.lightGold : AppColors.lightPurple,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: _buildCardImage(card, isReversed, cardWidth, cardHeight),
            ),
          ),

          const SizedBox(height: AppConstants.smallPadding),

          // Card name
          Text(
            cardName,
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.darkTextPrimary,
              fontSize: fontSize,
            ),
            textAlign: TextAlign.center,
            maxLines: isLarge ? 3 : 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // Orientation indicator
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: isReversed
                  ? AppColors.lightGold.withValues(alpha: 0.2)
                  : AppColors.lightPurple.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isReversed ? 'Reversed' : 'Upright',
              style: AppTheme.caption.copyWith(
                color: isReversed ? AppColors.lightGold : AppColors.lightPurple,
                fontSize: fontSize * 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// [buildCardImage] - Build tarot card image with network loading and fallback
  /// Uses cached network image for performance with beautiful loading states
  Widget _buildCardImage(
    Map<String, dynamic> card,
    bool isReversed,
    double width,
    double height,
  ) {
    final imageUrl = card['image_url'] as String?;

    if (imageUrl == null || imageUrl.isEmpty) {
      // Fallback to placeholder with mystical styling
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          isReversed ? Icons.rotate_right : Icons.auto_awesome,
          color: isReversed ? AppColors.lightGold : AppColors.lightPurple,
          size: width * 0.4, // Proportional icon size
        ),
      );
    }

    // Load actual tarot card image with beautiful loading states
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: width * 0.3,
              height: width * 0.3,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isReversed ? AppColors.lightGold : AppColors.lightPurple,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Loading...',
              style: AppTheme.caption.copyWith(
                color: AppColors.darkTextTertiary,
                fontSize: width * 0.1,
              ),
            ),
          ],
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          Icons.error_outline,
          color: AppColors.error,
          size: width * 0.3,
        ),
      ),
    );
  }

  /// [buildReadingInterpretation] - Display enhanced reading interpretation with mystical styling
  Widget _buildReadingInterpretation() {
    return Obx(() {
      if (controller.readingInterpretation.value.isEmpty) {
        return const SizedBox.shrink();
      }

      // Try to parse the enhanced reading data if available
      try {
        // Check if we have enhanced reading data from the controller
        if (controller.hasEnhancedReadingData) {
          return EnhancedTarotReadingWidget(
            readingData: controller.enhancedReadingData,
            onClearReading: controller.clearReading,
          );
        }
      } on Exception catch (e) {
        if (kDebugMode) {
          print('[TarotView] Error displaying enhanced reading: $e');
        }
      }

      // Fallback to basic interpretation display
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reading Interpretation',
            style: AppTheme.headingSmall.copyWith(
              color: AppColors.darkTextPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          LiquidGlassCard(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Text(
                controller.readingInterpretation.value,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.darkTextPrimary,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

/// [LiquidGlassCard] - Reusable liquid glass card widget
/// Provides consistent styling across the tarot interface
class LiquidGlassCard extends StatelessWidget {
  const LiquidGlassCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding,
  });
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return LiquidGlassWidget(
      glassColor: AppColors.glassPrimary,
      borderColor: AppColors.lightPurple,
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      padding: padding ?? EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          child: Container(
            padding:
                padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
            child: child,
          ),
        ),
      ),
    );
  }
}

import 'package:astro_iztro/app/modules/tarot/tarot_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:astro_iztro/shared/widgets/background_image_widget.dart';
import 'package:astro_iztro/shared/widgets/liquid_glass_widget.dart';
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
      expandedHeight: 120,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      stretch: true, // Apple-style stretch effect
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Tarot Reading',
          style: AppTheme.headingMedium.copyWith(
            color: AppColors.darkTextPrimary,
            fontFamily: AppConstants.decorativeFont,
            fontWeight: FontWeight.w300,
            letterSpacing: 2, // Apple-style letter spacing
          ),
        ),
        titlePadding: const EdgeInsets.only(
          left: 16,
          bottom: AppConstants.largePadding,
          top: 16,
        ),
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
  Widget _buildHeaderContent() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Divine Guidance & Insight',
            style: AppTheme.bodyLarge.copyWith(
              color: AppColors.darkTextPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Discover the wisdom of the cards through mystical readings',
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// [buildMainContent] - Main scrollable content with tarot features
  Widget _buildMainContent() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.borderRadius * 2),
            topRight: Radius.circular(AppConstants.borderRadius * 2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReadingTypeSelector(),
              const SizedBox(height: AppConstants.largePadding),
              _buildQuestionInput(),
              const SizedBox(height: AppConstants.largePadding),
              _buildReadingButton(),
              const SizedBox(height: AppConstants.largePadding),
              _buildSelectedCards(),
              const SizedBox(height: AppConstants.largePadding),
              _buildReadingInterpretation(),
            ],
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
              final isSelected = controller.selectedReadingType.value == readingType;
              return _buildReadingTypeCard(readingType, isSelected);
            });
          },
        ),
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

    return LiquidGlassCard(
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
                    : AppColors.darkTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
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
              contentPadding: const EdgeInsets.all(AppConstants.defaultPadding),
            ),
          ),
        ),
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
            Obx(() => controller.isReadingInProgress.value
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
                  )),
            const SizedBox(width: AppConstants.smallPadding),
                            Obx(() => Text(
                  controller.isReadingInProgress.value
                      ? 'Reading Cards...'
                      : 'Perform Reading',
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: controller.currentQuestion.value.isNotEmpty
                        ? AppColors.lightPurple
                        : AppColors.darkTextTertiary,
                  ),
                )),
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

    /// [buildCardsGrid] - Grid layout for displaying selected cards
  Widget _buildCardsGrid() {
    return Obx(() {
      final cards = controller.selectedCards;
      final crossAxisCount = cards.length <= 3 ? cards.length : 3;

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppConstants.defaultPadding,
          mainAxisSpacing: AppConstants.defaultPadding,
          childAspectRatio: 0.7,
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return _buildCardDisplay(card, index);
        },
      );
    });
  }

  /// [buildCardDisplay] - Individual card display with mystical styling
  Widget _buildCardDisplay(Map<String, dynamic> card, int index) {
    final cardName = (card['name'] as String?) ?? 'Unknown Card';
    final isReversed = (card['is_reversed'] as bool?) ?? false;
    final position = (card['position'] as int?) ?? 1;

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

          // Card image placeholder (you can replace with actual card images)
          Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isReversed ? AppColors.lightGold : AppColors.lightPurple,
                width: 2,
              ),
            ),
            child: Icon(
              isReversed ? Icons.rotate_right : Icons.auto_awesome,
              color: isReversed ? AppColors.lightGold : AppColors.lightPurple,
              size: 24,
            ),
          ),

          const SizedBox(height: AppConstants.smallPadding),

          // Card name
          Text(
            cardName,
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.darkTextPrimary,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
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
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

    /// [buildReadingInterpretation] - Display reading interpretation with mystical styling
  Widget _buildReadingInterpretation() {
    return Obx(() {
      if (controller.readingInterpretation.value.isEmpty) return const SizedBox.shrink();

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

// ignore: lines_longer_than_80_chars
// ignore_for_file: avoid_dynamic_calls, inference_failure_on_untyped_parameter, strict_top_level_inference, document_ignores

import 'package:astro_iztro/app/modules/bazi/bazi_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/core/models/bazi_data.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:astro_iztro/shared/widgets/background_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// [BaZiView] - Four Pillars BaZi analysis screen
/// Redesigned with modern UI following Apple Human Interface Guidelines
/// Features enhanced visual hierarchy, glass effects, and smooth animations
class BaZiView extends GetView<BaZiController> {
  const BaZiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.baziTitle,
            style: const TextStyle(
              color: AppColors.darkTextPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.darkCard.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.lightPurple,
              size: 20,
            ),
          ),
          onPressed: Get.back<void>,
        ),
      ),
      body: BaZiBackground(
        child: Obx(_buildBody),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// [buildFloatingActionButton] - Modern floating action button with glass effect
  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGold.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: controller.hasBaZiData
            ? controller.refreshBaZi
            : controller.calculateBaZi,
        backgroundColor: AppColors.lightGold,
        foregroundColor: AppColors.black,
        elevation: 0,
        child: Obx(
          () => AnimatedSwitcher(
            duration: AppConstants.mediumAnimation,
            child: Icon(
              controller.isCalculating.value
                  ? Icons.hourglass_empty
                  : controller.hasBaZiData
                  ? Icons.refresh_rounded
                  : Icons.calculate_rounded,
              key: ValueKey(controller.isCalculating.value),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (controller.isLoading.value) {
      return _buildLoadingState();
    }

    if (!controller.hasBaZiData) {
      return _buildEmptyState();
    }

    final baziData = controller.baziData.value!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero BaZi display with enhanced visual hierarchy
          _buildHeroBaZiDisplay(baziData),

          const SizedBox(height: AppConstants.largePadding),

          // Four Pillars section with modern card design
          _buildFourPillarsSection(baziData),

          const SizedBox(height: AppConstants.largePadding),

          // Enhanced Element Analysis section
          _buildElementAnalysisSection(baziData),

          if (baziData.recommendations.isNotEmpty) ...[
            const SizedBox(height: AppConstants.largePadding),
            _buildRecommendationsSection(baziData),
          ],

          const SizedBox(height: AppConstants.largePadding),
        ],
      ),
    );
  }

  /// [buildLoadingState] - Enhanced loading state with smooth animations
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.darkCard.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.lightPurple.withValues(alpha: 0.3),
              ),
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightGold),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            'Calculating your BaZi...',
            style: AppTheme.headingMedium.copyWith(
              color: AppColors.darkTextPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            'Analyzing the cosmic influences',
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// [buildEmptyState] - Modern empty state with call-to-action
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.darkCard.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.lightPurple.withValues(alpha: 0.2),
                ),
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 80,
                color: AppColors.lightPurple.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              'Discover Your Destiny',
              style: AppTheme.headingLarge.copyWith(
                color: AppColors.darkTextPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              'Tap the golden button to unlock your Four Pillars chart and reveal the cosmic patterns that shape your life',
              style: AppTheme.bodyLarge.copyWith(
                color: AppColors.darkTextSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// [buildHeroBaZiDisplay] - Hero section with main BaZi information
  Widget _buildHeroBaZiDisplay(BaZiData baziData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.largePadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkCard.withValues(alpha: 0.9),
            AppColors.darkCardSecondary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.lightPurple.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main BaZi characters with enhanced typography
          Text(
            controller.getBaZiString(),
            style: TextStyle(
              fontFamily: AppConstants.monoFont,
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: AppColors.lightGold,
              letterSpacing: 2,
              shadows: [
                Shadow(
                  color: AppColors.lightGold.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          // Zodiac information with modern styling
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: AppConstants.smallPadding,
            ),
            decoration: BoxDecoration(
              color: AppColors.lightPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.lightPurple.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              '${baziData.chineseZodiac} • ${baziData.westernZodiac}',
              style: AppTheme.bodyLarge.copyWith(
                color: AppColors.lightPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// [buildFourPillarsSection] - Modern four pillars display
  Widget _buildFourPillarsSection(BaZiData baziData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Four Pillars',
          style: AppTheme.headingMedium.copyWith(
            color: AppColors.darkTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),

        // Pillars grid with enhanced card design
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppConstants.defaultPadding,
            mainAxisSpacing: AppConstants.defaultPadding,
            childAspectRatio: 1.2,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return _buildPillarCard(index, baziData.allPillars[index]);
          },
        ),
      ],
    );
  }

  /// [buildPillarCard] - Individual pillar card with modern design
  Widget _buildPillarCard(int index, PillarData pillar) {
    final pillarNames = ['Year', 'Month', 'Day', 'Hour'];
    final pillarColors = [
      AppColors.cinnabar,
      AppColors.emerald,
      AppColors.jade,
      AppColors.amber,
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkCard.withValues(alpha: 0.9),
            AppColors.darkCardSecondary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: pillarColors[index].withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: pillarColors[index].withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pillar name
            Text(
              pillarNames[index],
              style: AppTheme.caption.copyWith(
                color: AppColors.darkTextSecondary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: AppConstants.smallPadding),

            // Main pillar characters
            Text(
              pillar.pillarString,
              style: TextStyle(
                fontFamily: AppConstants.chineseFont,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: pillarColors[index],
                shadows: [
                  Shadow(
                    color: pillarColors[index].withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.smallPadding),

            // Element information
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.smallPadding,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.darkBorder.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${pillar.stemElement}/${pillar.branchElement}',
                style: AppTheme.caption.copyWith(
                  color: AppColors.darkTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// [buildElementAnalysisSection] - Enhanced element analysis with modern progress bars
  Widget _buildElementAnalysisSection(BaZiData baziData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Element Analysis',
          style: AppTheme.headingMedium.copyWith(
            color: AppColors.darkTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),

        Container(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.darkCard.withValues(alpha: 0.9),
                AppColors.darkCardSecondary.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.lightPurple.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Element progress bars
              ...baziData.elementCounts.entries.map(
                _buildElementProgressBar,
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              // Summary information
              _buildElementSummary(baziData),
            ],
          ),
        ),
      ],
    );
  }

  /// [buildElementProgressBar] - Individual element progress bar
  Widget _buildElementProgressBar(MapEntry<String, int> entry) {
    final elementColors = {
      '木': AppColors.emerald,
      '火': AppColors.cinnabar,
      '土': AppColors.amber,
      '金': AppColors.lightGold,
      '水': AppColors.jade,
    };

    final progress = entry.value / 8; // Max possible is around 8

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.smallPadding),
      child: Row(
        children: [
          // Element symbol
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: elementColors[entry.key]?.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    elementColors[entry.key]?.withValues(alpha: 0.3) ??
                    AppColors.darkBorder,
              ),
            ),
            child: Center(
              child: Text(
                entry.key,
                style: TextStyle(
                  fontFamily: AppConstants.chineseFont,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: elementColors[entry.key],
                ),
              ),
            ),
          ),

          const SizedBox(width: AppConstants.defaultPadding),

          // Progress bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getElementName(entry.key),
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppColors.darkTextSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${entry.value}',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppColors.darkTextPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.darkBorder.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            elementColors[entry.key] ?? AppColors.lightPurple,
                            elementColors[entry.key]?.withValues(alpha: 0.7) ??
                                AppColors.lightPurple.withValues(alpha: 0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// [getElementName] - Get English name for Chinese element
  String _getElementName(String element) {
    final elementNames = {
      '木': 'Wood',
      '火': 'Fire',
      '土': 'Earth',
      '金': 'Metal',
      '水': 'Water',
    };
    return elementNames[element] ?? element;
  }

  /// [buildElementSummary] - Element analysis summary
  Widget _buildElementSummary(baziData) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.darkBorder.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.darkBorder.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Strongest: ${baziData.strongestElement}',
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Weakest: ${baziData.weakestElement}',
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: AppConstants.smallPadding,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.lightPurple.withValues(alpha: 0.2),
                  AppColors.lightGold.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.lightPurple.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Balance',
                  style: AppTheme.caption.copyWith(
                    color: AppColors.darkTextSecondary,
                  ),
                ),
                Text(
                  '${baziData.elementBalanceScore}%',
                  style: AppTheme.headingSmall.copyWith(
                    color: AppColors.lightPurple,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// [buildRecommendationsSection] - Modern recommendations display
  Widget _buildRecommendationsSection(BaZiData baziData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations',
          style: AppTheme.headingMedium.copyWith(
            color: AppColors.darkTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),

        Container(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.darkCard.withValues(alpha: 0.9),
                AppColors.darkCardSecondary.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.lightGold.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: baziData.recommendations
                .map(
                  (rec) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppConstants.smallPadding,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.lightGold,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: AppConstants.defaultPadding),
                        Expanded(
                          child: Text(
                            rec,
                            style: AppTheme.bodyLarge.copyWith(
                              color: AppColors.darkTextPrimary,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

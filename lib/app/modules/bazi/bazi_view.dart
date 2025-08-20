// ignore: lines_longer_than_80_chars

// ignore_for_file: document_ignores

import 'package:astro_iztro/app/modules/bazi/bazi_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/core/models/bazi_data.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:astro_iztro/shared/widgets/background_image_widget.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
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
    return GestureDetector(
      onTap: () => _showHeroExplanation(baziData),
      child: Container(
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showPillarExplanation(pillarNames[index], pillar),
        child: Container(
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

        GestureDetector(
          onTap: () => _showElementAnalysisExplanation(baziData),
          child: Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _showElementBarExplanation(entry.key, entry.value),
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
                                elementColors[entry.key] ??
                                    AppColors.lightPurple,
                                elementColors[entry.key]?.withValues(
                                      alpha: 0.7,
                                    ) ??
                                    AppColors.lightPurple.withValues(
                                      alpha: 0.7,
                                    ),
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
        ),
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
  Widget _buildElementSummary(BaZiData baziData) {
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

  // =====================
  // Explanation UI helpers
  // =====================

  void _showHeroExplanation(BaZiData data) {
    _showExplanationSheet(
      title: 'How your BaZi was calculated',
      children: [
        _explanationText(
          'We derive the Four Pillars (Year, Month, Day, Hour) from your exact birth date and time. If enabled, True Solar Time adjustments are applied for accuracy.',
        ),
        _explanationText(
          'Each pillar consists of a Heavenly Stem and an Earthly Branch. These are mapped to the Five Elements and Yin/Yang to form your personal energy blueprint.',
        ),
        _explanationText(
          'Chinese Zodiac and Western Zodiac are determined from the birth year and solar date respectively to give quick archetypal context.',
        ),
        const SizedBox(height: 12),
        _keyValue('BaZi', data.baziString),
        _keyValue('Zodiac', '${data.chineseZodiac} • ${data.westernZodiac}'),
        _keyValue('Calculated at', data.calculatedAt.toLocal().toString()),
      ],
    );
  }

  void _showPillarExplanation(String pillarName, PillarData pillar) {
    _showExplanationSheet(
      title: '$pillarName Pillar',
      children: [
        _explanationText(
          'This pillar is composed of the Heavenly Stem and Earthly Branch shown below. Each maps to an element and Yin/Yang polarity. Together they describe tendencies related to the $pillarName domain.',
        ),
        const SizedBox(height: 8),
        _keyValue(
          'Stem',
          '${pillar.stem} (${pillar.stemEn}) • ${pillar.stemElement} • ${pillar.stemYinYang}',
        ),
        _keyValue(
          'Branch',
          '${pillar.branch} (${pillar.branchEn}) • ${pillar.branchElement} • ${pillar.branchYinYang}',
        ),
        if (pillar.hiddenStems.isNotEmpty)
          _keyValue('Hidden Stems', pillar.hiddenStems.join(', ')),
        const SizedBox(height: 12),
        _explanationText(
          'Meaning: Stems influence how energy expresses outwardly, while branches describe context and timing. Element relations between stem and branch indicate support or tension.',
        ),
      ],
    );
  }

  void _showElementAnalysisExplanation(BaZiData data) {
    final counts = data.elementCounts;
    final total = counts.values.fold<int>(0, (a, b) => a + b);
    _showExplanationSheet(
      title: 'Element Analysis',
      children: [
        _explanationText(
          'We count elements from both the stem and branch of each pillar. With four pillars, there are 8 possible element contributions. Balance score = (min ÷ max) × 100.',
        ),
        _keyValue('Strongest', data.strongestElement),
        _keyValue('Weakest', data.weakestElement),
        _keyValue('Balance Score', '${data.elementBalanceScore}%'),
        _keyValue('Total Contributions', '$total (max ≈ 8)'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: counts.entries
              .map(
                (e) => Chip(
                  label: Text('${_getElementName(e.key)} ${e.value}'),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        _explanationText(
          'Meaning: Dominant elements describe strengths; missing or weak elements indicate areas to nurture. A higher balance score suggests smoother life dynamics.',
        ),
      ],
    );
  }

  void _showElementBarExplanation(String element, int count) {
    final description = controller.getElementDescription(element);
    _showExplanationSheet(
      title: '${_getElementName(element)} ($element)',
      children: [
        _keyValue('Count', '$count of ~8'),
        _explanationText(description),
        _explanationText(
          'This count comes from adding occurrences of $element from the stems and branches across the four pillars.',
        ),
      ],
    );
  }

  void _showExplanationSheet({
    required String title,
    required List<Widget> children,
  }) {
    if (kDebugMode) {
      // Print for debugging without spamming in release builds
      // Respecting user's request to include function name in prints
      // ignore: avoid_print
      print('[BaZiView._showExplanationSheet] Opening sheet: $title');
    }

    Get.bottomSheet<void>(
      Container(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        decoration: BoxDecoration(
          color: AppColors.darkCard.withValues(alpha: 0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: AppColors.lightPurple.withValues(alpha: 0.2),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTheme.headingMedium.copyWith(
                          color: AppColors.darkTextPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back<void>(),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.darkTextSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...children,
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _keyValue(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              key,
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.darkTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _explanationText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AppTheme.bodyLarge.copyWith(
          color: AppColors.darkTextPrimary,
          height: 1.6,
        ),
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

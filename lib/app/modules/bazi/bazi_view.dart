import 'package:astro_iztro/app/modules/bazi/bazi_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/core/models/bazi_data.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:astro_iztro/shared/widgets/background_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

/// [BaZiView] - Four Pillars BaZi analysis screen
/// Redesigned with modern UI following Apple Human Interface Guidelines
/// Features enhanced visual hierarchy, glass effects, and smooth animations
class BaZiView extends GetView<BaZiController> {
  const BaZiView({super.key});

  @override
  Widget build(BuildContext context) {
    // =============================
    // Adaptive Scaffold + App Bar
    // =============================
    // Following Apple HIG and the referenced article's adaptive guidance
    // we render a Cupertino-styled navigation bar on iOS and Material AppBar elsewhere.
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      appBar: _buildAdaptiveAppBar(isIOS, context),
      body: BaZiBackground(
        child: Obx(() => _buildBody(context)),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// [buildAdaptiveAppBar] - Platform adaptive app bar
  /// - iOS: Uses CupertinoNavigationBar with centered large title feel
  /// - Others: Uses Material AppBar
  PreferredSizeWidget _buildAdaptiveAppBar(bool isIOS, BuildContext context) {
    if (isIOS) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(44),
        child: CupertinoNavigationBar(
          middle: Text(
            AppLocalizations.of(context)!.fourPillarsBaZi,
            // Keeping typography consistent with app theme while honoring iOS style
            style: const TextStyle(
              color: AppColors.darkTextPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          backgroundColor: AppColors.darkCard.withValues(alpha: 0.8),
          border: Border.all(color: Colors.transparent),
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: Get.back<void>,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.darkCard.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                CupertinoIcons.back,
                color: AppColors.lightPurple,
                size: 18,
              ),
            ),
          ),
        ),
      );
    }

    return AppBar(
      title: Text(
        AppLocalizations.of(context)!.fourPillarsBaZi,
        style: const TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 20,
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

  Widget _buildBody(BuildContext context) {
    if (controller.isLoading.value) {
      return _buildLoadingState(context);
    }

    if (!controller.hasBaZiData) {
      return _buildEmptyState(context);
    }

    final baziData = controller.baziData.value!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero BaZi display with enhanced visual hierarchy
          _buildHeroBaZiDisplay(baziData, context),

          const SizedBox(height: AppConstants.largePadding),

          // Four Pillars section with modern card design
          _buildFourPillarsSection(baziData, context),

          const SizedBox(height: AppConstants.largePadding),

          // Enhanced Element Analysis section
          _buildElementAnalysisSection(baziData, context),

          if (baziData.recommendations.isNotEmpty) ...[
            const SizedBox(height: AppConstants.largePadding),
            _buildRecommendationsSection(baziData, context),
          ],

          const SizedBox(height: AppConstants.largePadding),
        ],
      ),
    );
  }

  /// [buildLoadingState] - Enhanced loading state with smooth animations
  Widget _buildLoadingState(BuildContext context) {
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
            AppLocalizations.of(context)!.calculatingYourBaZi,
            style: AppTheme.headingMedium.copyWith(
              color: AppColors.darkTextPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            AppLocalizations.of(context)!.analyzingTheCosmicInfluences,
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// [buildEmptyState] - Modern empty state with call-to-action
  Widget _buildEmptyState(BuildContext context) {
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
              AppLocalizations.of(context)!.discoverYourDestiny,
              style: AppTheme.headingLarge.copyWith(
                color: AppColors.darkTextPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              AppLocalizations.of(context)!.tapTheGoldenButtonToUnlock,
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
  Widget _buildHeroBaZiDisplay(BaZiData baziData, BuildContext context) {
    return GestureDetector(
      onTap: () => _showHeroExplanation(baziData, context),
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
  Widget _buildFourPillarsSection(BaZiData baziData, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.fourPillars,
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
            return _buildPillarCard(index, baziData.allPillars[index], context);
          },
        ),
      ],
    );
  }

  /// [buildPillarCard] - Individual pillar card with modern design
  Widget _buildPillarCard(int index, PillarData pillar, BuildContext context) {
    final pillarNames = [
      AppLocalizations.of(context)!.year,
      AppLocalizations.of(context)!.month,
      AppLocalizations.of(context)!.day,
      AppLocalizations.of(context)!.hour,
    ];
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
        onTap: () =>
            _showPillarExplanation(pillarNames[index], pillar, context),
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
  Widget _buildElementAnalysisSection(BaZiData baziData, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.elementAnalysis,
          style: AppTheme.headingMedium.copyWith(
            color: AppColors.darkTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        GestureDetector(
          onTap: () => _showElementAnalysisExplanation(baziData, context),
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
                  (entry) => _buildElementProgressBar(entry, context),
                ),

                const SizedBox(height: AppConstants.defaultPadding),

                // Summary information
                _buildElementSummary(baziData, context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// [buildElementProgressBar] - Individual element progress bar
  Widget _buildElementProgressBar(
    MapEntry<String, int> entry,
    BuildContext context,
  ) {
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
          onTap: () =>
              _showElementBarExplanation(entry.key, entry.value, context),
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
                    color: elementColors[entry.key]?.withValues(alpha: 0.3) ??
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
                          _getElementName(entry.key, context),
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

  /// [getElementName] - Get localized name for Chinese element
  String _getElementName(String element, BuildContext context) {
    final elementNames = {
      '木': AppLocalizations.of(context)!.wood,
      '火': AppLocalizations.of(context)!.fire,
      '土': AppLocalizations.of(context)!.earth,
      '金': AppLocalizations.of(context)!.metal,
      '水': AppLocalizations.of(context)!.water,
    };
    return elementNames[element] ?? element;
  }

  /// [buildElementSummary] - Element analysis summary
  Widget _buildElementSummary(BaZiData baziData, BuildContext context) {
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
                      '${AppLocalizations.of(context)!.strongest}: ${baziData.strongestElement}',
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
                      '${AppLocalizations.of(context)!.weakest}: ${baziData.weakestElement}',
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
                  AppLocalizations.of(context)!.balance,
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

  void _showHeroExplanation(BaZiData data, BuildContext context) {
    _showExplanationSheet(
      title: AppLocalizations.of(context)!.howYourBaZiWasCalculated,
      children: [
        _explanationText(
          AppLocalizations.of(context)!.weDeriveTheFourPillars,
        ),
        _explanationText(
          AppLocalizations.of(context)!.eachPillarConsistsOf,
        ),
        _explanationText(
          AppLocalizations.of(context)!.chineseZodiacAndWesternZodiac,
        ),
        const SizedBox(height: 12),
        _keyValue(AppLocalizations.of(context)!.bazi, data.baziString),
        _keyValue(
          AppLocalizations.of(context)!.zodiac,
          '${data.chineseZodiac} • ${data.westernZodiac}',
        ),
        _keyValue(
          AppLocalizations.of(context)!.calculatedAt,
          data.calculatedAt.toLocal().toString(),
        ),
      ],
    );
  }

  void _showPillarExplanation(
    String pillarName,
    PillarData pillar,
    BuildContext context,
  ) {
    _showExplanationSheet(
      title: AppLocalizations.of(context)!.pillarPillar(pillarName),
      children: [
        _explanationText(
          AppLocalizations.of(context)!.thisPillarIsComposedOf(pillarName),
        ),
        const SizedBox(height: 8),
        _keyValue(
          AppLocalizations.of(context)!.stem,
          '${pillar.stem} (${pillar.stemEn}) • ${pillar.stemElement} • ${pillar.stemYinYang}',
        ),
        _keyValue(
          AppLocalizations.of(context)!.branch,
          '${pillar.branch} (${pillar.branchEn}) • ${pillar.branchElement} • ${pillar.branchYinYang}',
        ),
        if (pillar.hiddenStems.isNotEmpty)
          _keyValue(
            AppLocalizations.of(context)!.hiddenStems,
            pillar.hiddenStems.join(', '),
          ),
        const SizedBox(height: 12),
        _explanationText(
          AppLocalizations.of(context)!.meaningStemsInfluence,
        ),
      ],
    );
  }

  void _showElementAnalysisExplanation(BaZiData data, BuildContext context) {
    final counts = data.elementCounts;
    final total = counts.values.fold<int>(0, (a, b) => a + b);
    _showExplanationSheet(
      title: AppLocalizations.of(context)!.elementAnalysis,
      children: [
        _explanationText(
          AppLocalizations.of(context)!.weCountElementsFromBoth,
        ),
        _keyValue(
          AppLocalizations.of(context)!.strongest,
          data.strongestElement,
        ),
        _keyValue(AppLocalizations.of(context)!.weakest, data.weakestElement),
        _keyValue(
          AppLocalizations.of(context)!.balanceScore,
          '${data.elementBalanceScore}%',
        ),
        _keyValue(
          AppLocalizations.of(context)!.totalContributions,
          '$total (max ≈ 8)',
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: counts.entries
              .map(
                (e) => Chip(
                  label: Text('${_getElementName(e.key, context)} ${e.value}'),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        _explanationText(
          AppLocalizations.of(context)!.meaningDominantElements,
        ),
      ],
    );
  }

  void _showElementBarExplanation(
    String element,
    int count,
    BuildContext context,
  ) {
    final description = controller.getElementDescription(element);
    _showExplanationSheet(
      title: '${_getElementName(element, context)} ($element)',
      children: [
        _keyValue(AppLocalizations.of(context)!.count, '$count of ~8'),
        _explanationText(description),
        _explanationText(
          AppLocalizations.of(context)!.thisCountComesFromAdding(element),
        ),
      ],
    );
  }

  void _showExplanationSheet({
    required String title,
    required List<Widget> children,
  }) {
    if (kDebugMode) {
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
  Widget _buildRecommendationsSection(BaZiData baziData, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.recommendations,
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

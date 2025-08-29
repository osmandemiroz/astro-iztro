import 'package:astro_iztro/app/modules/astro_matcher/astro_matcher_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/core/models/user_profile.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:astro_iztro/shared/widgets/background_image_widget.dart';
import 'package:astro_iztro/shared/widgets/liquid_glass_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// [AstroMatcherView] - Astrological compatibility analysis screen
/// Provides modern interface for analyzing relationship compatibility between two profiles
/// Enhanced with Apple-inspired design and liquid glass effects
class AstroMatcherView extends GetView<AstroMatcherController> {
  const AstroMatcherView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Modern dark theme background with space gradient
      body: AstroMatcherBackground(
        child: Obx(_buildBody),
      ),
    );
  }

  /// [buildBody] - Main body content with sections
  Widget _buildBody() {
    if (controller.isLoading.value) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
        ),
      );
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildAppBar(),
        _buildMainContent(),
      ],
    );
  }

  /// [buildAppBar] - Custom app bar with title and back button
  /// Edge-to-edge design with proper status bar spacing
  /// Enhanced with liquid glass effects for modern appearance
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      stretch: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: LiquidGlassWidget(
          glassColor: AppColors.glassPrimary,
          borderColor: AppColors.lightPurple,
          borderRadius: BorderRadius.circular(20),
          padding: const EdgeInsets.all(8),
          child: IconButton(
            onPressed: controller.navigateBack,
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.darkTextPrimary,
              size: 20,
            ),
          ),
        ),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final statusBarHeight = MediaQuery.of(context).padding.top;
          return FlexibleSpaceBar(
            title: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.defaultPadding,
              ),
              child: Text(
                'Astro Matcher',
                style: AppTheme.headingMedium.copyWith(
                  color: AppColors.darkTextPrimary,
                  fontFamily: AppConstants.decorativeFont,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            titlePadding: EdgeInsets.only(
              left: 16,
              bottom: AppConstants.largePadding,
              top: statusBarHeight + 16,
            ),
            background: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.darkSpaceGradient,
              ),
            ),
          );
        },
      ),
    );
  }

  /// [buildMainContent] - Main content area with profile selection and results
  Widget _buildMainContent() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSelectionSection(),
            const SizedBox(height: AppConstants.largePadding),
            _buildCalculateButton(),
            const SizedBox(height: AppConstants.largePadding),
            _buildResultsSection(),
          ],
        ),
      ),
    );
  }

  /// [buildProfileSelectionSection] - Profile selection interface
  Widget _buildProfileSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Profiles for Compatibility',
          style: AppTheme.headingSmall.copyWith(
            color: AppColors.darkTextPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),

        // Profile 1 Selection (Current Profile - Read Only)
        _buildCurrentProfileDisplay(
          title: 'Profile 1 (Your Profile)',
          selectedProfile: controller.selectedProfile1.value,
        ),

        const SizedBox(height: AppConstants.defaultPadding),

        // Profile 2 Selection (Other Person)
        Row(
          children: [
            Expanded(
              child: _buildProfileSelector(
                title: 'Profile 2 (Other Person)',
                selectedProfile: controller.selectedProfile2.value,
                onProfileSelected: controller.setProfile2,
                availableProfiles: controller.availableProfiles,
              ),
            ),
            const SizedBox(width: AppConstants.smallPadding),
            // Create Profile button
            LiquidGlassWidget(
              glassColor: AppColors.glassPrimary,
              borderColor: AppColors.success,
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.all(8),
              child: Semantics(
                label: 'Create new profile',
                button: true,
                child: IconButton(
                  onPressed: controller.navigateToInput,
                  icon: const Icon(
                    Icons.person_add,
                    color: AppColors.success,
                    size: 20,
                  ),
                  tooltip: 'Create new profile',
                ),
              ),
            ),
            const SizedBox(width: AppConstants.smallPadding),
            // Refresh button
            LiquidGlassWidget(
              glassColor: AppColors.glassPrimary,
              borderColor: AppColors.lightPurple,
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.all(8),
              child: Semantics(
                label: 'Refresh profiles',
                button: true,
                child: IconButton(
                  onPressed: controller.refreshProfiles,
                  icon: const Icon(
                    Icons.refresh,
                    color: AppColors.lightPurple,
                    size: 20,
                  ),
                  tooltip: 'Refresh profiles',
                ),
              ),
            ),
          ],
        ),
        if (controller.selectedProfile1.value != null &&
            controller.selectedProfile1.value ==
                controller.selectedProfile2.value) ...[
          const SizedBox(height: AppConstants.smallPadding),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.lightGold,
                size: 16,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Select a different profile for the other person to continue.',
                  style: AppTheme.caption.copyWith(
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// [buildCurrentProfileDisplay] - Display current profile (read-only)
  Widget _buildCurrentProfileDisplay({
    required String title,
    required UserProfile? selectedProfile,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),

        if (selectedProfile == null)
          _buildNoCurrentProfileMessage()
        else
          _buildCurrentProfileCard(selectedProfile),
      ],
    );
  }

  /// [buildNoCurrentProfileMessage] - Message when no current profile exists
  Widget _buildNoCurrentProfileMessage() {
    return LiquidGlassWidget(
      glassColor: AppColors.glassSecondary,
      borderColor: AppColors.error,
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: Text(
              'No current profile found. Please create a profile first.',
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// [buildCurrentProfileCard] - Display current profile information
  Widget _buildCurrentProfileCard(UserProfile profile) {
    return LiquidGlassWidget(
      glassColor: AppColors.glassPrimary,
      borderColor: AppColors.lightPurple,
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: profile.gender == 'male'
                ? AppColors.lightGold
                : AppColors.lightPurple,
            child: Icon(
              profile.gender == 'male' ? Icons.male : Icons.female,
              color: AppColors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  profile.name ?? 'Unknown',
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkTextPrimary,
                  ),
                ),
                Text(
                  '${profile.birthDate.day}/${profile.birthDate.month}/${profile.birthDate.year} - ${profile.formattedBirthTime}',
                  style: AppTheme.caption.copyWith(
                    color: AppColors.darkTextSecondary,
                  ),
                ),
                Text(
                  'Current Profile',
                  style: AppTheme.caption.copyWith(
                    color: AppColors.lightPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: AppColors.lightPurple,
            size: 20,
          ),
        ],
      ),
    );
  }

  /// [buildProfileSelector] - Individual profile selector widget
  Widget _buildProfileSelector({
    required String title,
    required UserProfile? selectedProfile,
    required void Function(UserProfile) onProfileSelected,
    required RxList<UserProfile> availableProfiles,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),

        if (availableProfiles.isEmpty)
          _buildNoOtherProfilesMessage()
        else
          _buildProfileDropdown(
            selectedProfile: selectedProfile,
            availableProfiles: availableProfiles,
            onProfileSelected: onProfileSelected,
          ),
      ],
    );
  }

  /// [buildNoOtherProfilesMessage] - Message when no other profiles are available
  Widget _buildNoOtherProfilesMessage() {
    return LiquidGlassWidget(
      glassColor: AppColors.glassSecondary,
      borderColor: AppColors.lightPurple.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: AppColors.lightPurple,
            size: 20,
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: Text(
              'No other profiles available. Create a profile for the other person to analyze compatibility.',
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// [buildProfileDropdown] - Profile dropdown selector
  Widget _buildProfileDropdown({
    required UserProfile? selectedProfile,
    required RxList<UserProfile> availableProfiles,
    required void Function(UserProfile) onProfileSelected,
  }) {
    return LiquidGlassWidget(
      glassColor: AppColors.glassPrimary,
      borderColor: AppColors.lightPurple,
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<UserProfile>(
          value: selectedProfile,
          isExpanded: true,
          dropdownColor: AppColors.glassPrimary,
          style: AppTheme.bodyMedium.copyWith(
            color: AppColors.darkTextPrimary,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.lightPurple,
          ),
          hint: Text(
            'Select a profile',
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
          items: availableProfiles.map((profile) {
            return DropdownMenuItem<UserProfile>(
              value: profile,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: profile.gender == 'male'
                        ? AppColors.lightGold
                        : AppColors.lightPurple,
                    child: Icon(
                      profile.gender == 'male' ? Icons.male : Icons.female,
                      color: AppColors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          profile.name ?? 'Unknown',
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${profile.birthDate.day}/${profile.birthDate.month}/${profile.birthDate.year}',
                          style: AppTheme.caption.copyWith(
                            color: AppColors.darkTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (UserProfile? newProfile) {
            if (newProfile != null) {
              onProfileSelected(newProfile);
            }
          },
        ),
      ),
    );
  }

  /// [buildCalculateButton] - Calculate compatibility button
  Widget _buildCalculateButton() {
    return Obx(() {
      final hasProfile1 = controller.selectedProfile1.value != null;
      final hasProfile2 = controller.selectedProfile2.value != null;
      final profilesDifferent =
          controller.selectedProfile1.value !=
          controller.selectedProfile2.value;
      final canCalculate = hasProfile1 && hasProfile2 && profilesDifferent;

      return SizedBox(
        width: double.infinity,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: LiquidGlassWidget(
            glassColor: canCalculate
                ? AppColors.lightPurple
                : AppColors.glassSecondary,
            borderColor: canCalculate
                ? AppColors.lightPurple
                : AppColors.lightPurple.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: TextButton(
              onPressed: canCalculate
                  ? () {
                      HapticFeedback.mediumImpact();
                      controller.calculateCompatibility();
                    }
                  : null,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.defaultPadding,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite,
                    color: canCalculate
                        ? AppColors.white
                        : AppColors.darkTextSecondary,
                    size: 24,
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Text(
                    'Calculate Your Compatibility',
                    style: AppTheme.bodyLarge.copyWith(
                      color: canCalculate
                          ? AppColors.white
                          : AppColors.darkTextSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  /// [buildResultsSection] - Compatibility results display
  Widget _buildResultsSection() {
    return Obx(() {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: controller.hasResult.value
            ? Column(
                key: const ValueKey('results'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Compatibility Results',
                    style: AppTheme.headingSmall.copyWith(
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  _buildOverallScoreCard(),
                  const SizedBox(height: AppConstants.defaultPadding),
                  _buildDetailedAnalysisCard(),
                  const SizedBox(height: AppConstants.defaultPadding),
                  _buildRecommendationsCard(),
                  const SizedBox(height: AppConstants.defaultPadding),
                  _buildFutureInsightsCard(),
                ],
              )
            : const SizedBox.shrink(),
      );
    });
  }

  /// [buildOverallScoreCard] - Overall compatibility score display
  Widget _buildOverallScoreCard() {
    return _insightInk(
      onTap: () => _openInsight(
        title: 'Overall Compatibility',
        body: _overallScoreExplanation(),
      ),
      child: LiquidGlassWidget(
        glassColor: AppColors.glassPrimary,
        borderColor: AppColors.lightPurple,
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            Text(
              'Your Overall Compatibility',
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              controller.getCompatibilityScore(),
              style: AppTheme.headingLarge.copyWith(
                color: AppColors.lightPurple,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              controller.getCompatibilitySummary(),
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.darkTextPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// [buildDetailedAnalysisCard] - Detailed compatibility analysis
  Widget _buildDetailedAnalysisCard() {
    final analysis = controller.getCompatibilityAnalysis();
    if (analysis == null) return const SizedBox.shrink();

    return _insightInk(
      onTap: () => _openInsight(
        title: 'Detailed Analysis',
        body: _detailedAnalysisExplanation(analysis),
      ),
      child: LiquidGlassWidget(
        glassColor: AppColors.glassPrimary,
        borderColor: AppColors.lightPurple,
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Detailed Analysis',
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.darkTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),

            _buildAnalysisItem(
              'Sun Sign',
              (analysis['sunSignAnalysis'] as String?) ??
                  'No analysis available',
              Icons.wb_sunny,
              AppColors.lightGold,
            ),

            const SizedBox(height: AppConstants.smallPadding),

            _buildAnalysisItem(
              'Element',
              (analysis['elementAnalysis'] as String?) ??
                  'No analysis available',
              Icons.local_fire_department,
              AppColors.lightPurple,
            ),

            const SizedBox(height: AppConstants.smallPadding),

            _buildAnalysisItem(
              'Timing',
              (analysis['timingAnalysis'] as String?) ??
                  'No analysis available',
              Icons.schedule,
              AppColors.success,
            ),
          ],
        ),
      ),
    );
  }

  /// [buildAnalysisItem] - Individual analysis item
  Widget _buildAnalysisItem(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(width: AppConstants.smallPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.darkTextSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.darkTextPrimary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// [buildRecommendationsCard] - Compatibility recommendations
  Widget _buildRecommendationsCard() {
    final recommendations = controller.getRecommendations();
    if (recommendations.isEmpty) return const SizedBox.shrink();

    return _insightInk(
      onTap: () => _openInsight(
        title: 'Recommendations',
        body: _recommendationsExplanation(),
      ),
      child: LiquidGlassWidget(
        glassColor: AppColors.glassPrimary,
        borderColor: AppColors.lightPurple,
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Relationship Recommendations',
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.darkTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            ...recommendations.map(
              (recommendation) => Padding(
                padding: const EdgeInsets.only(
                  bottom: AppConstants.smallPadding,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: AppColors.lightGold,
                      size: 16,
                    ),
                    const SizedBox(width: AppConstants.smallPadding),
                    Expanded(
                      child: Text(
                        recommendation,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppColors.darkTextPrimary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Future insights card and explanation helpers ---
  Widget _buildFutureInsightsCard() {
    final yearly = controller.getYearlyScores();
    final prediction = controller.getPredictionLabel();
    if (yearly.isEmpty &&
        (prediction.isEmpty || prediction == 'No prediction available')) {
      return const SizedBox.shrink();
    }

    final years = yearly.keys.toList()..sort();
    return _insightInk(
      onTap: () => _openInsight(
        title: 'Future Compatibility Insights',
        body: _futureInsightsExplanation(yearly, prediction),
      ),
      child: LiquidGlassWidget(
        glassColor: AppColors.glassPrimary,
        borderColor: AppColors.lightPurple,
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Future Insights',
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.darkTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            if (years.isNotEmpty)
              Column(
                children: years.map((y) {
                  final score = yearly[y] ?? 0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 54,
                          child: Text(
                            '$y',
                            style: AppTheme.caption.copyWith(
                              color: AppColors.darkTextSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              final breakdown = controller.getYearBreakdown(y);
                              final body = _yearBreakdownExplanation(
                                y,
                                breakdown,
                                score,
                              );
                              _openInsight(title: 'Year $y', body: body);
                            },
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.glassSecondary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: (score / 100).clamp(0.0, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.lightPurple,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 44,
                          child: Text(
                            '${score.toStringAsFixed(0)}%',
                            style: AppTheme.caption.copyWith(
                              color: AppColors.darkTextPrimary,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: AppConstants.smallPadding),
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: AppColors.lightGold,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    prediction,
                    style: AppTheme.caption.copyWith(
                      color: AppColors.darkTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _overallScoreExplanation() {
    return [
      Text(
        'Overall score blends Sun Sign (30%), Element (25%), Timing (20%), Chinese Zodiac Year (15%), and Hour Branch (10%).',
        style: AppTheme.bodyMedium.copyWith(
          color: AppColors.darkTextSecondary,
          height: 1.5,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        controller.getCompatibilitySummary(),
        style: AppTheme.bodyMedium.copyWith(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    ];
  }

  List<Widget> _detailedAnalysisExplanation(Map<String, dynamic> analysis) {
    return [
      _explainLine('Sun Sign', 'Traditional Western zodiac matrix scoring.'),
      const SizedBox(height: 6),
      _explainLine(
        'Element',
        'Five-element interaction table (Wood, Fire, Earth, Metal, Water).',
      ),
      const SizedBox(height: 6),
      _explainLine('Timing', 'Age gap, seasonal rhythm, and cycle alignment.'),
    ];
  }

  List<Widget> _recommendationsExplanation() {
    return [
      Text(
        'Suggestions are derived from your overall score to amplify strengths and address challenges.',
        style: AppTheme.bodyMedium.copyWith(
          color: AppColors.darkTextSecondary,
          height: 1.5,
        ),
      ),
    ];
  }

  List<Widget> _futureInsightsExplanation(
    Map<int, double> yearly,
    String prediction,
  ) {
    return [
      Text(
        'We compute yearly projections from trend analysis over multiple years and highlight peaks and dips.',
        style: AppTheme.bodyMedium.copyWith(
          color: AppColors.darkTextSecondary,
          height: 1.5,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Prediction: $prediction',
        style: AppTheme.bodyMedium.copyWith(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    ];
  }

  List<Widget> _yearBreakdownExplanation(
    int year,
    Map<String, dynamic>? breakdown,
    double score,
  ) {
    final reasons = (breakdown?['reasons'] as Map?)?.cast<String, dynamic>();
    final scores = (reasons?['scores'] as Map?)?.cast<String, dynamic>();
    final weights = (reasons?['weights'] as Map?)?.cast<String, dynamic>();
    final timing = (reasons?['timing'] as Map?)?.cast<String, dynamic>();
    final yearElement = reasons?['yearElement']?.toString();
    final yearAnimal = reasons?['yearAnimal']?.toString();
    final pairElements = (reasons?['pairElements'] as List?)?.join(' & ');
    final pairAnimals = (reasons?['pairAnimals'] as List?)?.join(' & ');

    List<Widget> row(String label, String value) => [
      Row(
        children: [
          Text(
            '$label: ',
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.darkTextSecondary,
              fontWeight: FontWeight.w600,
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
      const SizedBox(height: 6),
    ];

    return [
      Text(
        'Composed yearly score with explicit contributions.',
        style: AppTheme.bodyMedium.copyWith(
          color: AppColors.darkTextSecondary,
          height: 1.5,
        ),
      ),
      const SizedBox(height: 8),
      ...row('Overall', '${score.toStringAsFixed(1)}%'),
      if (yearElement != null)
        ...row('Year Element', '$yearElement vs $pairElements'),
      if (yearAnimal != null)
        ...row('Year Animal', '$yearAnimal vs $pairAnimals'),
      if (scores != null && weights != null)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Components',
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.darkTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            _componentLine('Baseline pair', scores['base'], weights['base']),
            _componentLine(
              'Year element support',
              scores['yearElementSupport'],
              weights['elementYear'],
            ),
            _componentLine(
              'Year animal support',
              scores['yearAnimalSupport'],
              weights['zodiacYear'],
            ),
            _componentLine(
              'Timing synergy',
              scores['timingSynergy'],
              weights['synergy'],
            ),
          ],
        ),
      if (timing != null) ...[
        const SizedBox(height: 8),
        Text(
          'Timing',
          style: AppTheme.bodyMedium.copyWith(
            color: AppColors.darkTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Energy levels: ${(timing['energy1'] as num?)?.toStringAsFixed(0)} & ${(timing['energy2'] as num?)?.toStringAsFixed(0)} • Synergy ${(timing['synergyScore'] as num?)?.toStringAsFixed(0)}',
          style: AppTheme.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
      ],
    ];
  }

  Widget _componentLine(String name, dynamic score, dynamic weight) {
    final s = (score is num) ? score.toDouble() : 0.0;
    final w = (weight is num) ? weight.toDouble() : 0.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: AppTheme.caption.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
          ),
          Text(
            '${s.toStringAsFixed(0)} × ${w.toStringAsFixed(2)}',
            style: AppTheme.caption.copyWith(color: AppColors.darkTextPrimary),
          ),
        ],
      ),
    );
  }

  Widget _explainLine(String title, String body) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.analytics, color: AppColors.lightPurple, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
              children: [
                TextSpan(
                  text: '$title: ',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppColors.darkTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: body),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openInsight({required String title, required List<Widget> body}) {
    Get.dialog<void>(
      Dialog(
        backgroundColor: AppColors.darkCard.withValues(alpha: 0.95),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.lightPurple.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.lightPurple,
                  ),
                  const SizedBox(width: 8),
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
                    tooltip: 'Close',
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              ...body,
              const SizedBox(height: AppConstants.defaultPadding),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back<void>(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightPurple,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.defaultPadding,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Got it'),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierColor: AppColors.black.withValues(alpha: 0.5),
    );
  }

  Widget _insightInk({required Widget child, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: child,
      ),
    );
  }
}

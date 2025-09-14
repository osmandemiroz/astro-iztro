import 'package:astro_iztro/app/modules/astro_matcher/astro_matcher_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/core/models/user_profile.dart';
import 'package:astro_iztro/core/utils/responsive_sizer.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:astro_iztro/shared/widgets/background_image_widget.dart';
import 'package:astro_iztro/shared/widgets/liquid_glass_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

/// [AstroMatcherView] - Astrological compatibility analysis screen
/// Provides modern interface for analyzing relationship compatibility between two profiles
/// Enhanced with Apple-inspired design and liquid glass effects
class AstroMatcherView extends GetView<AstroMatcherController> {
  const AstroMatcherView({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveSizer.init(context);
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
        _buildAppBar(
          height: ResponsiveSizer.h(20),
          width: ResponsiveSizer.w(100),
        ),
        _buildMainContent(),
      ],
    );
  }

  /// [buildAppBar] - Custom app bar with centered title
  /// Edge-to-edge design with proper status bar spacing
  /// Enhanced with liquid glass effects for modern appearance
  /// Follows Apple's Human Interface Guidelines for clean, minimal design
  Widget _buildAppBar({
    required double height,
    required double width,
  }) {
    return SliverAppBar(
      expandedHeight: 100,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      stretch: true,
      // Custom leading back button to return to previous screen
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: LiquidGlassWidget(
            height: height,
            width: width,
            glassColor: AppColors.glassPrimary,
            borderColor: AppColors.lightPurple.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12),
            padding: const EdgeInsets.all(2),
            child: Semantics(
              label: AppLocalizations.of(Get.context!)!.goBack,
              button: true,
              child: IconButton(
                onPressed: () {
                  // [AstroMatcherView._buildAppBar] Back navigation
                  Get.back<void>();
                },
                tooltip: AppLocalizations.of(Get.context!)!.back,
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.darkTextPrimary,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final statusBarHeight = MediaQuery.of(context).padding.top;
          return FlexibleSpaceBar(
            // Center the title at the bottom of the header
            title: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.defaultPadding,
                ),
                child: Text(
                  AppLocalizations.of(Get.context!)!.astroMatcher,
                  style: AppTheme.headingSmall.copyWith(
                    color: AppColors.darkTextPrimary,
                    fontFamily: AppConstants.decorativeFont,
                    fontWeight: FontWeight.w200,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
            // Center the title horizontally and position at bottom
            titlePadding: EdgeInsets.only(
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
            _buildProfileSelectionSection(
              height: ResponsiveSizer.h(11),
              width: ResponsiveSizer.w(100),
            ),
            const SizedBox(height: AppConstants.largePadding),
            _buildCalculateButton(
              height: ResponsiveSizer.h(10),
              width: ResponsiveSizer.w(20),
            ),
            const SizedBox(height: AppConstants.largePadding),
            _buildResultsSection(
              height: ResponsiveSizer.h(10),
              width: ResponsiveSizer.w(100),
            ),
          ],
        ),
      ),
    );
  }

  /// [buildProfileSelectionSection] - Profile selection interface
  Widget _buildProfileSelectionSection({
    required double height,
    required double width,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(Get.context!)!.selectProfilesForCompatibility,
          style: AppTheme.headingSmall.copyWith(
            color: AppColors.darkTextPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),

        // Profile 1 Selection (Current Profile - Read Only)
        _buildCurrentProfileDisplay(
          height: height,
          width: width,
          title: AppLocalizations.of(Get.context!)!.profile1YourProfile,
          selectedProfile: controller.selectedProfile1.value,
        ),

        const SizedBox(height: AppConstants.defaultPadding),

        // Profile 2 Selection (Other Person)
        Row(
          children: [
            Expanded(
              child: _buildProfileSelector(
                height: height * 0.7,
                width: width * 0.5,
                title: AppLocalizations.of(Get.context!)!.profile2OtherPerson,
                selectedProfile: controller.selectedProfile2.value,
                onProfileSelected: controller.setProfile2,
                availableProfiles: controller.availableProfiles,
              ),
            ),
            const SizedBox(width: AppConstants.smallPadding),
            // Create Profile button
            LiquidGlassWidget(
              height: 75,
              width: 75,
              glassColor: AppColors.glassPrimary,
              borderColor: AppColors.success,
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.all(8),
              child: Semantics(
                label: AppLocalizations.of(Get.context!)!.createNewProfile,
                button: true,
                child: IconButton(
                  onPressed: controller.navigateToInput,
                  icon: const Icon(
                    Icons.person_add,
                    color: AppColors.success,
                    size: 20,
                  ),
                  tooltip: AppLocalizations.of(Get.context!)!.createNewProfile,
                ),
              ),
            ),
            const SizedBox(width: AppConstants.smallPadding),
            // Refresh button
            LiquidGlassWidget(
              height: 75,
              width: 75,
              glassColor: AppColors.glassPrimary,
              borderColor: AppColors.lightPurple,
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.all(8),
              child: Semantics(
                label: AppLocalizations.of(Get.context!)!.refreshProfiles,
                button: true,
                child: IconButton(
                  onPressed: controller.refreshProfiles,
                  icon: const Icon(
                    Icons.refresh,
                    color: AppColors.lightPurple,
                    size: 20,
                  ),
                  tooltip: AppLocalizations.of(Get.context!)!.refreshProfiles,
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
                  AppLocalizations.of(Get.context!)!
                      .selectDifferentProfileToContinue,
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
    required double height,
    required double width,
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
          _buildNoCurrentProfileMessage(
            height: height,
            width: width,
          )
        else
          _buildCurrentProfileCard(
            height: height,
            width: width,
            profile: selectedProfile,
          ),
      ],
    );
  }

  /// [buildNoCurrentProfileMessage] - Message when no current profile exists
  Widget _buildNoCurrentProfileMessage({
    required double height,
    required double width,
  }) {
    return LiquidGlassWidget(
      height: height,
      width: width,
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
              AppLocalizations.of(Get.context!)!.noCurrentProfileFound,
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
  Widget _buildCurrentProfileCard({
    required double height,
    required double width,
    required UserProfile profile,
  }) {
    return LiquidGlassWidget(
      height: height,
      width: width,
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
                  profile.name ?? AppLocalizations.of(Get.context!)!.unknown,
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
                  AppLocalizations.of(Get.context!)!.currentProfile,
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
    required double height,
    required double width,
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
        if (availableProfiles.isEmpty)
          _buildNoOtherProfilesMessage(
            height: height,
            width: width,
          )
        else
          _buildProfileDropdown(
            height: height,
            width: width,
            selectedProfile: selectedProfile,
            availableProfiles: availableProfiles,
            onProfileSelected: onProfileSelected,
          ),
      ],
    );
  }

  /// [buildNoOtherProfilesMessage] - Message when no other profiles are available
  Widget _buildNoOtherProfilesMessage({
    required double height,
    required double width,
  }) {
    return LiquidGlassWidget(
      height: height,
      width: width,
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
              AppLocalizations.of(Get.context!)!.noOtherProfilesAvailable,
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
    required double height,
    required double width,
  }) {
    return LiquidGlassWidget(
      height: height,
      width: width,
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
            AppLocalizations.of(Get.context!)!.selectAProfile,
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
                          profile.name ??
                              AppLocalizations.of(Get.context!)!.unknown,
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
  Widget _buildCalculateButton({
    required double height,
    required double width,
  }) {
    return Obx(() {
      final hasProfile1 = controller.selectedProfile1.value != null;
      final hasProfile2 = controller.selectedProfile2.value != null;
      final profilesDifferent = controller.selectedProfile1.value !=
          controller.selectedProfile2.value;
      final canCalculate = hasProfile1 && hasProfile2 && profilesDifferent;

      return SizedBox(
        width: double.infinity,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: LiquidGlassWidget(
            height: height,
            width: width,
            glassColor:
                canCalculate ? AppColors.lightPurple : AppColors.glassSecondary,
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
                    AppLocalizations.of(Get.context!)!
                        .calculateYourCompatibility,
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
  Widget _buildResultsSection({
    required double height,
    required double width,
  }) {
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
                    AppLocalizations.of(Get.context!)!.yourCompatibilityResults,
                    style: AppTheme.headingSmall.copyWith(
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  _buildOverallScoreCard(
                    height: height,
                    width: width,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  _buildDetailedAnalysisCard(
                    height: height,
                    width: width,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  _buildRecommendationsCard(
                    height: height,
                    width: width,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  _buildFutureInsightsCard(
                    height: height,
                    width: width,
                  ),
                ],
              )
            : const SizedBox.shrink(),
      );
    });
  }

  /// [buildOverallScoreCard] - Overall compatibility score display
  Widget _buildOverallScoreCard({
    required double height,
    required double width,
  }) {
    return _insightInk(
      onTap: () => _openInsight(
        title: AppLocalizations.of(Get.context!)!.overallCompatibility,
        body: _overallScoreExplanation(),
      ),
      child: LiquidGlassWidget(
        height: height * 1.6,
        width: width,
        glassColor: AppColors.glassPrimary,
        borderColor: AppColors.lightPurple,
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(Get.context!)!.yourOverallCompatibility,
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
  Widget _buildDetailedAnalysisCard({
    required double height,
    required double width,
  }) {
    final analysis = controller.getCompatibilityAnalysis();
    if (analysis == null) return const SizedBox.shrink();

    return _insightInk(
      onTap: () => _openInsight(
        title: AppLocalizations.of(Get.context!)!.detailedAnalysis,
        body: _detailedAnalysisExplanation(analysis),
      ),
      child: LiquidGlassWidget(
        height: height * 4,
        width: width,
        glassColor: AppColors.glassPrimary,
        borderColor: AppColors.lightPurple,
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(Get.context!)!.yourDetailedAnalysis,
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.darkTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            _buildAnalysisItem(
              AppLocalizations.of(Get.context!)!.sunSign,
              (analysis['sunSignAnalysis'] as String?) ??
                  AppLocalizations.of(Get.context!)!.noAnalysisAvailable,
              Icons.wb_sunny,
              AppColors.lightGold,
            ),
            const SizedBox(height: AppConstants.smallPadding),
            _buildAnalysisItem(
              AppLocalizations.of(Get.context!)!.element,
              (analysis['elementAnalysis'] as String?) ??
                  AppLocalizations.of(Get.context!)!.noAnalysisAvailable,
              Icons.local_fire_department,
              AppColors.lightPurple,
            ),
            const SizedBox(height: AppConstants.smallPadding),
            _buildAnalysisItem(
              AppLocalizations.of(Get.context!)!.timing,
              (analysis['timingAnalysis'] as String?) ??
                  AppLocalizations.of(Get.context!)!.noAnalysisAvailable,
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
  Widget _buildRecommendationsCard({
    required double height,
    required double width,
  }) {
    final recommendations = controller.getRecommendations();
    if (recommendations.isEmpty) return const SizedBox.shrink();

    return _insightInk(
      onTap: () => _openInsight(
        title: AppLocalizations.of(Get.context!)!.recommendations,
        body: _recommendationsExplanation(),
      ),
      child: LiquidGlassWidget(
        height: height * 2.4,
        width: width,
        glassColor: AppColors.glassPrimary,
        borderColor: AppColors.lightPurple,
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(Get.context!)!
                  .yourRelationshipRecommendations,
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
  Widget _buildFutureInsightsCard({
    required double height,
    required double width,
  }) {
    final yearly = controller.getYearlyScores();
    final prediction = controller.getPredictionLabel();
    if (yearly.isEmpty &&
        (prediction.isEmpty || prediction == 'No prediction available')) {
      return const SizedBox.shrink();
    }

    final years = yearly.keys.toList()..sort();
    return _insightInk(
      onTap: () => _openInsight(
        title: AppLocalizations.of(Get.context!)!.futureCompatibilityInsights,
        body: _futureInsightsExplanation(yearly, prediction),
      ),
      child: LiquidGlassWidget(
        height: height * 3,
        width: width,
        glassColor: AppColors.glassPrimary,
        borderColor: AppColors.lightPurple,
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(Get.context!)!.futureInsights,
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
                              _openInsight(
                                title:
                                    AppLocalizations.of(Get.context!)!.year(y),
                                body: body,
                              );
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
        AppLocalizations.of(Get.context!)!.overallScoreExplanation,
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
      _explainLine(
        AppLocalizations.of(Get.context!)!.sunSign,
        AppLocalizations.of(Get.context!)!.sunSignExplanation,
      ),
      const SizedBox(height: 6),
      _explainLine(
        AppLocalizations.of(Get.context!)!.element,
        AppLocalizations.of(Get.context!)!.elementExplanation,
      ),
      const SizedBox(height: 6),
      _explainLine(
        AppLocalizations.of(Get.context!)!.timing,
        AppLocalizations.of(Get.context!)!.timingExplanation,
      ),
    ];
  }

  List<Widget> _recommendationsExplanation() {
    return [
      Text(
        AppLocalizations.of(Get.context!)!.recommendationsExplanation,
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
        AppLocalizations.of(Get.context!)!.futureInsightsExplanation,
        style: AppTheme.bodyMedium.copyWith(
          color: AppColors.darkTextSecondary,
          height: 1.5,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        AppLocalizations.of(Get.context!)!.prediction(prediction),
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
        AppLocalizations.of(Get.context!)!.yearBreakdownExplanation,
        style: AppTheme.bodyMedium.copyWith(
          color: AppColors.darkTextSecondary,
          height: 1.5,
        ),
      ),
      const SizedBox(height: 8),
      ...row(
        AppLocalizations.of(Get.context!)!.overall,
        '${score.toStringAsFixed(1)}%',
      ),
      if (yearElement != null)
        ...row(
          AppLocalizations.of(Get.context!)!.yearElement,
          '$yearElement vs $pairElements',
        ),
      if (yearAnimal != null)
        ...row(
          AppLocalizations.of(Get.context!)!.yearAnimal,
          '$yearAnimal vs $pairAnimals',
        ),
      if (scores != null && weights != null)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(Get.context!)!.components,
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.darkTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            _componentLine(
              AppLocalizations.of(Get.context!)!.baselinePair,
              scores['base'],
              weights['base'],
            ),
            _componentLine(
              AppLocalizations.of(Get.context!)!.yearElementSupport,
              scores['yearElementSupport'],
              weights['elementYear'],
            ),
            _componentLine(
              AppLocalizations.of(Get.context!)!.yearAnimalSupport,
              scores['yearAnimalSupport'],
              weights['zodiacYear'],
            ),
            _componentLine(
              AppLocalizations.of(Get.context!)!.timingSynergy,
              scores['timingSynergy'],
              weights['synergy'],
            ),
          ],
        ),
      if (timing != null) ...[
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(Get.context!)!.timingBreakdown,
          style: AppTheme.bodyMedium.copyWith(
            color: AppColors.darkTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          AppLocalizations.of(Get.context!)!.energyLevelsAndSynergy(
            (timing['energy1'] as num?)?.toStringAsFixed(0) ?? '0',
            (timing['energy2'] as num?)?.toStringAsFixed(0) ?? '0',
            (timing['synergyScore'] as num?)?.toStringAsFixed(0) ?? '0',
          ),
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
                    tooltip: AppLocalizations.of(Get.context!)!.close,
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
                  child: Text(AppLocalizations.of(Get.context!)!.gotIt),
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

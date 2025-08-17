import 'package:astro_iztro/app/modules/astro_matcher/astro_matcher_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/core/models/user_profile.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:astro_iztro/shared/widgets/background_image_widget.dart';
import 'package:astro_iztro/shared/widgets/liquid_glass_widget.dart';
import 'package:flutter/material.dart';
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
      body: HomeBackground(
        child: SafeArea(
          child: Obx(_buildBody),
        ),
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
      expandedHeight: 120,
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
                  letterSpacing: 2,
                ),
              ),
            ),
            titlePadding: EdgeInsets.only(
              left: 16,
              bottom: AppConstants.largePadding,
              top: statusBarHeight + 8,
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
            const SizedBox(width: AppConstants.smallPadding),
            // Refresh button
            LiquidGlassWidget(
              glassColor: AppColors.glassPrimary,
              borderColor: AppColors.lightPurple,
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.all(8),
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
          ],
        ),
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
            onPressed: canCalculate ? controller.calculateCompatibility : null,
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
      );
    });
  }

  /// [buildResultsSection] - Compatibility results display
  Widget _buildResultsSection() {
    return Obx(() {
      if (!controller.hasResult.value) {
        return const SizedBox.shrink();
      }

      return Column(
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
        ],
      );
    });
  }

  /// [buildOverallScoreCard] - Overall compatibility score display
  Widget _buildOverallScoreCard() {
    return LiquidGlassWidget(
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
    );
  }

  /// [buildDetailedAnalysisCard] - Detailed compatibility analysis
  Widget _buildDetailedAnalysisCard() {
    final analysis = controller.getCompatibilityAnalysis();
    if (analysis == null) return const SizedBox.shrink();

    return LiquidGlassWidget(
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
            (analysis['sunSignAnalysis'] as String?) ?? 'No analysis available',
            Icons.wb_sunny,
            AppColors.lightGold,
          ),

          const SizedBox(height: AppConstants.smallPadding),

          _buildAnalysisItem(
            'Element',
            (analysis['elementAnalysis'] as String?) ?? 'No analysis available',
            Icons.local_fire_department,
            AppColors.lightPurple,
          ),

          const SizedBox(height: AppConstants.smallPadding),

          _buildAnalysisItem(
            'Timing',
            (analysis['timingAnalysis'] as String?) ?? 'No analysis available',
            Icons.schedule,
            AppColors.success,
          ),
        ],
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

    return LiquidGlassWidget(
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
              padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
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
    );
  }
}

import 'package:astro_iztro/app/modules/home/home_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/core/models/user_profile.dart';
import 'package:astro_iztro/core/utils/iz_animated_widgets.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:astro_iztro/shared/widgets/background_image_widget.dart';
import 'package:astro_iztro/shared/widgets/liquid_glass_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// [HomeView] - Main dashboard screen with Apple-inspired design
/// Provides quick access to all astrology features and user profiles
/// Enhanced with dark theme and liquid glass effects for modern UI
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Modern dark theme background with space gradient
      body: HomeBackground(
        child: SafeArea(
          top: false, // Allow gradient to extend to status bar
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
        Builder(
          builder: (context) {
            try {
              return _buildMainContent();
            } on Exception {
              return SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: 48,
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      Text(
                        'Error loading content',
                        style: AppTheme.headingSmall.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                      const SizedBox(height: AppConstants.smallPadding),
                      Text(
                        'There was an error loading the home screen content. This might be due to corrupted data.',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppColors.darkTextSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      ElevatedButton(
                        onPressed: controller.clearCorruptedData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: AppColors.white,
                        ),
                        child: const Text('Fix Data'),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  /// [buildAppBar] - Custom app bar with user greeting
  /// Edge-to-edge design with proper status bar spacing
  /// Enhanced with liquid glass effects for modern appearance
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 140, // Increased to account for status bar
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      stretch: true, // Apple-style stretch effect
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          // Get status bar height for proper spacing
          final statusBarHeight = MediaQuery.of(context).padding.top;

          return FlexibleSpaceBar(
            title: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.defaultPadding,
              ),
              child: Text(
                'ASTRO IZTRO',
                style: AppTheme.headingMedium.copyWith(
                  color: AppColors.darkTextPrimary,
                  fontFamily: AppConstants.decorativeFont,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2, // Apple-style letter spacing
                ),
              ),
            ),
            titlePadding: EdgeInsets.only(
              left: 16,
              bottom: AppConstants.largePadding,
              top: statusBarHeight + 8, // Account for status bar
            ),
            background: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.darkSpaceGradient,
              ),
              child: _buildHeaderContent(),
            ),
          );
        },
      ),
      actions: [
        // Settings button with proper status bar spacing and tap animation
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(Get.context!).padding.top,
          ),
          child: IzTapScale(
            onTap: controller.navigateToSettings,
            child: LiquidGlassWidget(
              glassColor: AppColors.glassPrimary,
              borderColor: AppColors.lightPurple,
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.all(8),
              child: IconButton(
                onPressed: controller.navigateToSettings,
                icon: const Icon(
                  Icons.settings_outlined,
                  color: AppColors.darkTextPrimary,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// [buildHeaderContent] - Header with user greeting and quick stats
  /// Properly positioned to avoid status bar overlap
  Widget _buildHeaderContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get status bar height for proper content positioning
        final statusBarHeight = MediaQuery.of(context).padding.top;

        return Padding(
          padding: EdgeInsets.only(
            left: AppConstants.defaultPadding,
            right: AppConstants.defaultPadding,
            bottom: AppConstants.smallPadding,
            // Add extra top padding to push content below status bar and title
            top: statusBarHeight + 10, // Status bar + title space
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Obx(() {
                final profile = controller.currentProfile.value;
                return Text(
                  profile != null
                      ? 'Welcome back, ${profile.name ?? 'User'}!'
                      : 'Welcome to Astro Iztro!',
                  style: AppTheme.bodyLarge.copyWith(
                    color: AppColors.darkTextPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                );
              }),
              const SizedBox(height: 2),
            ],
          ),
        );
      },
    );
  }

  /// [buildMainContent] - Main scrollable content
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
              // Animate profile section with slide-in effect
              IzSlideFadeIn(
                offset: const Offset(0, 20),
                child: _buildCurrentProfileSection(),
              ),
              const SizedBox(height: AppConstants.largePadding),
              // Animate quick actions with staggered effect
              IzSlideFadeIn(
                delay: const Duration(milliseconds: 150),
                child: _buildQuickActionsSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// [buildCurrentProfileSection] - Current profile card
  Widget _buildCurrentProfileSection() {
    return Obx(() {
      final profile = controller.currentProfile.value;

      if (profile == null) {
        return _buildNoProfileCard();
      }

      return IzTapScale(
        onTap: controller.navigateToInput,
        child: LiquidGlassCard(
          onTap: controller.navigateToInput,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Current Profile',
                    style: AppTheme.headingSmall.copyWith(
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: controller.navigateToInput,
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: AppColors.lightPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.smallPadding),
              _buildProfileInfo(profile),
            ],
          ),
        ),
      );
    });
  }

  /// [buildNoProfileCard] - Card shown when no profile exists
  Widget _buildNoProfileCard() {
    return IzTapScale(
      onTap: controller.navigateToInput,
      child: LiquidGlassCard(
        onTap: controller.navigateToInput,
        child: Column(
          children: [
            Icon(
              Icons.person_add_outlined,
              size: 48,
              color: AppColors.lightPurple.withValues(alpha: 0.7),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              'Create Your First Profile',
              style: AppTheme.headingSmall.copyWith(
                color: AppColors.lightPurple,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              'Start your astrological journey by creating a profile with your birth information.',
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            ElevatedButton.icon(
              onPressed: controller.navigateToInput,
              icon: const Icon(Icons.add),
              label: const Text('Create Profile'),
            ),
          ],
        ),
      ),
    );
  }

  /// [buildProfileInfo] - Display profile information
  Widget _buildProfileInfo(UserProfile profile) {
    return Column(
      children: [
        _buildInfoRow(
          Icons.person_outline,
          'Name',
          profile.name ?? 'Unknown',
        ),
        _buildInfoRow(
          Icons.calendar_today_outlined,
          'Birth Date',
          '${profile.birthDate.day}/${profile.birthDate.month}/${profile.birthDate.year}',
        ),
        _buildInfoRow(
          Icons.access_time_outlined,
          'Birth Time',
          profile.formattedBirthTime,
        ),
        _buildInfoRow(
          Icons.location_on_outlined,
          'Location',
          profile.locationString,
        ),
      ],
    );
  }

  /// [buildInfoRow] - Information row widget
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.darkTextTertiary,
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Text(
            '$label:',
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.darkTextSecondary,
            ),
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: Text(
              value,
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.darkTextPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// [buildQuickActionsSection] - Quick action buttons redesigned for 5 actions
  /// Uses modern vertical column layout for better organization and visual appeal
  /// Includes tarot reading as one of the quick actions
  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Animate section title with fade-in
        IzFadeIn(
          delay: const Duration(milliseconds: 100),
          child: Text(
            'Quick Actions',
            style: AppTheme.headingSmall.copyWith(
              color: AppColors.darkTextPrimary,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        // All actions in a vertical column layout for better UX
        Column(
          children: [
            // Purple Star Chart
            IzSlideFadeIn(
              offset: const Offset(0, 20),
              delay: const Duration(milliseconds: 200),
              child: _buildActionCard(
                iconAsset: 'assets/images/icon/ic_astrology_chart.png',
                title: 'Purple Star Chart',
                subtitle: 'View astrology chart',
                onTap: controller.navigateToChart,
                color: AppColors.lightPurple,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            // BaZi Analysis
            IzSlideFadeIn(
              offset: const Offset(0, 20),
              delay: const Duration(milliseconds: 250),
              child: _buildActionCard(
                iconAsset: 'assets/images/icon/ic_analyze.png',
                title: 'BaZi Analysis',
                subtitle: 'Four Pillars reading',
                onTap: controller.navigateToBaZi,
                color: AppColors.lightGold,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            // Tarot Reading
            IzSlideFadeIn(
              offset: const Offset(0, 20),
              delay: const Duration(milliseconds: 300),
              child: _buildActionCard(
                iconAsset: 'assets/images/icon/ic_tarot.png',
                title: 'Tarot Reading',
                subtitle: 'Mystical guidance',
                onTap: controller.navigateToTarot,
                color: AppColors.lightPurple,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            // Detailed Analysis
            IzSlideFadeIn(
              offset: const Offset(0, 20),
              delay: const Duration(milliseconds: 350),
              child: _buildActionCard(
                iconAsset: 'assets/images/icon/ic_detailed_analyze.png',
                title: 'Detailed Analysis',
                subtitle: 'In-depth interpretation',
                onTap: controller.navigateToAnalysis,
                color: AppColors.lightPurple,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            // Astro Matcher
            IzSlideFadeIn(
              offset: const Offset(0, 20),
              delay: const Duration(milliseconds: 400),
              child: _buildActionCard(
                iconAsset: 'assets/images/icon/ic_matcher.png',
                title: 'Astro Matcher',
                subtitle: 'Find compatibility',
                onTap: controller.navigateToAstroMatcher,
                color: AppColors.lightGold,
              ),
            ),
            // Add extra bottom spacing to ensure last card is visible
            const SizedBox(height: AppConstants.largePadding),
          ],
        ),
      ],
    );
  }

  /// [buildActionCard] - Individual action card
  /// Enhanced to support both icon assets and Material icons for flexibility
  /// Redesigned for full-width, professional appearance
  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    String? iconAsset,
    IconData? icon,
  }) {
    return IzTapScale(
      onTap: onTap,
      child: Container(
        width: double.infinity, // Full width
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container with background
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: color.withValues(alpha: 0.3),
                ),
              ),
              child: Center(
                child: iconAsset != null
                    ? Image.asset(
                        iconAsset,
                        width: 32,
                        height: 32,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            icon ?? Icons.error_outline,
                            size: 32,
                            color: color,
                          );
                        },
                      )
                    : Icon(
                        icon ?? Icons.auto_awesome,
                        size: 32,
                        color: color,
                      ),
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkTextPrimary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppColors.darkTextSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow indicator
            Icon(
              Icons.arrow_forward_ios,
              color: color.withValues(alpha: 0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

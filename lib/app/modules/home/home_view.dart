import 'package:astro_iztro/app/modules/home/home_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/core/models/user_profile.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:astro_iztro/shared/widgets/background_image_widget.dart';
import 'package:astro_iztro/shared/widgets/liquid_glass_widget.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
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

      // Bottom navigation for main app sections
      bottomNavigationBar: _buildBottomNavigationBar(),
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
        // Settings button with proper status bar spacing
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(Get.context!).padding.top,
          ),
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
              _buildCurrentProfileSection(),
              const SizedBox(height: AppConstants.largePadding),
              _buildQuickActionsSection(),
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

      return LiquidGlassCard(
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
      );
    });
  }

  /// [buildNoProfileCard] - Card shown when no profile exists
  Widget _buildNoProfileCard() {
    return LiquidGlassCard(
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

  /// [buildQuickActionsSection] - Quick action buttons
  /// Uses custom icon assets for enhanced visual appeal
  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTheme.headingSmall.copyWith(
            color: AppColors.darkTextPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                iconAsset: 'assets/images/icon/ic_astrology_chart.png',
                title: 'Purple Star Chart',
                subtitle: 'View astrology chart',
                onTap: controller.navigateToChart,
                color: AppColors.lightPurple,
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            Expanded(
              child: _buildActionCard(
                iconAsset: 'assets/images/icon/ic_analyze.png',
                title: 'BaZi Analysis',
                subtitle: 'Four Pillars reading',
                onTap: controller.navigateToBaZi,
                color: AppColors.lightGold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                iconAsset: 'assets/images/icon/ic_detailed_analyze.png',
                title: 'Detailed Analysis',
                subtitle: 'In-depth interpretation',
                onTap: controller.navigateToAnalysis,
                color: AppColors.lightPurple,
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            Expanded(
              child: _buildActionCard(
                iconAsset: 'assets/images/icon/ic_matcher.png',
                title: 'Astro Matcher',
                subtitle: 'Find compatibility',
                onTap: controller.navigateToAstroMatcher,
                color: AppColors.lightGold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// [buildActionCard] - Individual action card
  /// Enhanced to support both icon assets and Material icons for flexibility
  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    String? iconAsset,
    IconData? icon,
  }) {
    return LiquidGlassCard(
      onTap: onTap,
      child: Column(
        children: [
          // Display icon asset if provided, otherwise fall back to Material icon
          if (iconAsset != null)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  iconAsset,
                  width: 24,
                  height: 24,
                  // Note: PNG files don't support color tinting, so we use background color instead
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to a default icon if asset loading fails
                    return Icon(
                      icon ?? Icons.error_outline,
                      size: 24,
                      color: color,
                    );
                  },
                ),
              ),
            )
          else if (icon != null)
            Icon(
              icon,
              size: 40,
              color: color,
            ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            title,
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.darkTextPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTheme.caption.copyWith(
              color: AppColors.darkTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// [buildBottomNavigationBar] - Bottom navigation bar with iztro and tarot sections
  Widget _buildBottomNavigationBar() {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: controller.selectedBottomNavIndex.value,
        onTap: (index) {
          controller.setBottomNavIndex(index);
          switch (index) {
            case 0:
              // Already on home (iztro)
              break;
            case 1:
              controller.navigateToTarot();
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.lightPurple,
        unselectedItemColor: AppColors.darkTextTertiary,
        backgroundColor: AppColors.darkSurface,
        items: [
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(
                'assets/images/icon/ic_iztro.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  if (kDebugMode) {
                    print('[HomeView] Error loading ic_iztro.png: $error');
                  }
                  return const Icon(
                    Icons.home_outlined,
                    size: 24,
                    color: AppColors.darkTextTertiary,
                  );
                },
              ),
            ),
            activeIcon: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(
                'assets/images/icon/ic_iztro.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  if (kDebugMode) {
                    print(
                      '[HomeView] Error loading ic_iztro.png (active): $error',
                    );
                  }
                  return const Icon(
                    Icons.home,
                    size: 24,
                    color: AppColors.lightPurple,
                  );
                },
              ),
            ),
            label: 'iztro',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(
                'assets/images/icon/ic_tarot.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  if (kDebugMode) {
                    print('[HomeView] Error loading ic_tarot.png: $error');
                  }
                  return const Icon(
                    Icons.auto_awesome_outlined,
                    size: 24,
                    color: AppColors.darkTextTertiary,
                  );
                },
              ),
            ),
            activeIcon: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(
                'assets/images/icon/ic_tarot.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  if (kDebugMode) {
                    print(
                      '[HomeView] Error loading ic_tarot.png (active): $error',
                    );
                  }
                  return const Icon(
                    Icons.auto_awesome,
                    size: 24,
                    color: AppColors.lightPurple,
                  );
                },
              ),
            ),
            label: 'tarot',
          ),
        ],
      ),
    );
  }
}

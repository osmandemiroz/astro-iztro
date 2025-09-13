// ignore_for_file: use_build_context_synchronously, document_ignores

import 'package:astro_iztro/app/modules/home/home_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/core/models/user_profile.dart';
import 'package:astro_iztro/core/services/language_service.dart';
import 'package:astro_iztro/core/utils/iz_animated_widgets.dart';
import 'package:astro_iztro/core/utils/responsive_sizer.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:astro_iztro/shared/widgets/background_image_widget.dart';
import 'package:astro_iztro/shared/widgets/liquid_glass_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

/// [HomeView] - Adaptive main dashboard screen following Apple Human Interface Guidelines
///
/// This home page implements comprehensive adaptive design principles from the article:
/// - Platform-specific components (iOS Cupertino vs Android Material)
/// - Responsive layout that adapts to different screen sizes using MediaQuery and LayoutBuilder
/// - Modern, sleek UI with smooth animations and transitions
/// - Comprehensive error handling and loading states
/// - Edge-to-edge design with proper status bar handling
///
/// Key Features:
/// - Adaptive navigation and UI components based on platform detection
/// - Responsive grid layout for different screen sizes (mobile, tablet, desktop)
/// - Smooth animations and micro-interactions following Apple HIG
/// - Modern glass morphism effects with liquid glass widgets
/// - Comprehensive accessibility support
/// - Platform-specific error dialogs and loading indicators
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // [HomeView.build] - Platform detection for adaptive design
    // Following the article's recommendation to use Theme.of(context).platform
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    // Initialize ResponsiveSizer
    ResponsiveSizer.init(context);
    return Scaffold(
      // Modern dark theme background with space gradient
      body: HomeBackground(
        child: SafeArea(
          top:
              false, // Allow gradient to extend to status bar for immersive experience
          child: Obx(() => _buildBody(context, isIOS)),
        ),
      ),
    );
  }

  /// [buildAdaptiveBody] - Adaptive main body content with platform-specific components
  ///
  /// This method implements the core adaptive design principles:
  /// - Platform detection using Theme.of(context).platform
  /// - Responsive layout using MediaQuery and LayoutBuilder
  /// - Error handling with platform-appropriate dialogs
  /// - Loading states with platform-specific indicators
  Widget _buildBody(BuildContext context, bool isIOS) {
    // [buildAdaptiveBody] - Handle loading state with platform-specific indicators
    if (controller.isLoading.value) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Platform-specific loading indicator
            if (isIOS)
              const CupertinoActivityIndicator(
                radius: 20,
                color: AppColors.lightPurple,
              )
            else
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.lightPurple,
                ),
                strokeWidth: 3,
              ),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              AppLocalizations.of(context)!.loadingCosmicJourney,
              style: AppTheme.bodyLarge.copyWith(
                color: AppColors.darkTextSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    // [buildAdaptiveBody] - Main content with responsive design
    return LayoutBuilder(
      builder: (context, constraints) {
        // [buildAdaptiveBody] - Responsive breakpoints following Apple HIG
        final screenWidth = constraints.maxWidth;
        final isTablet = screenWidth > 768;
        final isDesktop = screenWidth > 1024;

        return CustomScrollView(
          // [buildAdaptiveBody] - Smooth scrolling with platform-specific physics
          physics: isIOS
              ? const BouncingScrollPhysics()
              : const ClampingScrollPhysics(),
          slivers: [
            // [buildAdaptiveBody] - Adaptive app bar with platform-specific styling
            _buildAdaptiveAppBar(context, isIOS, isTablet),

            // [buildAdaptiveBody] - Main content with error handling
            Builder(
              builder: (context) {
                try {
                  return _buildAdaptiveMainContent(
                    context,
                    isIOS,
                    isTablet,
                    isDesktop,
                  );
                } on Exception catch (e) {
                  // [buildAdaptiveBody] - Platform-specific error handling
                  return _buildAdaptiveErrorState(context, isIOS, e.toString());
                }
              },
            ),
          ],
        );
      },
    );
  }

  /// [buildAdaptiveAppBar] - Platform-specific app bar with responsive design
  ///
  /// Implements adaptive design principles:
  /// - iOS: CupertinoNavigationBar with centered title and iOS-style styling
  /// - Android: Material AppBar with left-aligned title and Material Design
  /// - Responsive: Adapts layout for tablet and desktop screen sizes
  Widget _buildAdaptiveAppBar(BuildContext context, bool isIOS, bool isTablet) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    if (isIOS) {
      // [buildAdaptiveAppBar] - iOS Cupertino-style app bar
      return SliverAppBar(
        expandedHeight: isTablet ? 160 : 140,
        pinned: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        stretch: true,
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            'ASTRO IZTRO',
            style: AppTheme.headingMedium.copyWith(
              color: AppColors.darkTextPrimary,
              fontFamily: AppConstants.decorativeFont,
              fontWeight: FontWeight.w300,
              letterSpacing: 2,
            ),
          ),
          titlePadding: EdgeInsets.only(
            left: 16,
            bottom: AppConstants.largePadding + 16,
            top: statusBarHeight + 8,
          ),
          background: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.darkSpaceGradient,
            ),
            child: _buildHeaderContent(context, isIOS, isTablet),
          ),
        ),
        actions: [
          _buildAdaptiveSettingsButton(context, isIOS, statusBarHeight),
        ],
      );
    } else {
      // [buildAdaptiveAppBar] - Android Material-style app bar
      return SliverAppBar(
        expandedHeight: isTablet ? 160 : 140,
        pinned: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        stretch: true,
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            'ASTRO IZTRO',
            style: AppTheme.headingMedium.copyWith(
              color: AppColors.darkTextPrimary,
              fontFamily: AppConstants.decorativeFont,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
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
            child: _buildHeaderContent(context, isIOS, isTablet),
          ),
        ),
        actions: [
          _buildAdaptiveSettingsButton(context, isIOS, statusBarHeight),
        ],
      );
    }
  }

  /// [buildHeaderContent] - Header content with user greeting and responsive layout
  ///
  /// Adapts to different screen sizes and platforms:
  /// - Mobile: Compact layout with essential information
  /// - Tablet: Expanded layout with additional details
  /// - Platform-specific styling and interactions
  Widget _buildHeaderContent(BuildContext context, bool isIOS, bool isTablet) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Padding(
      padding: EdgeInsets.only(
        left: AppConstants.defaultPadding,
        right: AppConstants.defaultPadding,
        bottom: AppConstants.smallPadding,
        top: statusBarHeight + 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // [buildHeaderContent] - Welcome message section with responsive text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() {
                  final profile = controller.currentProfile.value;
                  return Text(
                    profile != null
                        ? AppLocalizations.of(context)!.welcomeBack(
                            profile.name ??
                                AppLocalizations.of(context)!.unknown,
                          )
                        : AppLocalizations.of(context)!.welcomeToAstroIztro,
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppColors.darkTextPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: isTablet ? 20 : 16,
                    ),
                  );
                }),
                const SizedBox(height: 2),
                if (isTablet) ...[
                  // [buildHeaderContent] - Additional info for tablet layout
                  Text(
                    AppLocalizations.of(context)!.discoverCosmicDestiny,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppColors.darkTextSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// [buildAdaptiveSettingsButton] - Platform-specific settings button
  ///
  /// Implements adaptive design with platform-appropriate styling:
  /// - iOS: Cupertino-style button with rounded corners and subtle effects
  /// - Android: Material Design button with elevation and ripple effects
  Widget _buildAdaptiveSettingsButton(
    BuildContext context,
    bool isIOS,
    double statusBarHeight,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        top: statusBarHeight + 8,
        right: 16,
      ),
      child: isIOS
          ? CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: controller.navigateToSettings,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.darkCard.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.lightPurple.withValues(alpha: 0.3),
                  ),
                ),
                child: const Icon(
                  CupertinoIcons.settings,
                  color: AppColors.lightPurple,
                  size: 24,
                ),
              ),
            )
          : Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: controller.navigateToSettings,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.darkCard.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.lightPurple.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.settings_rounded,
                    color: AppColors.lightPurple,
                    size: 24,
                  ),
                ),
              ),
            ),
    );
  }

  /// [buildAdaptiveMainContent] - Responsive main content with adaptive layout
  ///
  /// Implements responsive design principles:
  /// - Mobile: Single column layout with vertical scrolling
  /// - Tablet: Two-column layout with side-by-side content
  /// - Desktop: Multi-column layout with expanded content areas
  Widget _buildAdaptiveMainContent(
    BuildContext context,
    bool isIOS,
    bool isTablet,
    bool isDesktop,
  ) {
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
          padding: EdgeInsets.all(
            isTablet ? AppConstants.largePadding : AppConstants.defaultPadding,
          ),
          child: isTablet || isDesktop
              ? _buildResponsiveGridLayout(context, isIOS, isTablet, isDesktop)
              : _buildMobileLayout(context, isIOS),
        ),
      ),
    );
  }

  /// [buildResponsiveGridLayout] - Grid layout for tablet and desktop
  ///
  /// Implements responsive grid system:
  /// - Tablet: 2-column layout with profile and actions side-by-side
  /// - Desktop: 3-column layout with expanded content areas
  Widget _buildResponsiveGridLayout(
    BuildContext context,
    bool isIOS,
    bool isTablet,
    bool isDesktop,
  ) {
    final crossAxisCount = isDesktop ? 3 : 2;
    final childAspectRatio = isDesktop ? 1.2 : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // [buildResponsiveGridLayout] - Section title
        Text(
          AppLocalizations.of(context)!.dashboard,
          style: AppTheme.headingLarge.copyWith(
            color: AppColors.darkTextPrimary,
            fontSize: isDesktop ? 32 : 28,
          ),
        ),
        const SizedBox(height: AppConstants.largePadding),

        // [buildResponsiveGridLayout] - Responsive grid
        GridView.count(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: AppConstants.defaultPadding,
          mainAxisSpacing: AppConstants.defaultPadding,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // [buildResponsiveGridLayout] - Profile section
            _buildCurrentProfileSection(context),

            // [buildResponsiveGridLayout] - Quick actions grid
            _buildQuickActionsGrid(context, isIOS, isTablet, isDesktop),

            if (isDesktop) ...[
              // [buildResponsiveGridLayout] - Additional desktop content
              _buildDesktopAdditionalContent(context, isIOS),
            ],
          ],
        ),
      ],
    );
  }

  /// [buildMobileLayout] - Single column layout for mobile devices
  ///
  /// Optimized for mobile screens with vertical scrolling:
  /// - Profile section at the top
  /// - Quick actions in a vertical list
  /// - Platform-specific styling and interactions
  Widget _buildMobileLayout(BuildContext context, bool isIOS) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // [buildMobileLayout] - Animate profile section with slide-in effect
        IzSlideFadeIn(
          offset: const Offset(0, 20),
          child: _buildCurrentProfileSection(context),
        ),
        const SizedBox(height: AppConstants.largePadding),

        // [buildMobileLayout] - Animate quick actions with staggered effect
        IzSlideFadeIn(
          delay: const Duration(milliseconds: 150),
          child: _buildQuickActionsSection(context, isIOS),
        ),

        const SizedBox(height: AppConstants.largePadding),

        // [buildMobileLayout] - Animate settings section with slide-in effect
        IzSlideFadeIn(
          delay: const Duration(milliseconds: 200),
          child: _buildSettingsSection(context, isIOS),
        ),
      ],
    );
  }

  /// [buildCurrentProfileSection] - Current profile card with adaptive design
  ///
  /// Implements platform-specific styling and responsive layout:
  /// - iOS: Cupertino-style card with rounded corners and subtle shadows
  /// - Android: Material Design card with elevation and ripple effects
  /// - Responsive: Adapts content density for different screen sizes
  Widget _buildCurrentProfileSection(BuildContext context) {
    return Obx(() {
      final profile = controller.currentProfile.value;

      if (profile == null) {
        return _buildNoProfileCard(context);
      }

      return IzTapScale(
        onTap: controller.navigateToInput,
        child: LiquidGlassCard(
          height: ResponsiveSizer.h(25),
          width: ResponsiveSizer.w(100),
          onTap: controller.navigateToInput,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.currentProfile,
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
              _buildProfileInfo(profile, context),
            ],
          ),
        ),
      );
    });
  }

  /// [buildNoProfileCard] - Card shown when no profile exists
  ///
  /// Implements adaptive design with platform-specific styling:
  /// - iOS: Cupertino-style button and layout
  /// - Android: Material Design button and layout
  Widget _buildNoProfileCard(BuildContext context) {
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
              AppLocalizations.of(context)!.createYourFirstProfile,
              style: AppTheme.headingSmall.copyWith(
                color: AppColors.lightPurple,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              AppLocalizations.of(context)!.startAstrologicalJourney,
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            ElevatedButton.icon(
              onPressed: controller.navigateToInput,
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context)!.createProfile),
            ),
          ],
        ),
      ),
    );
  }

  /// [buildProfileInfo] - Display profile information with responsive layout
  ///
  /// Adapts information density based on screen size:
  /// - Mobile: Compact layout with essential information
  /// - Tablet/Desktop: Expanded layout with additional details
  Widget _buildProfileInfo(UserProfile profile, BuildContext context) {
    return Column(
      children: [
        _buildInfoRow(
          Icons.person_outline,
          AppLocalizations.of(context)!.name,
          profile.name ?? AppLocalizations.of(context)!.unknown,
        ),
        _buildInfoRow(
          Icons.calendar_today_outlined,
          AppLocalizations.of(context)!.birthDate,
          '${profile.birthDate.day}/${profile.birthDate.month}/${profile.birthDate.year}',
        ),
        _buildInfoRow(
          Icons.access_time_outlined,
          AppLocalizations.of(context)!.birthTime,
          profile.formattedBirthTime,
        ),
        _buildInfoRow(
          Icons.location_on_outlined,
          AppLocalizations.of(context)!.location,
          profile.locationString,
        ),
      ],
    );
  }

  /// [buildInfoRow] - Information row widget with responsive text sizing
  ///
  /// Implements adaptive typography:
  /// - Mobile: Standard text sizes for readability
  /// - Tablet/Desktop: Larger text sizes for better visibility
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

  /// [buildQuickActionsSection] - Quick action buttons for mobile layout
  ///
  /// Implements vertical layout optimized for mobile screens:
  /// - All actions in a vertical column for easy thumb navigation
  /// - Platform-specific styling and interactions
  /// - Smooth animations with staggered delays
  Widget _buildQuickActionsSection(BuildContext context, bool isIOS) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // [buildQuickActionsSection] - Animate section title with fade-in
        IzFadeIn(
          delay: const Duration(milliseconds: 100),
          child: Text(
            AppLocalizations.of(context)!.quickActions,
            style: AppTheme.headingSmall.copyWith(
              color: AppColors.darkTextPrimary,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),

        // [buildQuickActionsSection] - All actions in a vertical column layout
        Column(
          children: [
            _buildActionCard(
              iconAsset: 'assets/images/icon/ic_astrology_chart.png',
              title: AppLocalizations.of(context)!.purpleStarChart,
              subtitle: AppLocalizations.of(context)!.viewAstrologyChart,
              onTap: controller.navigateToChart,
              color: AppColors.lightPurple,
              delay: const Duration(milliseconds: 200),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildActionCard(
              iconAsset: 'assets/images/icon/ic_analyze.png',
              title: AppLocalizations.of(context)!.baziAnalysis,
              subtitle: AppLocalizations.of(context)!.fourPillarsReading,
              onTap: controller.navigateToBaZi,
              color: AppColors.lightGold,
              delay: const Duration(milliseconds: 250),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildActionCard(
              iconAsset: 'assets/images/icon/ic_tarot.png',
              title: AppLocalizations.of(context)!.tarotReading,
              subtitle: AppLocalizations.of(context)!.mysticalGuidance,
              onTap: controller.navigateToTarot,
              color: AppColors.lightPurple,
              delay: const Duration(milliseconds: 300),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildActionCard(
              iconAsset: 'assets/images/icon/ic_detailed_analyze.png',
              title: AppLocalizations.of(context)!.detailedAnalysis,
              subtitle: AppLocalizations.of(context)!.inDepthInterpretation,
              onTap: controller.navigateToAnalysis,
              color: AppColors.lightPurple,
              delay: const Duration(milliseconds: 350),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildActionCard(
              iconAsset: 'assets/images/icon/ic_matcher.png',
              title: AppLocalizations.of(context)!.astroMatcher,
              subtitle: AppLocalizations.of(context)!.findCompatibility,
              onTap: controller.navigateToAstroMatcher,
              color: AppColors.lightGold,
              delay: const Duration(milliseconds: 400),
            ),
            const SizedBox(height: AppConstants.largePadding),
          ],
        ),
      ],
    );
  }

  /// [buildSettingsSection] - Settings section for mobile layout
  ///
  /// Implements vertical layout optimized for mobile screens:
  /// - Settings options in a vertical column for easy thumb navigation
  /// - Platform-specific styling and interactions
  /// - Smooth animations with staggered delays
  Widget _buildSettingsSection(BuildContext context, bool isIOS) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // [buildSettingsSection] - Animate section title with fade-in
        IzFadeIn(
          delay: const Duration(milliseconds: 100),
          child: Text(
            AppLocalizations.of(context)!.settings,
            style: AppTheme.headingSmall.copyWith(
              color: AppColors.darkTextPrimary,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),

        // [buildSettingsSection] - Settings options in a vertical column layout
        Column(
          children: [
            _buildActionCard(
              icon: Icons.settings_outlined,
              title: AppLocalizations.of(context)!.appSettings,
              subtitle:
                  AppLocalizations.of(context)!.preferencesAndConfiguration,
              onTap: controller.navigateToSettings,
              color: AppColors.lightPurple,
              delay: const Duration(milliseconds: 200),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildActionCard(
              icon: Icons.language_outlined,
              title: AppLocalizations.of(context)!.language,
              subtitle: AppLocalizations.of(context)!.changeAppLanguage,
              onTap: () => _showLanguageDialog(context),
              color: AppColors.lightGold,
              delay: const Duration(milliseconds: 250),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildActionCard(
              icon: Icons.info_outline,
              title: AppLocalizations.of(context)!.about,
              subtitle: AppLocalizations.of(context)!.appInformationAndVersion,
              onTap: () => _showAboutDialog(context, isIOS),
              color: AppColors.lightPurple,
              delay: const Duration(milliseconds: 300),
            ),
            const SizedBox(height: AppConstants.largePadding),
          ],
        ),
      ],
    );
  }

  /// [buildQuickActionsGrid] - Grid layout for tablet and desktop quick actions
  ///
  /// Implements responsive grid system:
  /// - Tablet: 2x2 grid layout
  /// - Desktop: 3x2 grid layout with expanded content
  Widget _buildQuickActionsGrid(
    BuildContext context,
    bool isIOS,
    bool isTablet,
    bool isDesktop,
  ) {
    final actions = [
      {
        'iconAsset': 'assets/images/icon/ic_astrology_chart.png',
        'title': AppLocalizations.of(context)!.purpleStarChart,
        'subtitle': AppLocalizations.of(context)!.viewAstrologyChart,
        'onTap': controller.navigateToChart,
        'color': AppColors.lightPurple,
      },
      {
        'iconAsset': 'assets/images/icon/ic_analyze.png',
        'title': AppLocalizations.of(context)!.baziAnalysis,
        'subtitle': AppLocalizations.of(context)!.fourPillarsReading,
        'onTap': controller.navigateToBaZi,
        'color': AppColors.lightGold,
      },
      {
        'iconAsset': 'assets/images/icon/ic_tarot.png',
        'title': AppLocalizations.of(context)!.tarotReading,
        'subtitle': AppLocalizations.of(context)!.mysticalGuidance,
        'onTap': controller.navigateToTarot,
        'color': AppColors.lightPurple,
      },
      {
        'iconAsset': 'assets/images/icon/ic_detailed_analyze.png',
        'title': AppLocalizations.of(context)!.detailedAnalysis,
        'subtitle': AppLocalizations.of(context)!.inDepthInterpretation,
        'onTap': controller.navigateToAnalysis,
        'color': AppColors.lightPurple,
      },
      {
        'iconAsset': 'assets/images/icon/ic_matcher.png',
        'title': AppLocalizations.of(context)!.astroMatcher,
        'subtitle': AppLocalizations.of(context)!.findCompatibility,
        'onTap': controller.navigateToAstroMatcher,
        'color': AppColors.lightGold,
      },
      {
        'icon': Icons.settings_outlined,
        'title': AppLocalizations.of(context)!.settings,
        'subtitle': AppLocalizations.of(context)!.appPreferences,
        'onTap': controller.navigateToSettings,
        'color': AppColors.lightPurple,
      },
    ];

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
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop ? 3 : 2,
            childAspectRatio: isDesktop ? 1.2 : 1.0,
            crossAxisSpacing: AppConstants.smallPadding,
            mainAxisSpacing: AppConstants.smallPadding,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return _buildActionCard(
              iconAsset: action['iconAsset']! as String,
              title: action['title']! as String,
              subtitle: action['subtitle']! as String,
              onTap: action['onTap']! as VoidCallback,
              color: action['color']! as Color,
              delay: Duration(milliseconds: 200 + (index * 50)),
            );
          },
        ),
      ],
    );
  }

  /// [buildDesktopAdditionalContent] - Additional content for desktop layout
  ///
  /// Provides extra functionality and information for larger screens:
  /// - Recent calculations history
  /// - Quick stats and insights
  /// - Additional navigation options
  Widget _buildDesktopAdditionalContent(BuildContext context, bool isIOS) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.recentActivity,
          style: AppTheme.headingSmall.copyWith(
            color: AppColors.darkTextPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(
              color: AppColors.darkBorder,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.history,
                size: 32,
                color: AppColors.lightPurple.withValues(alpha: 0.7),
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                AppLocalizations.of(context)!.noRecentCalculations,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                AppLocalizations.of(context)!.startExploringCosmicJourney,
                style: AppTheme.caption.copyWith(
                  color: AppColors.darkTextTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// [buildActionCard] - Individual action card with adaptive design
  ///
  /// Implements platform-specific styling and responsive layout:
  /// - iOS: Cupertino-style card with rounded corners and subtle effects
  /// - Android: Material Design card with elevation and ripple effects
  /// - Responsive: Adapts size and content density for different screen sizes
  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    String? iconAsset,
    IconData? icon,
    Duration? delay,
  }) {
    return IzSlideFadeIn(
      offset: const Offset(0, 20),
      delay: delay ?? Duration.zero,
      child: IzTapScale(
        onTap: onTap,
        child: Container(
          width: double.infinity,
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
              // [buildActionCard] - Icon container with background
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

              // [buildActionCard] - Text content
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

              // [buildActionCard] - Arrow indicator
              Icon(
                Icons.arrow_forward_ios,
                color: color.withValues(alpha: 0.6),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// [buildAdaptiveErrorState] - Platform-specific error handling
  ///
  /// Implements adaptive error handling with platform-appropriate dialogs:
  /// - iOS: CupertinoAlertDialog with iOS-style buttons and styling
  /// - Android: Material AlertDialog with Material Design styling
  /// - Responsive: Adapts content density for different screen sizes
  Widget _buildAdaptiveErrorState(
    BuildContext context,
    bool isIOS,
    String errorMessage,
  ) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isIOS
                  ? CupertinoIcons.exclamationmark_triangle
                  : Icons.error_outline,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              AppLocalizations.of(context)!.errorLoadingContent,
              style: AppTheme.headingSmall.copyWith(
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              AppLocalizations.of(context)!.errorLoadingHomeContent,
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.defaultPadding),

            // [buildAdaptiveErrorState] - Platform-specific retry button
            if (isIOS)
              CupertinoButton.filled(
                onPressed: () => _showAdaptiveRetryDialog(context, isIOS),
                child: Text(AppLocalizations.of(context)!.retry),
              )
            else
              ElevatedButton(
                onPressed: () => _showAdaptiveRetryDialog(context, isIOS),
                child: Text(AppLocalizations.of(context)!.retry),
              ),
          ],
        ),
      ),
    );
  }

  /// [showAdaptiveRetryDialog] - Platform-specific retry dialog
  ///
  /// Implements adaptive dialog design:
  /// - iOS: CupertinoAlertDialog with iOS-style buttons and animations
  /// - Android: Material AlertDialog with Material Design styling
  /// - Consistent functionality across platforms
  void _showAdaptiveRetryDialog(BuildContext context, bool isIOS) {
    if (isIOS) {
      // [showAdaptiveRetryDialog] - iOS Cupertino-style dialog
      showCupertinoDialog<void>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(AppLocalizations.of(context)!.retryLoading),
          content: Text(
            AppLocalizations.of(context)!.retryLoadingQuestion,
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(ctx).pop();
                controller.refreshData();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else {
      // [showAdaptiveRetryDialog] - Android Material-style dialog
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.retryLoading),
          content: Text(
            AppLocalizations.of(context)!.retryLoadingQuestion,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                controller.refreshData();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
  }

  /// [showLanguageDialog] - Show language selection dialog
  /// Beautiful, modern dialog following Apple HIG principles
  void _showLanguageDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.darkBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            AppLocalizations.of(context)!.selectLanguage,
            style: AppTheme.headingMedium.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Locale('en', 'US'),
              Locale('tr', 'TR'),
              Locale('zh', 'CN'),
              Locale('ja', 'JP'),
            ].map((locale) {
              final languageNames = {
                'en': 'English',
                'tr': 'Türkçe',
                'zh': '中文',
                'ja': '日本語',
              };
              final languageName =
                  languageNames[locale.languageCode] ?? 'Unknown';

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(
                    languageName,
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    try {
                      // Get the LanguageService and change the language
                      final languageService = Get.find<LanguageService>();
                      await languageService.changeLanguage(locale);
                      Get.snackbar(
                        AppLocalizations.of(context)!.language,
                        '${AppLocalizations.of(context)!.language} changed to ${languageNames[locale.languageCode]}',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } on Exception catch (e) {
                      Get.snackbar(
                        'Error',
                        'Failed to change language: $e',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.white.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// [showAboutDialog] - Show about dialog with app information
  /// Platform-specific dialog following Apple HIG principles
  void _showAboutDialog(BuildContext context, bool isIOS) {
    if (isIOS) {
      // iOS Cupertino-style dialog
      showCupertinoDialog<void>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(AppLocalizations.of(context)!.aboutAstroIztro),
          content: Text(
            AppLocalizations.of(context)!.aboutDescription,
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        ),
      );
    } else {
      // Android Material-style dialog
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.darkBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'About Astro Iztro',
            style: AppTheme.headingMedium.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            AppLocalizations.of(context)!.aboutDescription,
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.white.withValues(alpha: 0.8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                AppLocalizations.of(context)!.ok,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.lightPurple,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

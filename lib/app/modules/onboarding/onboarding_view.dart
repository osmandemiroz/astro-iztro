import 'dart:math';

import 'package:astro_iztro/app/modules/onboarding/onboarding_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/core/utils/responsive_sizer.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:astro_iztro/shared/widgets/animated_gradient_background.dart';
import 'package:astro_iztro/shared/widgets/language_switcher.dart';
import 'package:astro_iztro/shared/widgets/liquid_glass_widget.dart';
import 'package:astro_iztro/shared/widgets/particle_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

/// [OnboardingView] - Beautiful onboarding experience with Apple-inspired design
/// Features smooth page transitions, modern animations, and elegant UI elements
/// Following Apple Human Interface Guidelines for seamless user experience
class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveSizer.init(context);
    return Scaffold(
      // Full-screen immersive experience with space gradient background
      body: OnboardingBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Skip button and progress indicator
              _buildTopSection(context),

              // Main content area with page view
              Expanded(
                child: _buildPageView(context),
              ),

              // Bottom navigation and action buttons
              _buildBottomSection(context),
            ],
          ),
        ),
      ),
      // Language switcher for testing i18n
      floatingActionButton: const LanguageSwitcher(),
    );
  }

  /// [buildTopSection] - Top section with skip button and progress
  /// Clean, minimal design following Apple HIG principles
  Widget _buildTopSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      child: Row(
        children: [
          // Skip button with glass effect
          Obx(
            () => controller.currentPage.value < 3
                ? LiquidGlassWidget(
                    width: ResponsiveSizer.w(17),
                    height: ResponsiveSizer.h(6),
                    child: TextButton(
                      onPressed: controller.skipOnboarding,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.defaultPadding,
                          vertical: AppConstants.smallPadding,
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.skip,
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          const Spacer(),

          // Page indicators with smooth animations
          Obx(
            () => Row(
              children: controller.getPageIndicator().asMap().entries.map((
                entry,
              ) {
                final isActive = entry.value;

                return AnimatedContainer(
                  duration: AppConstants.mediumAnimation,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: isActive
                        ? AppColors.white
                        : AppColors.white.withValues(alpha: 0.3),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// [buildPageView] - Main content area with smooth page transitions
  /// Uses PageView for fluid navigation between onboarding screens
  Widget _buildPageView(BuildContext context) {
    return PageView(
      controller: controller.pageController,
      onPageChanged: controller.onPageChanged,
      children: [
        _buildOnboardingPage(0, context),
        _buildOnboardingPage(1, context),
        _buildOnboardingPage(2, context),
        _buildOnboardingPage(3, context),
      ],
    );
  }

  /// [buildOnboardingPage] - Individual onboarding page content
  /// Each page showcases different app features with elegant animations
  Widget _buildOnboardingPage(int index, BuildContext context) {
    switch (index) {
      case 0:
        return _buildWelcomePage(context);
      case 1:
        return _buildFeaturesPage(context);
      case 2:
        return _buildAstrologyPage(context);
      case 3:
        return _buildGetStartedPage(context);
      default:
        return _buildWelcomePage(context);
    }
  }

  /// [buildWelcomePage] - First page: Welcome and app introduction
  Widget _buildWelcomePage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App logo with floating animation
          _buildAnimatedLogo(),

          const SizedBox(height: AppConstants.largePadding),

          // Welcome text with elegant typography
          Text(
            AppLocalizations.of(context)!.welcomeTitle,
            style: AppTheme.headingLarge.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          // Subtitle with glass effect
          LiquidGlassWidget(
            width: ResponsiveSizer.w(85),
            height: ResponsiveSizer.h(13),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Text(
                AppLocalizations.of(context)!.welcomeSubtitle,
                style: AppTheme.bodyLarge.copyWith(
                  color: AppColors.white,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// [buildFeaturesPage] - Second page: Key features showcase
  Widget _buildFeaturesPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Feature icons with staggered animation
          _buildFeatureIcons(context),

          const SizedBox(height: AppConstants.largePadding),

          Text(
            AppLocalizations.of(context)!.powerfulFeatures,
            style: AppTheme.headingLarge.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          // Feature list with glass cards
          _buildFeatureList(context),
        ],
      ),
    );
  }

  /// [buildAstrologyPage] - Third page: Astrology explanation
  Widget _buildAstrologyPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Astrology chart visualization
          _buildAstrologyChart(),

          const SizedBox(height: AppConstants.largePadding),

          Text(
            AppLocalizations.of(context)!.ancientWisdomTitle,
            style: AppTheme.headingLarge.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          LiquidGlassWidget(
            width: ResponsiveSizer.w(100),
            height: ResponsiveSizer.h(13),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Text(
                AppLocalizations.of(context)!.ancientWisdomSubtitle,
                style: AppTheme.bodyLarge.copyWith(
                  color: AppColors.white,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// [buildGetStartedPage] - Final page: Call to action
  Widget _buildGetStartedPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Success animation
          _buildSuccessAnimation(),

          const SizedBox(height: AppConstants.largePadding),

          Text(
            AppLocalizations.of(context)!.readyToBegin,
            style: AppTheme.headingLarge.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          LiquidGlassWidget(
            width: ResponsiveSizer.w(100),
            height: ResponsiveSizer.h(13),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Text(
                AppLocalizations.of(context)!.readyToBeginSubtitle,
                style: AppTheme.bodyLarge.copyWith(
                  color: AppColors.white,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// [buildBottomSection] - Bottom navigation and action buttons
  /// Clean, accessible design with clear call-to-action
  Widget _buildBottomSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Row(
        children: [
          // Previous button (hidden on first page)
          Obx(
            () => controller.currentPage.value > 0
                ? Expanded(
                    child: LiquidGlassWidget(
                      width: ResponsiveSizer.w(50),
                      height: ResponsiveSizer.h(6),
                      child: TextButton(
                        onPressed: controller.previousPage,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.defaultPadding,
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.previous,
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                : const Expanded(child: SizedBox.shrink()),
          ),

          const SizedBox(width: AppConstants.defaultPadding),

          // Next/Get Started button
          Expanded(
            flex: 2,
            child: Obx(
              () => LiquidGlassWidget(
                width: ResponsiveSizer.w(50),
                height: ResponsiveSizer.h(6),
                child: ElevatedButton(
                  onPressed:
                      controller.isLoading.value ? null : controller.nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primaryPurple,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.defaultPadding,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius,
                      ),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryPurple,
                            ),
                          ),
                        )
                      : Text(
                          controller.isLastPage.value
                              ? AppLocalizations.of(context)!.getStarted
                              : AppLocalizations.of(context)!.next,
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// [buildAnimatedLogo] - Animated app logo with floating effect
  /// Uses the actual app logo from assets/marketing/app_logo.png
  /// Following Apple HIG principles for brand consistency and visual hierarchy
  Widget _buildAnimatedLogo() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppConstants.longAnimation,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.white.withValues(alpha: 0.2),
                    AppColors.white.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/marketing/app_logo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to original icon if image fails to load
                    return const Icon(
                      Icons.auto_awesome,
                      size: 60,
                      color: AppColors.white,
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// [buildFeatureIcons] - Feature icons with staggered animation
  /// Uses actual app icons from assets/images/icon/ for brand consistency
  /// Following Apple HIG principles for visual hierarchy and user recognition
  Widget _buildFeatureIcons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFeatureIconWithImage(
          'assets/images/icon/ic_analyze.png',
          AppLocalizations.of(context)!.analysis,
        ),
        _buildFeatureIconWithImage(
          'assets/images/icon/ic_matcher.png',
          AppLocalizations.of(context)!.compatibility,
        ),
        _buildFeatureIconWithImage(
          'assets/images/icon/ic_tarot.png',
          AppLocalizations.of(context)!.tarot,
        ),
      ],
    );
  }

  /// [buildFeatureIconWithImage] - Individual feature icon with image asset
  /// Uses actual app icons for enhanced brand recognition and visual consistency
  /// Includes error handling with fallback to generic icons
  Widget _buildFeatureIconWithImage(String imagePath, String label) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppConstants.mediumAnimation,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Column(
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.white.withValues(alpha: 0.2),
                      AppColors.white.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    imagePath,
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to generic icon if image fails to load
                      return Icon(
                        _getFallbackIcon(label),
                        size: 40,
                        color: AppColors.white,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                label,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// [getFallbackIcon] - Get appropriate fallback icon based on feature label
  /// Ensures graceful degradation when custom icons fail to load
  IconData _getFallbackIcon(String label) {
    switch (label.toLowerCase()) {
      case 'analysis':
        return Icons.psychology;
      case 'compatibility':
        return Icons.favorite;
      case 'tarot':
        return Icons.style;
      default:
        return Icons.auto_awesome;
    }
  }

  /// [buildFeatureList] - Feature list with glass cards
  Widget _buildFeatureList(BuildContext context) {
    final features = [
      AppLocalizations.of(context)!.purpleStarCharts,
      AppLocalizations.of(context)!.baziAnalysis,
      AppLocalizations.of(context)!.compatibilityMatching,
      AppLocalizations.of(context)!.tarotReadings,
    ];

    return Column(
      children: features.asMap().entries.map((entry) {
        final index = entry.key;
        final feature = entry.value;

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 300 + (index * 100)),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(50 * (1 - value), 0),
              child: Opacity(
                opacity: value,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                    bottom: AppConstants.smallPadding,
                  ),
                  child: LiquidGlassWidget(
                    width: ResponsiveSizer.w(100),
                    height: ResponsiveSizer.h(6),
                    child: Padding(
                      padding: const EdgeInsets.all(
                        AppConstants.defaultPadding,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.white,
                            size: 20,
                          ),
                          const SizedBox(width: AppConstants.smallPadding),
                          Expanded(
                            child: Text(
                              feature,
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  /// [buildAstrologyChart] - Astrology chart visualization
  Widget _buildAstrologyChart() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppConstants.longAnimation,
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value * 2 * 3.14159,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                // Center star
                const Center(
                  child: Icon(
                    Icons.star,
                    size: 40,
                    color: AppColors.white,
                  ),
                ),
                // Orbiting elements
                ...List.generate(8, (index) {
                  final angle = (index * 45) * (3.14159 / 180);
                  const radius = 60.0;
                  final x = radius * cos(angle);
                  final y = radius * sin(angle);

                  return Positioned(
                    left: 75 + x - 10,
                    top: 75 + y - 10,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  /// [buildSuccessAnimation] - Success animation for final page
  Widget _buildSuccessAnimation() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppConstants.longAnimation,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.5 + (value * 0.5),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.white.withValues(alpha: 0.3),
                  AppColors.white.withValues(alpha: 0.1),
                ],
              ),
            ),
            child: const Icon(
              Icons.check,
              size: 60,
              color: AppColors.white,
            ),
          ),
        );
      },
    );
  }
}

/// [OnboardingBackground] - Custom background for onboarding screens
/// Provides immersive space gradient with subtle animations
class OnboardingBackground extends StatelessWidget {
  const OnboardingBackground({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated gradient background
        const AnimatedGradientBackground(
          preset: GradientPreset.cosmic,
        ),

        // Particle effects layer
        const Positioned.fill(
          child: ParticleBackground(
            particleCount: 40,
            particleColor: AppColors.white,
            particleSize: Size(1, 3),
            speed: 0.5,
          ),
        ),

        // Animated background stars (existing)
        _buildAnimatedStars(),

        // Main content
        child,
      ],
    );
  }

  /// [buildAnimatedStars] - Animated star field background
  Widget _buildAnimatedStars() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(seconds: 3),
      builder: (context, value, child) {
        return CustomPaint(
          painter: StarFieldPainter(value),
          size: Size.infinite,
        );
      },
    );
  }
}

/// [StarFieldPainter] - Custom painter for animated star field
class StarFieldPainter extends CustomPainter {
  StarFieldPainter(this.animationValue);
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    // Draw animated stars
    for (var i = 0; i < 50; i++) {
      final x = (i * 37) % size.width;
      final y = (i * 73) % size.height;
      final opacity = (sin(animationValue * 2 * 3.14159 + i) + 1) / 2;

      canvas.drawCircle(
        Offset(x, y),
        1,
        paint..color = AppColors.white.withValues(alpha: opacity * 0.8),
      );
    }
  }

  @override
  bool shouldRepaint(StarFieldPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

import 'package:astro_iztro/app/modules/analysis/analysis_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/core/models/bazi_data.dart';
import 'package:astro_iztro/core/models/chart_data.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:astro_iztro/shared/widgets/background_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'analysis_view_part1.dart';
part 'analysis_view_part2.dart';
part 'analysis_view_part3.dart';

/// [AnalysisView] - Enhanced Destiny Analysis screen
/// Beautiful, modern UI with polished design following Apple Human Interface Guidelines
/// Features enhanced visual hierarchy, intuitive navigation, and sophisticated animations
class AnalysisView extends GetView<AnalysisController> {
  const AnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildEnhancedAppBar(),
      body: DetailedAnalysisBackground(
        child: Obx(_buildBody),
      ),
      floatingActionButton: _buildEnhancedFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /// [buildEnhancedAppBar] - Modern app bar with enhanced styling
  PreferredSizeWidget _buildEnhancedAppBar() {
    return AppBar(
      title: Obx(
        () => Text(
          controller.analysisTitle,
          style: const TextStyle(
            color: AppColors.darkTextPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
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
      actions: [
        // Language toggle
        Obx(
          () => Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppColors.darkCard.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.lightPurple.withValues(alpha: 0.3),
              ),
            ),
            child: IconButton(
              onPressed: controller.toggleLanguage,
              icon: Icon(
                controller.showChineseNames.value
                    ? Icons.translate_rounded
                    : Icons.language_rounded,
                color: AppColors.lightPurple,
                size: 20,
              ),
              tooltip: 'Toggle Language',
            ),
          ),
        ),

        // Menu
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: AppColors.darkCard.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.lightPurple.withValues(alpha: 0.3),
            ),
          ),
          child: PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'refresh':
                  controller.refreshAnalysis();
                case 'export':
                  controller.exportAnalysis();
              }
            },
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: AppColors.lightPurple,
              size: 20,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'refresh',
                child: ListTile(
                  leading: const Icon(
                    Icons.refresh_rounded,
                    color: AppColors.lightPurple,
                  ),
                  title: Text(
                    'Refresh Analysis',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                  dense: true,
                ),
              ),
              PopupMenuItem(
                value: 'export',
                child: ListTile(
                  leading: const Icon(
                    Icons.share_rounded,
                    color: AppColors.lightPurple,
                  ),
                  title: Text(
                    'Export Analysis',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                  dense: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// [buildEnhancedFloatingActionButton] - Modern floating action button
  Widget _buildEnhancedFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightPurple.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: controller.hasAnalysisData
            ? controller.refreshAnalysis
            : controller.calculateAnalysis,
        backgroundColor: AppColors.lightPurple,
        foregroundColor: AppColors.white,
        elevation: 0,
        child: Obx(
          () => AnimatedSwitcher(
            duration: AppConstants.mediumAnimation,
            child: Icon(
              controller.isCalculating.value
                  ? Icons.hourglass_empty_rounded
                  : controller.hasAnalysisData
                  ? Icons.refresh_rounded
                  : Icons.auto_awesome_rounded,
              key: ValueKey(controller.isCalculating.value),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (controller.isLoading.value) {
      return _buildEnhancedLoadingState();
    }

    if (!controller.hasAnalysisData) {
      return _buildEnhancedEmptyState();
    }

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced profile summary
              _buildEnhancedProfileSummary(),

              _buildSectionDivider(),

              // Enhanced analysis type selector
              _buildEnhancedAnalysisTypeSelector(),

              _buildSectionDivider(),

              // Enhanced year selector
              _buildEnhancedYearSelector(),

              _buildSectionDivider(),

              // Enhanced fortune calculation section
              _buildEnhancedFortuneCalculation(),

              _buildSectionDivider(),

              // Element analysis
              _buildElementAnalysis(),

              _buildSectionDivider(),

              // Palace influences
              _buildPalaceInfluences(),

              _buildSectionDivider(),

              // Recommendations
              _buildRecommendations(),

              const SizedBox(height: AppConstants.largePadding),
            ],
          ),
        ),

        // Scroll to top button
        Positioned(
          bottom: 100,
          right: AppConstants.defaultPadding,
          child: _buildScrollToTopButton(),
        ),

        // Progress indicator
        Positioned(
          top: AppConstants.defaultPadding,
          right: AppConstants.defaultPadding,
          child: _buildProgressIndicator(),
        ),
      ],
    );
  }

  /// [buildEnhancedLoadingState] - Beautiful loading state with glass effect
  Widget _buildEnhancedLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated loading container
          TweenAnimationBuilder<double>(
            duration: const Duration(seconds: 2),
            tween: Tween(begin: 0, end: 1),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.darkCard.withValues(alpha: 0.8),
                        AppColors.darkCardSecondary.withValues(alpha: 0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.lightPurple.withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.lightPurple.withValues(alpha: 0.2),
                        blurRadius: 20 * value,
                        offset: Offset(0, 10 * value),
                      ),
                    ],
                  ),
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.lightPurple,
                    ),
                    strokeWidth: 3,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppConstants.defaultPadding),

          // Animated text
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0, end: 1),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Text(
                    'Analyzing Your Destiny...',
                    style: AppTheme.headingMedium.copyWith(
                      color: AppColors.darkTextPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: AppConstants.smallPadding),

          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1200),
            tween: Tween(begin: 0, end: 1),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Text(
                    'Unlocking the secrets of the stars',
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppColors.darkTextSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// [buildEnhancedEmptyState] - Inspirational empty state
  Widget _buildEnhancedEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon container
            TweenAnimationBuilder<double>(
              duration: const Duration(seconds: 2),
              tween: Tween(begin: 0, end: 1),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.5 + (0.5 * value),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.darkCard.withValues(alpha: 0.6),
                          AppColors.darkCardSecondary.withValues(alpha: 0.4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.lightPurple.withValues(alpha: 0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lightPurple.withValues(
                            alpha: 0.1 * value,
                          ),
                          blurRadius: 30 * value,
                          offset: Offset(0, 15 * value),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.psychology_rounded,
                      size: 80,
                      color: AppColors.lightPurple.withValues(alpha: 0.7),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Animated title
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween(begin: 0, end: 1),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: Text(
                      'Discover Your Destiny',
                      style: AppTheme.headingLarge.copyWith(
                        color: AppColors.darkTextPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: AppConstants.smallPadding),

            // Animated description
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1200),
              tween: Tween(begin: 0, end: 1),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: Text(
                      'Unlock the cosmic patterns that shape your life path and reveal the hidden influences of the stars',
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppColors.darkTextSecondary,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// [buildSectionDivider] - Beautiful section divider with mystical elements
  Widget _buildSectionDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.largePadding),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(seconds: 2),
        tween: Tween(begin: 0, end: 1),
        builder: (context, value, child) {
          return Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.lightPurple.withValues(alpha: 0.3 * value),
                        AppColors.lightGold.withValues(alpha: 0.3 * value),
                        AppColors.lightPurple.withValues(alpha: 0.3 * value),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.5 + (0.5 * value),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.darkCard.withValues(alpha: 0.6 * value),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.lightPurple.withValues(
                        alpha: 0.2 * value,
                      ),
                    ),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.lightPurple.withValues(alpha: 0.6 * value),
                    size: 16,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.lightPurple.withValues(alpha: 0.3 * value),
                        AppColors.lightGold.withValues(alpha: 0.3 * value),
                        AppColors.lightPurple.withValues(alpha: 0.3 * value),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// [buildScrollToTopButton] - Beautiful scroll to top button
  Widget _buildScrollToTopButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGold.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.small(
        onPressed: () {
          // Scroll to top functionality would be implemented here
          // For now, just show a snackbar
          Get.snackbar(
            'Scroll to Top',
            'This would scroll to the top of the page',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.darkCard.withValues(alpha: 0.9),
            colorText: AppColors.darkTextPrimary,
          );
        },
        backgroundColor: AppColors.lightGold,
        foregroundColor: AppColors.black,
        elevation: 0,
        child: const Icon(Icons.keyboard_arrow_up_rounded),
      ),
    );
  }

  /// [buildProgressIndicator] - Beautiful progress indicator
  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkCard.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightPurple.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.analytics_rounded,
            color: AppColors.lightPurple,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Analysis',
            style: AppTheme.caption.copyWith(
              color: AppColors.darkTextPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

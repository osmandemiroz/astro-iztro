import 'package:astro_iztro/app/modules/chart/chart_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:astro_iztro/shared/widgets/astro_chart_widget.dart';
import 'package:astro_iztro/shared/widgets/background_image_widget.dart';
import 'package:astro_iztro/shared/widgets/palace_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

/// [ChartView] - Purple Star Astrology chart display screen
/// Redesigned with modern UI following Apple Human Interface Guidelines
/// Features enhanced chart visualization, palace details, and meaning analysis
class ChartView extends GetView<ChartController> {
  const ChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: PurpleStarBackground(
        child: Obx(() => _buildBody(context)),
      ),
      floatingActionButton: _buildFloatingActionButtons(context),
    );
  }

  /// Get chart title based on language preference
  String _getChartTitle(BuildContext context) {
    return controller.showChineseNames.value
        ? '紫微斗數命盤'
        : AppLocalizations.of(context)!.purpleStarChart;
  }

  /// [buildAppBar] - Modern app bar with chart controls
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Obx(
        () => Text(
          _getChartTitle(context),
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

        // Star details toggle
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
              onPressed: controller.toggleStarDetails,
              icon: Icon(
                controller.showStarDetails.value
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                color: AppColors.lightPurple,
                size: 20,
              ),
              tooltip: 'Toggle Star Details',
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
                  controller.refreshChart();
                case 'analysis':
                  controller.navigateToAnalysis();
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
                    AppLocalizations.of(context)!.refreshChart,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                  dense: true,
                ),
              ),
              PopupMenuItem(
                value: 'analysis',
                child: ListTile(
                  leading: const Icon(
                    Icons.analytics_rounded,
                    color: AppColors.lightPurple,
                  ),
                  title: Text(
                    'Detailed Analysis',
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

  /// [buildBody] - Main chart display area with enhanced layout
  Widget _buildBody(BuildContext context) {
    if (controller.isLoading.value) {
      return _buildLoadingState(context);
    }

    if (controller.isCalculating.value) {
      return _buildCalculatingState(context);
    }

    if (!controller.hasChartData) {
      return _buildNoChartState(context);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          // Enhanced user information header
          _buildEnhancedChartHeader(context),

          const SizedBox(height: AppConstants.largePadding),

          // Main chart area with improved styling
          _buildEnhancedChartArea(context),

          const SizedBox(height: AppConstants.largePadding),

          // Palace meanings and analysis section
          _buildPalaceMeaningsSection(context),

          if (controller.hasSelectedPalace) ...[
            const SizedBox(height: AppConstants.largePadding),
            _buildEnhancedPalaceDetails(context),
          ],

          const SizedBox(height: AppConstants.largePadding),
        ],
      ),
    );
  }

  /// [buildLoadingState] - Enhanced loading state with glass effect
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
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightPurple),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            AppLocalizations.of(context)!.loadingChartData,
            style: AppTheme.headingMedium.copyWith(
              color: AppColors.darkTextPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            AppLocalizations.of(context)!.preparingCosmicBlueprint,
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// [buildCalculatingState] - Enhanced calculating state
  Widget _buildCalculatingState(BuildContext context) {
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
                color: AppColors.lightGold.withValues(alpha: 0.3),
              ),
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightGold),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            AppLocalizations.of(context)!.calculatingPurpleStarChart,
            style: AppTheme.headingMedium.copyWith(
              color: AppColors.darkTextPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            AppLocalizations.of(context)!.mappingCelestialInfluences,
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// [buildNoChartState] - Modern empty state with call-to-action
  Widget _buildNoChartState(BuildContext context) {
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
              'Unlock Your Cosmic Blueprint',
              style: AppTheme.headingLarge.copyWith(
                color: AppColors.darkTextPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              AppLocalizations.of(context)!.discoverBirthChartPatterns,
              style: AppTheme.bodyLarge.copyWith(
                color: AppColors.darkTextSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.largePadding),
            if (controller.currentProfile.value != null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lightPurple.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: controller.calculateChart,
                  icon: const Icon(Icons.auto_awesome_rounded),
                  label: Text(AppLocalizations.of(context)!.calculateChart),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightPurple,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.largePadding,
                      vertical: AppConstants.defaultPadding,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// [buildEnhancedChartHeader] - Enhanced user information header with glass effect
  Widget _buildEnhancedChartHeader(BuildContext context) {
    final profile = controller.currentProfile.value;
    if (profile == null) return const SizedBox.shrink();

    return Container(
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
          // Name with simplified styling
          Text(
            profile.name ?? 'Unknown',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.lightGold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          // Simple horizontal layout for key info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSimpleInfoChip(
                Icons.calendar_today_rounded,
                '${profile.birthDate.day}/${profile.birthDate.month}/${profile.birthDate.year}',
              ),
              _buildSimpleInfoChip(
                Icons.access_time_rounded,
                profile.formattedBirthTime,
              ),
              _buildSimpleInfoChip(
                profile.gender == 'male'
                    ? Icons.male_rounded
                    : Icons.female_rounded,
                profile.gender.capitalize ?? '',
              ),
            ],
          ),

          // Location on separate row if available
          if (profile.locationName != null &&
              profile.locationName!.isNotEmpty) ...[
            const SizedBox(height: AppConstants.smallPadding),
            _buildSimpleInfoChip(
              Icons.location_on_rounded,
              profile.locationName!,
            ),
          ],
        ],
      ),
    );
  }

  /// [buildSimpleInfoChip] - Simple, clean information chip
  Widget _buildSimpleInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.smallPadding,
        vertical: AppConstants.smallPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkBorder.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.lightPurple.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.lightPurple,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppTheme.caption.copyWith(
              color: AppColors.darkTextPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// [buildEnhancedChartArea] - Enhanced chart area with modern styling
  Widget _buildEnhancedChartArea(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
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
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Obx(
            () => Transform.scale(
              scale: controller.chartScale.value,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => showChartExplanation(context),
                child: AstroChartWidget(
                  chartData: controller.chartData.value!,
                  selectedPalaceIndex: controller.selectedPalaceIndex.value,
                  showStarDetails: controller.showStarDetails.value,
                  showChineseNames: controller.showChineseNames.value,
                  onPalaceTap: controller.selectPalace,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// [buildPalaceMeaningsSection] - Simplified palace meanings section
  Widget _buildPalaceMeaningsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.whatEachPalaceMeans,
          style: AppTheme.headingMedium.copyWith(
            color: AppColors.darkTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),

        // Simple grid layout for better readability
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: AppConstants.defaultPadding,
          mainAxisSpacing: AppConstants.defaultPadding,
          childAspectRatio: 1.1,
          children: [
            _buildSimplePalaceCard(
              context,
              AppLocalizations.of(context)!.lifePalace,
              '命宮',
              AppLocalizations.of(context)!.lifePalaceDescription,
            ),
            _buildSimplePalaceCard(
              context,
              AppLocalizations.of(context)!.siblingsPalace,
              '兄弟宮',
              AppLocalizations.of(context)!.siblingsPalaceDescription,
            ),
            _buildSimplePalaceCard(
              context,
              AppLocalizations.of(context)!.spousePalace,
              '夫妻宮',
              AppLocalizations.of(context)!.spousePalaceDescription,
            ),
            _buildSimplePalaceCard(
              context,
              AppLocalizations.of(context)!.childrenPalace,
              '子女宮',
              AppLocalizations.of(context)!.childrenPalaceDescription,
            ),
            _buildSimplePalaceCard(
              context,
              AppLocalizations.of(context)!.wealthPalace,
              '財帛宮',
              AppLocalizations.of(context)!.wealthPalaceDescription,
            ),
            _buildSimplePalaceCard(
              context,
              AppLocalizations.of(context)!.healthPalace,
              '疾厄宮',
              AppLocalizations.of(context)!.healthPalaceDescription,
            ),
            _buildSimplePalaceCard(
              context,
              AppLocalizations.of(context)!.travelPalace,
              '遷移宮',
              AppLocalizations.of(context)!.travelPalaceDescription,
            ),
            _buildSimplePalaceCard(
              context,
              AppLocalizations.of(context)!.friendsPalace,
              '奴僕宮',
              AppLocalizations.of(context)!.friendsPalaceDescription,
            ),
            _buildSimplePalaceCard(
              context,
              AppLocalizations.of(context)!.careerPalace,
              '官祿宮',
              AppLocalizations.of(context)!.careerPalaceDescription,
            ),
            _buildSimplePalaceCard(
              context,
              AppLocalizations.of(context)!.propertyPalace,
              '田宅宮',
              AppLocalizations.of(context)!.propertyPalaceDescription,
            ),
            _buildSimplePalaceCard(
              context,
              AppLocalizations.of(context)!.fortunePalace,
              '福德宮',
              AppLocalizations.of(context)!.fortunePalaceDescription,
            ),
            _buildSimplePalaceCard(
              context,
              AppLocalizations.of(context)!.parentsPalace,
              '父母宮',
              AppLocalizations.of(context)!.parentsPalaceDescription,
            ),
          ],
        ),
      ],
    );
  }

  /// [buildSimplePalaceCard] - Simple, clean palace card
  Widget _buildSimplePalaceCard(
    BuildContext context,
    String englishName,
    String chineseName,
    String description,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.darkCard.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightGold.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Palace name in English
          Text(
            englishName,
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.lightGold,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          // Chinese name
          Text(
            chineseName,
            style: AppTheme.caption.copyWith(
              color: AppColors.darkTextSecondary,
              fontFamily: AppConstants.chineseFont,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Simple description
          Text(
            description,
            style: AppTheme.caption.copyWith(
              color: AppColors.darkTextSecondary,
              height: 1.3,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// [buildEnhancedPalaceDetails] - Enhanced palace details with better styling
  Widget _buildEnhancedPalaceDetails(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: PalaceDetailCard(
        palace: controller.getSelectedPalace()!,
        stars: controller.getStarsInSelectedPalace(),
        showChineseNames: controller.showChineseNames.value,
        onClose: () => controller.selectPalace(-1),
      ),
    );
  }

  /// [buildFloatingActionButtons] - Enhanced floating action buttons with modern design
  Widget _buildFloatingActionButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Zoom in
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.lightGold.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton(
            mini: true,
            onPressed: () => controller.zoomChart(0.1),
            backgroundColor: AppColors.lightGold,
            foregroundColor: AppColors.black,
            elevation: 0,
            child: const Icon(Icons.zoom_in_rounded),
          ),
        ),

        // Reset zoom
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkBorder.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton(
            mini: true,
            onPressed: controller.resetZoom,
            backgroundColor: AppColors.darkBorder,
            foregroundColor: AppColors.darkTextPrimary,
            elevation: 0,
            child: const Icon(Icons.center_focus_strong_rounded),
          ),
        ),

        // Zoom out
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.lightGold.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton(
            mini: true,
            onPressed: () => controller.zoomChart(-0.1),
            backgroundColor: AppColors.lightGold,
            foregroundColor: AppColors.black,
            elevation: 0,
            child: const Icon(Icons.zoom_out_rounded),
          ),
        ),

        // Calculate/Refresh chart
        Container(
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
            onPressed: controller.hasChartData
                ? controller.refreshChart
                : controller.calculateChart,
            backgroundColor: AppColors.lightPurple,
            foregroundColor: AppColors.white,
            elevation: 0,
            child: Obx(
              () => AnimatedSwitcher(
                duration: AppConstants.mediumAnimation,
                child: Icon(
                  controller.isCalculating.value
                      ? Icons.hourglass_empty_rounded
                      : controller.hasChartData
                          ? Icons.refresh_rounded
                          : Icons.auto_awesome_rounded,
                  key: ValueKey(controller.isCalculating.value),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// [showChartExplanation] - Present user-friendly explanation of chart properties and star meanings
  /// Opens a beautiful bottom sheet explaining how the chart works and what colors mean
  void showChartExplanation(BuildContext context) {
    if (controller.chartData.value == null) {
      Get.snackbar(
        AppLocalizations.of(context)!.noChartData,
        AppLocalizations.of(context)!.pleaseCalculateChartFirst,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.bottomSheet<void>(
      SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.darkCard.withValues(alpha: 0.98),
                AppColors.darkCardSecondary.withValues(alpha: 0.95),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: AppColors.lightPurple.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.3),
                blurRadius: 30,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close button and drag handle
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Close button
                    GestureDetector(
                      onTap: () => Get.back<void>(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.lightPurple.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppColors.lightPurple,
                          size: 20,
                        ),
                      ),
                    ),
                    // Drag handle
                    Container(
                      width: 48,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.lightPurple.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    // Spacer to balance the layout
                    const SizedBox(width: 36),
                  ],
                ),
                const SizedBox(height: 20),

                // Main title with cosmic styling
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.lightPurple.withValues(alpha: 0.1),
                        AppColors.lightGold.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.lightPurple.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        size: 32,
                        color: AppColors.lightGold,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!
                            .understandingYourPurpleStarChart,
                        style: Get.textTheme.headlineSmall?.copyWith(
                          color: AppColors.lightGold,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!
                            .discoverHowTheStarsInfluenceYourLifePath,
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: AppColors.darkTextSecondary,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Star Colors Section
                _buildSectionHeader(
                  context,
                  AppLocalizations.of(context)!.whatStarColorsMean,
                  Icons.palette_rounded,
                  AppColors.lightGold,
                ),
                const SizedBox(height: 16),

                // Star color explanations
                _buildStarColorCard(
                  context,
                  AppLocalizations.of(context)!.purpleStars,
                  AppLocalizations.of(context)!.majorInfluences,
                  AppLocalizations.of(context)!.purpleStarsDescription,
                  AppColors.lightPurple,
                ),
                const SizedBox(height: 12),

                _buildStarColorCard(
                  context,
                  AppLocalizations.of(context)!.goldStars,
                  AppLocalizations.of(context)!.emphasisAndSelection,
                  AppLocalizations.of(context)!.goldStarsDescription,
                  AppColors.lightGold,
                ),
                const SizedBox(height: 12),

                _buildStarColorCard(
                  context,
                  AppLocalizations.of(context)!.greenStars,
                  AppLocalizations.of(context)!.supportiveInfluences,
                  AppLocalizations.of(context)!.greenStarsDescription,
                  Colors.green,
                ),
                const SizedBox(height: 12),

                _buildStarColorCard(
                  context,
                  AppLocalizations.of(context)!.redStars,
                  AppLocalizations.of(context)!.challengingInfluences,
                  AppLocalizations.of(context)!.redStarsDescription,
                  Colors.red,
                ),
                const SizedBox(height: 12),

                _buildStarColorCard(
                  context,
                  AppLocalizations.of(context)!.orangeStars,
                  AppLocalizations.of(context)!.dynamicEnergies,
                  AppLocalizations.of(context)!.orangeStarsDescription,
                  Colors.orange,
                ),
                const SizedBox(height: 12),

                _buildStarColorCard(
                  context,
                  AppLocalizations.of(context)!.yellowStars,
                  AppLocalizations.of(context)!.illuminationAndWisdom,
                  AppLocalizations.of(context)!.yellowStarsDescription,
                  Colors.yellow,
                ),

                const SizedBox(height: 24),

                // Chart Properties Section
                _buildSectionHeader(
                  context,
                  AppLocalizations.of(context)!.howPropertiesAreCalculated,
                  Icons.calculate_rounded,
                  AppColors.lightPurple,
                ),
                const SizedBox(height: 16),

                // Calculation explanation cards
                _buildCalculationCard(
                  context,
                  AppLocalizations.of(context)!.birthDataAnalysis,
                  AppLocalizations.of(context)!.birthDataAnalysisDescription,
                  Icons.calendar_today_rounded,
                ),
                const SizedBox(height: 12),

                _buildCalculationCard(
                  context,
                  AppLocalizations.of(context)!.palaceDetermination,
                  AppLocalizations.of(context)!.palaceDeterminationDescription,
                  Icons.grid_on_rounded,
                ),
                const SizedBox(height: 12),

                _buildCalculationCard(
                  context,
                  AppLocalizations.of(context)!.starPlacement,
                  AppLocalizations.of(context)!.starPlacementDescription,
                  Icons.star_rounded,
                ),
                const SizedBox(height: 12),

                _buildCalculationCard(
                  context,
                  AppLocalizations.of(context)!.transformationStars,
                  AppLocalizations.of(context)!.transformationStarsDescription,
                  Icons.transform_rounded,
                ),

                const SizedBox(height: 24),

                // Personal Characteristics Section
                _buildSectionHeader(
                  context,
                  AppLocalizations.of(context)!.howYouAreCalculated,
                  Icons.person_rounded,
                  AppColors.lightGold,
                ),
                const SizedBox(height: 16),

                // Personal characteristics explanation cards
                _buildPersonalCharacteristicCard(
                  context,
                  AppLocalizations.of(context)!.corePersonality,
                  AppLocalizations.of(context)!.corePersonalityDescription,
                  Icons.psychology_rounded,
                ),
                const SizedBox(height: 12),

                _buildPersonalCharacteristicCard(
                  context,
                  AppLocalizations.of(context)!.lifeStrengths,
                  AppLocalizations.of(context)!.lifeStrengthsDescription,
                  Icons.star_rounded,
                ),
                const SizedBox(height: 12),

                _buildPersonalCharacteristicCard(
                  context,
                  AppLocalizations.of(context)!.lifeChallenges,
                  AppLocalizations.of(context)!.lifeChallengesDescription,
                  Icons.trending_up_rounded,
                ),
                const SizedBox(height: 12),

                _buildPersonalCharacteristicCard(
                  context,
                  AppLocalizations.of(context)!.destinyPath,
                  AppLocalizations.of(context)!.destinyPathDescription,
                  Icons.explore_rounded,
                ),

                const SizedBox(height: 24),

                // Interactive Elements Section
                _buildSectionHeader(
                  context,
                  AppLocalizations.of(context)!.howToReadYourChart,
                  Icons.touch_app_rounded,
                  AppColors.lightGold,
                ),
                const SizedBox(height: 16),

                _buildInteractiveTipCard(
                  context,
                  AppLocalizations.of(context)!.tapOnPalaceTip,
                  Icons.touch_app_rounded,
                ),
                const SizedBox(height: 12),

                _buildInteractiveTipCard(
                  context,
                  AppLocalizations.of(context)!.useZoomControlsTip,
                  Icons.zoom_in_rounded,
                ),
                const SizedBox(height: 12),

                _buildInteractiveTipCard(
                  context,
                  AppLocalizations.of(context)!.toggleLanguageTip,
                  Icons.translate_rounded,
                ),

                const SizedBox(height: 24),

                // Chart Summary
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.lightPurple.withValues(alpha: 0.1),
                        AppColors.lightGold.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.lightPurple.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.yourChartSummary,
                        style: Get.textTheme.titleMedium?.copyWith(
                          color: AppColors.lightGold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildSummaryChip(
                            context,
                            '${controller.chartData.value!.palaces.length} ${AppLocalizations.of(context)!.palaces}',
                          ),
                          _buildSummaryChip(
                            context,
                            '${controller.chartData.value!.stars.length} ${AppLocalizations.of(context)!.stars}',
                          ),
                          _buildSummaryChip(
                            context,
                            '${controller.chartData.value!.majorStars.length} ${AppLocalizations.of(context)!.major}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  /// [buildSectionHeader] - Beautiful section header with icon and color
  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Get.textTheme.titleLarge?.copyWith(
            color: AppColors.darkTextPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  /// [buildStarColorCard] - Beautiful card explaining star colors
  Widget _buildStarColorCard(
    BuildContext context,
    String title,
    String subtitle,
    String description,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Color indicator
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Get.textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: AppColors.lightGold,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkTextSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// [buildCalculationCard] - Beautiful card explaining calculation steps
  Widget _buildCalculationCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightPurple.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.lightPurple.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.lightPurple,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Get.textTheme.titleMedium?.copyWith(
                    color: AppColors.darkTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkTextSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// [buildInteractiveTipCard] - Beautiful card with interactive tips
  Widget _buildInteractiveTipCard(
    BuildContext context,
    String tip,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightGold.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.lightGold,
            size: 20,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              tip,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppColors.darkTextPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// [buildPersonalCharacteristicCard] - Beautiful card explaining personal characteristics
  Widget _buildPersonalCharacteristicCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightGold.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.lightGold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.lightGold,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Get.textTheme.titleMedium?.copyWith(
                    color: AppColors.lightGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkTextSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// [buildSummaryChip] - Beautiful summary chip
  Widget _buildSummaryChip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightPurple.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightPurple.withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        label,
        style: Get.textTheme.bodyMedium?.copyWith(
          color: AppColors.lightPurple,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

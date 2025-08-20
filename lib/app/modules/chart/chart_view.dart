import 'package:astro_iztro/app/modules/chart/chart_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:astro_iztro/shared/widgets/astro_chart_widget.dart';
import 'package:astro_iztro/shared/widgets/background_image_widget.dart';
import 'package:astro_iztro/shared/widgets/palace_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// [ChartView] - Purple Star Astrology chart display screen
/// Redesigned with modern UI following Apple Human Interface Guidelines
/// Features enhanced chart visualization, palace details, and meaning analysis
class ChartView extends GetView<ChartController> {
  const ChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: PurpleStarBackground(
        child: Obx(_buildBody),
      ),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

  /// [buildAppBar] - Modern app bar with chart controls
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Obx(
        () => Text(
          controller.chartTitle,
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
                case 'export':
                  controller.exportChart();
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
                    'Refresh Chart',
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
                    'Export Chart',
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
  Widget _buildBody() {
    if (controller.isLoading.value) {
      return _buildLoadingState();
    }

    if (controller.isCalculating.value) {
      return _buildCalculatingState();
    }

    if (!controller.hasChartData) {
      return _buildNoChartState();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          // Enhanced user information header
          _buildEnhancedChartHeader(),

          const SizedBox(height: AppConstants.largePadding),

          // Main chart area with improved styling
          _buildEnhancedChartArea(),

          const SizedBox(height: AppConstants.largePadding),

          // Palace meanings and analysis section
          _buildPalaceMeaningsSection(),

          if (controller.hasSelectedPalace) ...[
            const SizedBox(height: AppConstants.largePadding),
            _buildEnhancedPalaceDetails(),
          ],

          const SizedBox(height: AppConstants.largePadding),
        ],
      ),
    );
  }

  /// [buildLoadingState] - Enhanced loading state with glass effect
  Widget _buildLoadingState() {
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
            'Loading Chart Data...',
            style: AppTheme.headingMedium.copyWith(
              color: AppColors.darkTextPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            'Preparing your cosmic blueprint',
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// [buildCalculatingState] - Enhanced calculating state
  Widget _buildCalculatingState() {
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
            'Calculating Purple Star Chart...',
            style: AppTheme.headingMedium.copyWith(
              color: AppColors.darkTextPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            'Mapping the celestial influences',
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// [buildNoChartState] - Modern empty state with call-to-action
  Widget _buildNoChartState() {
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
              'Discover the hidden patterns in your birth chart and understand how the stars influence your life path',
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
                  label: const Text('Calculate Chart'),
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
  Widget _buildEnhancedChartHeader() {
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
  Widget _buildEnhancedChartArea() {
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
                onTap: controller.showChartExplanation,
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
  Widget _buildPalaceMeaningsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What Each Palace Means',
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
              'Life',
              '命宮',
              'Your core personality and life path',
            ),
            _buildSimplePalaceCard(
              'Siblings',
              '兄弟宮',
              'Relationships with siblings',
            ),
            _buildSimplePalaceCard(
              'Spouse',
              '夫妻宮',
              'Marriage and partnerships',
            ),
            _buildSimplePalaceCard(
              'Children',
              '子女宮',
              'Children and creativity',
            ),
            _buildSimplePalaceCard('Wealth', '財帛宮', 'Money and resources'),
            _buildSimplePalaceCard('Health', '疾厄宮', 'Physical well-being'),
            _buildSimplePalaceCard('Travel', '遷移宮', 'Movement and change'),
            _buildSimplePalaceCard('Friends', '奴僕宮', 'Social connections'),
            _buildSimplePalaceCard('Career', '官祿宮', 'Work and reputation'),
            _buildSimplePalaceCard('Property', '田宅宮', 'Home and property'),
            _buildSimplePalaceCard('Fortune', '福德宮', 'Luck and spirituality'),
            _buildSimplePalaceCard('Parents', '父母宮', 'Family relationships'),
          ],
        ),
      ],
    );
  }

  /// [buildSimplePalaceCard] - Simple, clean palace card
  Widget _buildSimplePalaceCard(
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
  Widget _buildEnhancedPalaceDetails() {
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
  Widget _buildFloatingActionButtons() {
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
}

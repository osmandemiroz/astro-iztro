import 'package:astro_iztro/app/modules/chart/chart_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:astro_iztro/shared/widgets/astro_chart_widget.dart';
import 'package:astro_iztro/shared/widgets/palace_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// [ChartView] - Purple Star Astrology chart display screen
/// Features circular palace layout with interactive elements following Apple HIG
class ChartView extends GetView<ChartController> {
  const ChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(_buildBody),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

  /// [buildAppBar] - App bar with chart controls
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Obx(() => Text(controller.chartTitle)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        // Language toggle
        Obx(
          () => IconButton(
            onPressed: controller.toggleLanguage,
            icon: Icon(
              controller.showChineseNames.value
                  ? Icons.translate
                  : Icons.language,
              color: AppColors.primaryPurple,
            ),
            tooltip: 'Toggle Language',
          ),
        ),

        // Star details toggle
        Obx(
          () => IconButton(
            onPressed: controller.toggleStarDetails,
            icon: Icon(
              controller.showStarDetails.value
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: AppColors.primaryPurple,
            ),
            tooltip: 'Toggle Star Details',
          ),
        ),

        // Menu
        PopupMenuButton<String>(
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
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'refresh',
              child: ListTile(
                leading: Icon(Icons.refresh),
                title: Text('Refresh Chart'),
                dense: true,
              ),
            ),
            const PopupMenuItem(
              value: 'export',
              child: ListTile(
                leading: Icon(Icons.share),
                title: Text('Export Chart'),
                dense: true,
              ),
            ),
            const PopupMenuItem(
              value: 'analysis',
              child: ListTile(
                leading: Icon(Icons.analytics),
                title: Text('Detailed Analysis'),
                dense: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// [buildBody] - Main chart display area
  Widget _buildBody() {
    if (controller.isLoading.value) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryPurple,
              ),
            ),
            SizedBox(height: AppConstants.defaultPadding),
            Text('Loading chart data...'),
          ],
        ),
      );
    }

    if (controller.isCalculating.value) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGold),
            ),
            SizedBox(height: AppConstants.defaultPadding),
            Text('Calculating Purple Star chart...'),
          ],
        ),
      );
    }

    if (!controller.hasChartData) {
      return _buildNoChartState();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildChartHeader(),
          _buildChartArea(),
          if (controller.hasSelectedPalace) ...[
            const SizedBox(height: AppConstants.largePadding),
            _buildPalaceDetails(),
          ],
          const SizedBox(height: AppConstants.largePadding * 2),
        ],
      ),
    );
  }

  /// [buildNoChartState] - State when no chart data is available
  Widget _buildNoChartState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.circle_outlined,
              size: 80,
              color: AppColors.grey400,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              'No Chart Available',
              style: AppTheme.headingMedium.copyWith(
                color: AppColors.grey600,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              controller.currentProfile.value == null
                  ? 'Please create a profile first'
                  : 'Tap the calculate button to generate your Purple Star chart',
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.grey500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.largePadding),
            if (controller.currentProfile.value != null)
              ElevatedButton.icon(
                onPressed: controller.calculateChart,
                icon: const Icon(Icons.calculate),
                label: const Text('Calculate Chart'),
              ),
          ],
        ),
      ),
    );
  }

  /// [buildChartHeader] - Chart information header
  Widget _buildChartHeader() {
    final profile = controller.currentProfile.value;
    if (profile == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: AppColors.primaryPurple.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            profile.name ?? 'Unknown',
            style: AppTheme.headingMedium.copyWith(
              color: AppColors.primaryPurple,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoChip(
                Icons.calendar_today,
                '${profile.birthDate.day}/${profile.birthDate.month}/${profile.birthDate.year}',
              ),
              _buildInfoChip(
                Icons.access_time,
                profile.formattedBirthTime,
              ),
              _buildInfoChip(
                profile.gender == 'male' ? Icons.male : Icons.female,
                profile.gender.capitalize ?? '',
              ),
            ],
          ),
          if (profile.locationName != null &&
              profile.locationName!.isNotEmpty) ...[
            const SizedBox(height: AppConstants.smallPadding),
            _buildInfoChip(
              Icons.location_on,
              profile.locationName!,
            ),
          ],
        ],
      ),
    );
  }

  /// [buildInfoChip] - Small information chip widget
  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.smallPadding,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.primaryPurple,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTheme.caption.copyWith(
              color: AppColors.grey700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// [buildChartArea] - Main circular chart area
  Widget _buildChartArea() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPurple.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Obx(
            () => Transform.scale(
              scale: controller.chartScale.value,
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
    );
  }

  /// [buildPalaceDetails] - Selected palace detailed information
  Widget _buildPalaceDetails() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      child: PalaceDetailCard(
        palace: controller.getSelectedPalace()!,
        stars: controller.getStarsInSelectedPalace(),
        showChineseNames: controller.showChineseNames.value,
        onClose: () => controller.selectPalace(-1),
      ),
    );
  }

  /// [buildFloatingActionButtons] - Floating action buttons for chart controls
  Widget _buildFloatingActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Zoom in
        FloatingActionButton(
          mini: true,
          onPressed: () => controller.zoomChart(0.1),
          backgroundColor: AppColors.primaryGold,
          child: const Icon(Icons.zoom_in),
        ),
        const SizedBox(height: 8),

        // Reset zoom
        FloatingActionButton(
          mini: true,
          onPressed: controller.resetZoom,
          backgroundColor: AppColors.grey500,
          child: const Icon(Icons.center_focus_strong),
        ),
        const SizedBox(height: 8),

        // Zoom out
        FloatingActionButton(
          mini: true,
          onPressed: () => controller.zoomChart(-0.1),
          backgroundColor: AppColors.primaryGold,
          child: const Icon(Icons.zoom_out),
        ),
        const SizedBox(height: 16),

        // Calculate/Refresh chart
        FloatingActionButton(
          onPressed: controller.hasChartData
              ? controller.refreshChart
              : controller.calculateChart,
          backgroundColor: AppColors.primaryPurple,
          child: Obx(
            () => Icon(
              controller.isCalculating.value
                  ? Icons.hourglass_empty
                  : controller.hasChartData
                  ? Icons.refresh
                  : Icons.calculate,
            ),
          ),
        ),
      ],
    );
  }
}

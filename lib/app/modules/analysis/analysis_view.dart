import 'package:astro_iztro/app/modules/analysis/analysis_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/core/models/chart_data.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:astro_iztro/shared/widgets/background_image_widget.dart';
import 'package:astro_iztro/shared/widgets/element_strength_card.dart';
import 'package:astro_iztro/shared/widgets/liquid_glass_widget.dart';
import 'package:astro_iztro/shared/widgets/palace_influence_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'analysis_view_part1.dart';
part 'analysis_view_part2.dart';
part 'analysis_view_part3.dart';

/// [AnalysisView] - Detailed astrological analysis screen
/// Beautiful display of combined Purple Star and BaZi analysis
/// Enhanced with dark theme and liquid glass effects for modern UI
class AnalysisView extends GetView<AnalysisController> {
  const AnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.analysisTitle,
            style: const TextStyle(color: AppColors.darkTextPrimary),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          // Language toggle
          Obx(
            () => LiquidGlassWidget(
              glassColor: AppColors.glassPrimary,
              borderColor: AppColors.lightPurple,
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.all(8),
              child: IconButton(
                onPressed: controller.toggleLanguage,
                icon: Icon(
                  controller.showChineseNames.value
                      ? Icons.translate
                      : Icons.language,
                  color: AppColors.darkTextPrimary,
                ),
                tooltip: 'Toggle Language',
              ),
            ),
          ),

          // Menu
          LiquidGlassWidget(
            glassColor: AppColors.glassPrimary,
            borderColor: AppColors.lightPurple,
            borderRadius: BorderRadius.circular(20),
            padding: const EdgeInsets.all(8),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'refresh':
                    controller.refreshAnalysis();
                  case 'export':
                    controller.exportAnalysis();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'refresh',
                  child: ListTile(
                    leading: Icon(Icons.refresh),
                    title: Text('Refresh Analysis'),
                    dense: true,
                  ),
                ),
                const PopupMenuItem(
                  value: 'test_api',
                  child: ListTile(
                    leading: Icon(Icons.api),
                    title: Text('Test API Connection'),
                    dense: true,
                  ),
                ),
                const PopupMenuItem(
                  value: 'export',
                  child: ListTile(
                    leading: Icon(Icons.share),
                    title: Text('Export Analysis'),
                    dense: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: DetailedAnalysisBackground(
        child: Obx(_buildBody),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.hasAnalysisData
            ? controller.refreshAnalysis
            : controller.calculateAnalysis,
        backgroundColor: AppColors.lightPurple,
        foregroundColor: AppColors.white,
        child: Obx(
          () => Icon(
            controller.isCalculating.value
                ? Icons.hourglass_empty
                : controller.hasAnalysisData
                ? Icons.refresh
                : Icons.calculate,
          ),
        ),
      ),
    );
  }

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
            Text('Loading analysis data...'),
          ],
        ),
      );
    }

    if (!controller.hasAnalysisData) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.analytics_outlined,
                size: 80,
                color: AppColors.grey400,
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              Text(
                'No Analysis Available',
                style: AppTheme.headingMedium.copyWith(
                  color: AppColors.grey600,
                ),
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                'Tap the calculate button to generate your destiny analysis',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.grey500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile summary
          _buildProfileSummary(),

          const SizedBox(height: AppConstants.defaultPadding),

          // Analysis type selector
          _buildAnalysisTypeSelector(),

          const SizedBox(height: AppConstants.defaultPadding),

          // Year selector
          _buildYearSelector(),

          const SizedBox(height: AppConstants.defaultPadding),

          // Fortune cycles
          _buildFortuneCycles(),

          const SizedBox(height: AppConstants.defaultPadding),

          // Element analysis
          _buildElementAnalysis(),

          const SizedBox(height: AppConstants.defaultPadding),

          // Palace influences
          _buildPalaceInfluences(),

          const SizedBox(height: AppConstants.defaultPadding),

          // Recommendations
          _buildRecommendations(),

          const SizedBox(height: AppConstants.largePadding * 2),
        ],
      ),
    );
  }
}

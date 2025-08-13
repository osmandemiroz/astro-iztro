import 'package:astro_iztro/app/modules/palace_detail/palace_detail_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';

import 'package:astro_iztro/core/models/star_data.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// [PalaceDetailView] - Detailed palace analysis view
/// Beautiful display of palace information, stars, and analysis
class PalaceDetailView extends GetView<PalaceDetailController> {
  const PalaceDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.palaceName)),
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
          IconButton(
            onPressed: controller.toggleStarDetails,
            icon: Obx(
              () => Icon(
                controller.showStarDetails.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: AppColors.primaryPurple,
              ),
            ),
            tooltip: 'Toggle Star Details',
          ),

          // Transformations toggle
          IconButton(
            onPressed: controller.toggleTransformations,
            icon: Obx(
              () => Icon(
                controller.showTransformations.value
                    ? Icons.change_circle
                    : Icons.change_circle_outlined,
                color: AppColors.primaryPurple,
              ),
            ),
            tooltip: 'Toggle Transformations',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPalaceInfo(),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildStarList(),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildAnalysis(),
          ],
        ),
      ),
    );
  }

  Widget _buildPalaceInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.temple_buddhist_outlined,
                  color: AppColors.primaryGold,
                ),
                const SizedBox(width: AppConstants.smallPadding),
                Text(
                  controller.showChineseNames.value ? '宮位資料' : 'Palace Info',
                  style: AppTheme.headingMedium.copyWith(
                    color: AppColors.primaryPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildInfoRow(
              Icons.numbers,
              controller.showChineseNames.value ? '宮位序號' : 'Position',
              'Palace ${controller.palace.value.index + 1}',
            ),
            _buildInfoRow(
              Icons.auto_awesome,
              controller.showChineseNames.value ? '五行屬性' : 'Element',
              controller.elementName,
            ),
            _buildInfoRow(
              Icons.light_mode,
              controller.showChineseNames.value ? '明暗' : 'Brightness',
              controller.brightnessName,
            ),
            _buildInfoRow(
              Icons.star,
              controller.showChineseNames.value ? '星曜數量' : 'Star Count',
              '${controller.stars.length} ${controller.showChineseNames.value ? "顆" : "stars"}',
            ),
            _buildInfoRow(
              Icons.insights,
              controller.showChineseNames.value ? '宮位強度' : 'Strength',
              controller.palaceStrength,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primaryPurple.withValues(alpha: 0.7),
          ),
          const SizedBox(width: AppConstants.smallPadding),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.grey700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.grey900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarList() {
    return Obx(() {
      if (!controller.showStarDetails.value) return const SizedBox.shrink();

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: AppColors.primaryGold,
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Text(
                    controller.showChineseNames.value ? '星曜列表' : 'Stars',
                    style: AppTheme.headingMedium.copyWith(
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              ...controller.stars.asMap().entries.map(
                (entry) => _buildStarItem(entry.key, entry.value),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStarItem(int index, StarData star) {
    return Obx(() {
      final isSelected = controller.selectedStarIndex.value == index;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => controller.selectStar(index),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(AppConstants.smallPadding),
              decoration: BoxDecoration(
                color: isSelected
                    ? _getStarColor(star).withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getStarColor(star).withValues(
                    alpha: isSelected ? 0.3 : 0.1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getStarIcon(star),
                    color: _getStarColor(star),
                    size: 20,
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.getStarName(star),
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            fontFamily: controller.showChineseNames.value
                                ? AppConstants.chineseFont
                                : AppConstants.primaryFont,
                          ),
                        ),
                        Text(
                          controller.getStarCategory(star),
                          style: AppTheme.caption.copyWith(
                            color: _getStarColor(star),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (star.transformationType != null &&
                      controller.showTransformations.value)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        controller.getTransformationType(star),
                        style: AppTheme.caption.copyWith(
                          color: AppColors.primaryGold,
                          fontFamily: controller.showChineseNames.value
                              ? AppConstants.chineseFont
                              : AppConstants.primaryFont,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (isSelected) ...[
            const SizedBox(height: AppConstants.smallPadding),
            Padding(
              padding: const EdgeInsets.only(
                left: AppConstants.defaultPadding,
                bottom: AppConstants.smallPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Star influence
                  Text(
                    controller.getStarInfluence(star),
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppColors.grey700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppConstants.smallPadding),

                  // Star strength
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStarColor(star).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      controller.getStarStrength(star),
                      style: AppTheme.caption.copyWith(
                        color: _getStarColor(star),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.smallPadding),

                  // Star recommendations
                  if (controller.getStarRecommendations(star).isNotEmpty) ...[
                    Text(
                      controller.showChineseNames.value
                          ? '建議'
                          : 'Recommendations',
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...controller
                        .getStarRecommendations(star)
                        .map(
                          (rec) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• '),
                                Expanded(
                                  child: Text(
                                    rec,
                                    style: AppTheme.bodyMedium.copyWith(
                                      color: AppColors.grey700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ],

                  // Star transformations
                  if (star.transformationType != null &&
                      controller.showTransformations.value) ...[
                    const SizedBox(height: AppConstants.smallPadding),
                    Text(
                      controller.showChineseNames.value
                          ? '化氣'
                          : 'Transformations',
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...controller
                        .getStarTransformations(star)
                        .entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGold.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    entry.key,
                                    style: AppTheme.caption.copyWith(
                                      color: AppColors.primaryGold,
                                      fontFamily:
                                          controller.showChineseNames.value
                                          ? AppConstants.chineseFont
                                          : AppConstants.primaryFont,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    entry.value,
                                    style: AppTheme.bodyMedium.copyWith(
                                      color: AppColors.grey700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ],
                ],
              ),
            ),
          ],
          if (index < controller.stars.length - 1)
            const Divider(color: AppColors.grey200),
        ],
      );
    });
  }

  Widget _buildAnalysis() {
    return Obx(() {
      if (!controller.showAnalysis.value) return const SizedBox.shrink();

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.analytics_outlined,
                    color: AppColors.primaryGold,
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Text(
                    controller.showChineseNames.value ? '宮位分析' : 'Analysis',
                    style: AppTheme.headingMedium.copyWith(
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              Text(
                controller.palaceAnalysisSummary,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.grey800,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Color _getStarColor(StarData star) {
    if (star.isMajorStar) return AppColors.primaryPurple;
    if (star.isLuckyStar) return Colors.green;
    if (star.isUnluckyStar) return Colors.red;
    if (star.isTransformation) return AppColors.primaryGold;
    return AppColors.grey500;
  }

  IconData _getStarIcon(StarData star) {
    if (star.isMajorStar) return Icons.star;
    if (star.isLuckyStar) return Icons.star_border;
    if (star.isUnluckyStar) return Icons.star_half;
    if (star.isTransformation) return Icons.change_circle_outlined;
    return Icons.star_outline;
  }
}

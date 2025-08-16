part of 'analysis_view.dart';

/// Palace influences and recommendations widgets
extension AnalysisViewPart3 on AnalysisView {
  Widget _buildPalaceInfluences() {
    final chartData = controller.chartData.value!;

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
            color: AppColors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced header with icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.lightPurple.withValues(alpha: 0.3),
                  ),
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: AppColors.lightPurple,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Text(
                'Palace Influences',
                style: AppTheme.headingMedium.copyWith(
                  color: AppColors.lightPurple,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          // Palace cards with enhanced spacing
          ...chartData.palaces.map(
            (palace) => Padding(
              padding: const EdgeInsets.only(
                bottom: AppConstants.defaultPadding,
              ),
              child: PalaceInfluenceCard(
                palace: palace,
                stars: chartData.getStarsInPalace(palace.name),
                showChineseNames: controller.showChineseNames.value,
                onTap:
                    ({
                      required PalaceData palace,
                      required List<StarData> stars,
                      required bool showChineseNames,
                    }) {
                      Get.toNamed<void>(
                        '/palace_detail',
                        arguments: {
                          'palace': palace,
                          'stars': stars,
                          'showChineseNames': showChineseNames,
                        },
                      );
                    },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    final baziData = controller.baziData.value!;
    if (baziData.recommendations.isEmpty) return const SizedBox.shrink();

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
          color: AppColors.lightGold.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced header with icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightGold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.lightGold.withValues(alpha: 0.3),
                  ),
                ),
                child: const Icon(
                  Icons.lightbulb_rounded,
                  color: AppColors.lightGold,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Text(
                'Life Recommendations',
                style: AppTheme.headingMedium.copyWith(
                  color: AppColors.lightGold,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          // Enhanced recommendations list
          ...baziData.recommendations.map(
            (rec) => Container(
              margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              decoration: BoxDecoration(
                color: AppColors.darkBorder.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.lightGold.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.lightGold,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: AppConstants.defaultPadding),
                  Expanded(
                    child: Text(
                      rec,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppColors.darkTextPrimary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

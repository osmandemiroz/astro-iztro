part of 'analysis_view.dart';

/// Palace influences and recommendations widgets
extension AnalysisViewPart3 on AnalysisView {
  Widget _buildPalaceInfluences() {
    final chartData = controller.chartData.value!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Palace Influences',
              style: AppTheme.headingMedium.copyWith(
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            ...chartData.palaces.map(
              (palace) => _buildPalaceInfluence(palace),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPalaceInfluence(PalaceData palace) {
    final stars = controller.chartData.value!.getStarsInPalace(palace.name);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                controller.showChineseNames.value ? palace.nameZh : palace.name,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFamily: controller.showChineseNames.value
                      ? AppConstants.chineseFont
                      : AppConstants.primaryFont,
                ),
              ),
              const SizedBox(width: AppConstants.smallPadding),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${stars.length} stars',
                  style: AppTheme.caption.copyWith(
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            palace.analysis['description'] as String,
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.grey700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    final baziData = controller.baziData.value!;
    if (baziData.recommendations.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.primaryGold,
                ),
                const SizedBox(width: AppConstants.smallPadding),
                Text(
                  'Recommendations',
                  style: AppTheme.headingMedium.copyWith(
                    color: AppColors.primaryPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            ...baziData.recommendations.map(
              (rec) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(
                      child: Text(
                        rec,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppColors.grey800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

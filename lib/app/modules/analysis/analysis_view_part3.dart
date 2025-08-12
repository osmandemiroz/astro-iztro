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
              (palace) => Column(
                children: [
                  PalaceInfluenceCard(
                    palace: palace,
                    stars: controller.chartData.value!.getStarsInPalace(
                      palace.name,
                    ),
                    showChineseNames: controller.showChineseNames.value,
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                ],
              ),
            ),
          ],
        ),
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

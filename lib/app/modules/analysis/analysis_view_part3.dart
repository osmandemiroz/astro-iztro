part of 'analysis_view.dart';

/// Palace influences and recommendations widgets
extension AnalysisViewPart3 on AnalysisView {
  Widget _buildPalaceInfluences() {
    final chartData = controller.chartData.value!;
    return Column(
      children: [
        ...chartData.palaces.map(
          (palace) => PalaceInfluenceCard(
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
      ],
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

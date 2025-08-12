part of 'analysis_view.dart';

/// Fortune cycles and element analysis widgets
extension AnalysisViewPart2 on AnalysisView {
  Widget _buildFortuneCycles() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fortune Cycles',
              style: AppTheme.headingMedium.copyWith(
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            FutureBuilder<Map<String, dynamic>>(
              future: controller.calculateFortuneForYear(
                controller.selectedYear.value,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error calculating fortune: ${snapshot.error}',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  );
                }

                final fortune = snapshot.data!;
                return Column(
                  children: [
                    FortuneCycleCard(
                      cycleName: controller.getFortuneCycleName('grand_limit'),
                      cycleValue: fortune['grand_limit'] as String,
                      cycleDescription:
                          'Major life cycle influencing long-term destiny',
                      strength: 0.9,
                      showChineseNames: controller.showChineseNames.value,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    FortuneCycleCard(
                      cycleName: controller.getFortuneCycleName('small_limit'),
                      cycleValue: fortune['small_limit'] as String,
                      cycleDescription:
                          'Minor cycle affecting specific life areas',
                      strength: 0.7,
                      showChineseNames: controller.showChineseNames.value,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    FortuneCycleCard(
                      cycleName: controller.getFortuneCycleName(
                        'annual_fortune',
                      ),
                      cycleValue: fortune['annual_fortune'] as String,
                      cycleDescription: 'Yearly influences and opportunities',
                      strength: 0.8,
                      showChineseNames: controller.showChineseNames.value,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    FortuneCycleCard(
                      cycleName: controller.getFortuneCycleName(
                        'monthly_fortune',
                      ),
                      cycleValue: fortune['monthly_fortune'] as String,
                      cycleDescription: 'Monthly trends and energies',
                      strength: 0.6,
                      showChineseNames: controller.showChineseNames.value,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    FortuneCycleCard(
                      cycleName: controller.getFortuneCycleName(
                        'daily_fortune',
                      ),
                      cycleValue: fortune['daily_fortune'] as String,
                      cycleDescription: 'Daily activities and decisions',
                      strength: 0.5,
                      showChineseNames: controller.showChineseNames.value,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElementAnalysis() {
    final baziData = controller.baziData.value!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Element Analysis',
              style: AppTheme.headingMedium.copyWith(
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            ...baziData.elementCounts.entries.map(
              (entry) => ElementStrengthCard(
                element: entry.key,
                count: entry.value,
                maxCount: baziData.elementCounts.values.reduce(
                  (a, b) => a > b ? a : b,
                ),
                showChineseNames: controller.showChineseNames.value,
                description: _getElementDescription(entry.key),
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Strongest: ${baziData.strongestElement}',
                        style: AppTheme.bodyMedium.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Weakest: ${baziData.weakestElement}',
                        style: AppTheme.bodyMedium.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Balance: ${baziData.elementBalanceScore}%',
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getElementDescription(String element) {
    switch (element) {
      case '木':
        return 'Wood element represents growth, flexibility, and creativity. It influences career development and family relationships.';
      case '火':
        return 'Fire element symbolizes passion, energy, and transformation. It affects reputation, leadership, and emotional expression.';
      case '土':
        return 'Earth element embodies stability, nourishment, and reliability. It impacts education, property, and self-cultivation.';
      case '金':
        return 'Metal element signifies clarity, precision, and determination. It relates to wealth, authority, and children.';
      case '水':
        return 'Water element reflects wisdom, adaptability, and communication. It governs career, travel, and intellectual pursuits.';
      default:
        return 'Element influences various aspects of life and destiny.';
    }
  }
}

// ignore_for_file: avoid_dynamic_calls, document_ignores

part of 'analysis_view.dart';

/// Fortune cycles and element analysis widgets
extension AnalysisViewPart2 on AnalysisView {
  Widget _buildFortuneCycles() {
    return Obx(() {
      if (controller.isCalculating.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline,
                size: 64,
                color: AppColors.grey400,
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              Text(
                'Fortune calculation in progress...',
                style: AppTheme.bodyLarge.copyWith(
                  color: AppColors.grey600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                'Please wait while we calculate your fortune for ${controller.selectedYear.value}',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.grey500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      // Check if we have fortune data for the selected year
      final fortuneData = controller.fortuneData.value;
      if (fortuneData == null || fortuneData.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  size: 64,
                  color: AppColors.primaryPurple,
                ),
                const SizedBox(height: AppConstants.defaultPadding),
                Text(
                  'Ready to Calculate Fortune',
                  style: AppTheme.bodyLarge.copyWith(
                    color: AppColors.grey600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppConstants.smallPadding),
                Text(
                  'Tap the button below to calculate your fortune for ${controller.selectedYear.value}',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppColors.grey500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.defaultPadding),
                ElevatedButton.icon(
                  onPressed: () => controller.calculateFortuneForSelectedYear(),
                  icon: const Icon(Icons.calculate),
                  label: const Text('Calculate Fortune'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Display fortune data
      return _buildFortuneDataDisplay(fortuneData);
    });
  }

  Widget _buildFortuneDataDisplay(Map<String, dynamic> fortuneData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fortune Analysis for ${controller.selectedYear.value}',
          style: AppTheme.headingSmall.copyWith(
            color: AppColors.primaryPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),

        // Life Periods
        if (fortuneData['lifePeriods'] != null)
          _buildFortuneCard(
            'Life Period',
            (fortuneData['lifePeriods']['currentPeriod'] as String?) ??
                'Unknown',
            (fortuneData['lifePeriods']['description'] as String?) ??
                'No description available',
            Icons.person_outline,
          ),

        // Grand Limit
        if (fortuneData['grandLimit'] != null)
          _buildFortuneCard(
            'Grand Limit Cycle',
            (fortuneData['grandLimit']['cycleName'] as String?) ?? 'Unknown',
            (fortuneData['grandLimit']['description'] as String?) ??
                'No description available',
            Icons.timeline,
          ),

        // Small Limit
        if (fortuneData['smallLimit'] != null)
          _buildFortuneCard(
            'Small Limit Cycle',
            (fortuneData['smallLimit']['cycleName'] as String?) ?? 'Unknown',
            (fortuneData['smallLimit']['description'] as String?) ??
                'No description available',
            Icons.schedule,
          ),

        // Annual Fortune
        if (fortuneData['annualFortune'] != null)
          _buildFortuneCard(
            'Annual Fortune',
            fortuneData['annualFortune']['overallRating']?.toString() ??
                'Unknown',
            (fortuneData['annualFortune']['summary'] as String?) ??
                'No summary available',
            Icons.star,
          ),

        // Refresh button
        const SizedBox(height: AppConstants.defaultPadding),
        Center(
          child: ElevatedButton.icon(
            onPressed: () => controller.calculateFortuneForSelectedYear(),
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh Fortune'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFortuneCard(
    String title,
    String value,
    String description,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primaryPurple,
              size: 32,
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppColors.primaryPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppColors.grey600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElementAnalysis() {
    final baziData = controller.baziData.value!;
    return ElementStrengthCard(
      elementCounts: baziData.elementCounts,
      strongestElement: baziData.strongestElement,
      weakestElement: baziData.weakestElement,
      balanceScore: baziData.elementBalanceScore,
      showChineseNames: controller.showChineseNames.value,
    );
  }
}

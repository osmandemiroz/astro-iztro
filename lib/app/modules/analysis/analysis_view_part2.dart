part of 'analysis_view.dart';

/// Fortune cycles and element analysis widgets
extension AnalysisViewPart2 on AnalysisView {
  Widget _buildFortuneCycles() {
    return FutureBuilder<Map<String, dynamic>>(
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
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 48,
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    'Error calculating fortune:',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    '${snapshot.error}',
                    style: AppTheme.caption.copyWith(
                      color: AppColors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  ElevatedButton(
                    onPressed: () {
                      // Trigger a rebuild to retry
                      controller.refreshAnalysis();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // Safely handle the fortune data with additional type checking
        final fortuneData = snapshot.data;
        if (fortuneData == null) {
          return Center(
            child: Text(
              'No fortune data available',
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.grey600,
              ),
            ),
          );
        }

        // Filter and safely convert fortune data
        final safeCycles = <String, String>{};

        // Only include fortune-related keys and safely convert values
        const fortuneKeys = [
          'grand_limit',
          'small_limit',
          'annual_fortune',
          'monthly_fortune',
          'daily_fortune',
        ];

        for (final key in fortuneKeys) {
          if (fortuneData.containsKey(key)) {
            final value = fortuneData[key];
            if (value != null) {
              safeCycles[key] = value.toString();
            } else {
              safeCycles[key] = 'No data available';
            }
          }
        }

        // If no fortune data was extracted, show a fallback message
        if (safeCycles.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.grey600,
                    size: 48,
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    'Fortune calculation in progress...',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    'Please wait while we calculate your fortune for ${controller.selectedYear.value}',
                    style: AppTheme.caption.copyWith(
                      color: AppColors.grey500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return FortuneCycleCard(
          cycles: safeCycles,
          showChineseNames: controller.showChineseNames.value,
          selectedYear: controller.selectedYear.value,
          onYearSelected: controller.selectYear,
        );
      },
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

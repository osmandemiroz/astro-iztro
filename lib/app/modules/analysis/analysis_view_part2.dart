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
                    _buildFortuneCycle(
                      'grand_limit',
                      fortune['grand_limit'] as String,
                    ),
                    _buildFortuneCycle(
                      'small_limit',
                      fortune['small_limit'] as String,
                    ),
                    _buildFortuneCycle(
                      'annual_fortune',
                      fortune['annual_fortune'] as String,
                    ),
                    _buildFortuneCycle(
                      'monthly_fortune',
                      fortune['monthly_fortune'] as String,
                    ),
                    _buildFortuneCycle(
                      'daily_fortune',
                      fortune['daily_fortune'] as String,
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

  Widget _buildFortuneCycle(String cycle, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              controller.getFortuneCycleName(cycle),
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.grey700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.grey900,
                fontFamily: controller.showChineseNames.value
                    ? AppConstants.chineseFont
                    : AppConstants.primaryFont,
              ),
            ),
          ),
        ],
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
              (entry) => _buildElementBar(
                entry.key,
                entry.value,
                baziData.elementCounts.values.reduce(
                  (a, b) => a > b ? a : b,
                ),
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

  Widget _buildElementBar(String element, int count, int maxCount) {
    final strength = count / maxCount;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              element,
              style: AppTheme.bodyMedium.copyWith(
                fontFamily: AppConstants.chineseFont,
                fontWeight: FontWeight.bold,
                color: controller.getElementColor(element, strength),
              ),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: strength,
              backgroundColor: AppColors.grey200,
              valueColor: AlwaysStoppedAnimation<Color>(
                controller.getElementColor(element, strength),
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 30,
            child: Text(
              count.toString(),
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            controller.getFortuneStrength(strength),
            style: AppTheme.caption.copyWith(
              color: controller.getElementColor(element, strength),
            ),
          ),
        ],
      ),
    );
  }
}

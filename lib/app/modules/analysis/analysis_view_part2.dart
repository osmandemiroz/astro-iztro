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
            child: Text(
              'Error calculating fortune: ${snapshot.error}',
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.error,
              ),
            ),
          );
        }

        return FortuneCycleCard(
          cycles: snapshot.data!.map(
            (key, value) => MapEntry(key, value as String),
          ),
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

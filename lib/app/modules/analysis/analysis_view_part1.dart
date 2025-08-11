part of 'analysis_view.dart';

/// Profile summary and analysis type selector widgets
extension AnalysisViewPart1 on AnalysisView {
  Widget _buildProfileSummary() {
    final profile = controller.currentProfile.value!;
    final baziData = controller.baziData.value!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            Text(
              profile.name ?? 'Unknown',
              style: AppTheme.headingMedium.copyWith(
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              baziData.baziString,
              style: AppTheme.bodyLarge.copyWith(
                fontFamily: controller.showChineseNames.value
                    ? AppConstants.chineseFont
                    : AppConstants.monoFont,
                color: AppColors.primaryGold,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildInfoChip(
                  Icons.calendar_today,
                  '${profile.birthDate.day}/${profile.birthDate.month}/${profile.birthDate.year}',
                ),
                const SizedBox(width: AppConstants.smallPadding),
                _buildInfoChip(
                  Icons.access_time,
                  profile.formattedBirthTime,
                ),
                const SizedBox(width: AppConstants.smallPadding),
                _buildInfoChip(
                  Icons.star_border,
                  '${baziData.chineseZodiac} • ${baziData.westernZodiac}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.smallPadding,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.primaryPurple,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTheme.caption.copyWith(
              color: AppColors.grey700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisTypeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.smallPadding),
        child: Row(
          children: [
            _buildAnalysisTypeButton('yearly', 'Yearly'),
            _buildAnalysisTypeButton('monthly', 'Monthly'),
            _buildAnalysisTypeButton('daily', 'Daily'),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisTypeButton(String type, String label) {
    return Expanded(
      child: Obx(
        () {
          final isSelected = controller.selectedAnalysisType.value == type;
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.smallPadding / 2,
            ),
            child: TextButton(
              onPressed: () => controller.selectAnalysisType(type),
              style: TextButton.styleFrom(
                backgroundColor: isSelected
                    ? AppColors.primaryPurple
                    : AppColors.grey100,
                foregroundColor: isSelected
                    ? AppColors.white
                    : AppColors.grey700,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(label),
            ),
          );
        },
      ),
    );
  }

  Widget _buildYearSelector() {
    final currentYear = DateTime.now().year;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Year',
              style: AppTheme.headingSmall.copyWith(
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  10,
                  (index) {
                    final year = currentYear + index - 5;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Obx(
                        () {
                          final isSelected =
                              controller.selectedYear.value == year;
                          return OutlinedButton(
                            onPressed: () => controller.selectYear(year),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? AppColors.primaryGold
                                  : AppColors.white,
                              foregroundColor: isSelected
                                  ? AppColors.white
                                  : AppColors.primaryGold,
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.primaryGold
                                    : AppColors.grey300,
                              ),
                            ),
                            child: Text(year.toString()),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

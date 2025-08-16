part of 'analysis_view.dart';

/// Profile summary and analysis type selector widgets
extension AnalysisViewPart1 on AnalysisView {
  Widget _buildEnhancedProfileSummary() {
    final profile = controller.currentProfile.value!;
    final baziData = controller.baziData.value!;

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
            color: AppColors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Animated name with enhanced styling
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: Text(
                  profile.name ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.lightGold,
                    letterSpacing: 1,
                    shadows: [
                      Shadow(
                        color: AppColors.lightGold.withValues(
                          alpha: 0.3 * value,
                        ),
                        blurRadius: 10 * value,
                        offset: Offset(0, 4 * value),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          // BaZi characters with enhanced typography
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: AppConstants.smallPadding,
            ),
            decoration: BoxDecoration(
              color: AppColors.lightGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.lightGold.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              baziData.baziString,
              style: TextStyle(
                fontFamily: controller.showChineseNames.value
                    ? AppConstants.chineseFont
                    : AppConstants.monoFont,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.lightGold,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          // Information chips in a grid layout
          Row(
            children: [
              Expanded(
                child: _buildEnhancedInfoChip(
                  Icons.calendar_today_rounded,
                  '${profile.birthDate.day}/${profile.birthDate.month}/${profile.birthDate.year}',
                ),
              ),
              const SizedBox(width: AppConstants.smallPadding),
              Expanded(
                child: _buildEnhancedInfoChip(
                  Icons.access_time_rounded,
                  profile.formattedBirthTime,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.smallPadding),

          Row(
            children: [
              Expanded(
                child: _buildEnhancedInfoChip(
                  Icons.auto_awesome_rounded,
                  '${baziData.chineseZodiac} • ${baziData.westernZodiac}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.darkBorder.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightPurple.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: AppColors.lightPurple,
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.darkTextPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedAnalysisTypeSelector() {
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
      child: Row(
        children: [
          _buildEnhancedAnalysisTypeButton('yearly', 'Yearly'),
          _buildEnhancedAnalysisTypeButton('monthly', 'Monthly'),
          _buildEnhancedAnalysisTypeButton('daily', 'Daily'),
        ],
      ),
    );
  }

  Widget _buildEnhancedAnalysisTypeButton(String type, String label) {
    return Expanded(
      child: Obx(
        () {
          final isSelected = controller.selectedAnalysisType.value == type;
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.smallPadding / 2,
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isSelected
                      ? [
                          AppColors.lightPurple,
                          AppColors.primaryPurple,
                        ]
                      : [
                          AppColors.darkBorder.withValues(alpha: 0.3),
                          AppColors.darkBorder.withValues(alpha: 0.2),
                        ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppColors.lightPurple
                      : AppColors.lightPurple.withValues(alpha: 0.2),
                ),
              ),
              child: TextButton(
                onPressed: () => controller.selectAnalysisType(type),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: isSelected
                      ? AppColors.white
                      : AppColors.darkTextSecondary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedYearSelector() {
    final currentYear = DateTime.now().year;
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
          Text(
            'Select Year',
            style: AppTheme.headingMedium.copyWith(
              color: AppColors.lightGold,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                10,
                (index) {
                  final year = currentYear + index - 5;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Obx(
                      () {
                        final isSelected =
                            controller.selectedYear.value == year;
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isSelected
                                  ? [
                                      AppColors.lightGold,
                                      AppColors.primaryGold,
                                    ]
                                  : [
                                      AppColors.darkBorder.withValues(
                                        alpha: 0.3,
                                      ),
                                      AppColors.darkBorder.withValues(
                                        alpha: 0.2,
                                      ),
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.lightGold
                                  : AppColors.lightGold.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => controller.selectYear(year),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                child: Text(
                                  year.toString(),
                                  style: TextStyle(
                                    color: isSelected
                                        ? AppColors.black
                                        : AppColors.darkTextSecondary,
                                    fontWeight: isSelected
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
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
    );
  }
}

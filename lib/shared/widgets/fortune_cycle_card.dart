import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:flutter/material.dart';

/// [FortuneCycleCard] - Beautiful card displaying fortune cycle information
/// Shows grand limit, small limit, annual, monthly, and daily fortune
class FortuneCycleCard extends StatelessWidget {
  const FortuneCycleCard({
    required this.cycles,
    required this.showChineseNames,
    required this.selectedYear,
    required this.onYearSelected,
    super.key,
  });

  final Map<String, String> cycles;
  final bool showChineseNames;
  final int selectedYear;
  final ValueChanged<int> onYearSelected;

  @override
  Widget build(BuildContext context) {
    // Get the available size from the context
    final size = MediaQuery.of(context).size;
    final maxWidth = size.width * 0.95; // Use 95% of screen width

    return SizedBox(
      width: maxWidth,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.cyclone,
                    color: AppColors.primaryGold,
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Text(
                    showChineseNames ? '運程分析' : 'Fortune Cycles',
                    style: AppTheme.headingMedium.copyWith(
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              _buildYearSelector(),
              const SizedBox(height: AppConstants.defaultPadding),
              ...cycles.entries.map(
                (entry) => _buildCycleRow(entry.key, entry.value),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYearSelector() {
    final currentYear = DateTime.now().year;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          showChineseNames ? '選擇年份' : 'Select Year',
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
                  child: OutlinedButton(
                    onPressed: () => onYearSelected(year),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: year == selectedYear
                          ? AppColors.primaryGold
                          : AppColors.white,
                      foregroundColor: year == selectedYear
                          ? AppColors.white
                          : AppColors.primaryGold,
                      side: BorderSide(
                        color: year == selectedYear
                            ? AppColors.primaryGold
                            : AppColors.grey300,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: Text(year.toString()),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCycleRow(String cycle, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.smallPadding),
        decoration: BoxDecoration(
          color: _getCycleColor(cycle).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _getCycleColor(cycle).withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: Text(
                _getCycleName(cycle),
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
                  fontFamily: showChineseNames
                      ? AppConstants.chineseFont
                      : AppConstants.primaryFont,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCycleColor(String cycle) {
    switch (cycle) {
      case 'grand_limit':
        return AppColors.primaryPurple;
      case 'small_limit':
        return AppColors.primaryGold;
      case 'annual_fortune':
        return Colors.green;
      case 'monthly_fortune':
        return Colors.blue;
      case 'daily_fortune':
        return Colors.orange;
      default:
        return AppColors.grey500;
    }
  }

  String _getCycleName(String cycle) {
    final names = {
      'grand_limit': showChineseNames ? '大限' : 'Grand Limit',
      'small_limit': showChineseNames ? '小限' : 'Small Limit',
      'annual_fortune': showChineseNames ? '流年' : 'Annual Fortune',
      'monthly_fortune': showChineseNames ? '流月' : 'Monthly Fortune',
      'daily_fortune': showChineseNames ? '流日' : 'Daily Fortune',
    };
    return names[cycle] ?? cycle;
  }
}

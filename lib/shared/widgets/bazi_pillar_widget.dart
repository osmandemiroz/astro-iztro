import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/core/models/bazi_data.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:flutter/material.dart';

/// [BaZiPillarWidget] - Individual pillar display widget
/// Beautiful representation of a single pillar with stem and branch
class BaZiPillarWidget extends StatelessWidget {
  const BaZiPillarWidget({
    required this.pillar,
    required this.pillarIndex,
    required this.isSelected,
    required this.showChineseNames,
    required this.onTap,
    super.key,
  });
  final PillarData pillar;
  final int pillarIndex;
  final bool isSelected;
  final bool showChineseNames;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.shortAnimation,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGold.withValues(alpha: 0.1)
              : AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(
            color: isSelected ? AppColors.primaryGold : AppColors.grey300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryGold.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.all(AppConstants.smallPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Stem
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getElementColor(pillar.stemElement),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  pillar.stem,
                  style: AppTheme.headingSmall.copyWith(
                    color: AppColors.white,
                    fontFamily: AppConstants.chineseFont,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 4),

            // Branch
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getElementColor(pillar.branchElement),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  pillar.branch,
                  style: AppTheme.headingSmall.copyWith(
                    color: AppColors.white,
                    fontFamily: AppConstants.chineseFont,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppConstants.smallPadding),

            // Elements
            Text(
              '${pillar.stemElement}/${pillar.branchElement}',
              style: AppTheme.caption.copyWith(
                color: isSelected ? AppColors.primaryGold : AppColors.grey600,
                fontWeight: FontWeight.w500,
              ),
            ),

            if (showChineseNames) ...[
              const SizedBox(height: 2),
              Text(
                '${pillar.stemEn}/${pillar.branchEn}',
                style: AppTheme.caption.copyWith(
                  fontSize: 10,
                  color: AppColors.grey500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Get color for element
  Color _getElementColor(String element) {
    switch (element) {
      case '木':
        return Colors.green;
      case '火':
        return Colors.red;
      case '土':
        return Colors.brown;
      case '金':
        return Colors.grey;
      case '水':
        return Colors.blue;
      default:
        return AppColors.grey500;
    }
  }
}

import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/core/models/chart_data.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:flutter/material.dart';

/// [PalaceInfluenceCard] - Beautiful card displaying palace influence
/// Shows palace name, stars, and analysis with visual indicators
class PalaceInfluenceCard extends StatelessWidget {
  const PalaceInfluenceCard({
    required this.palace,
    required this.stars,
    required this.showChineseNames,
    this.onTap,
    super.key,
  });
  final PalaceData palace;
  final List<StarData> stars;
  final bool showChineseNames;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.white,
                _getPalaceColor().withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Palace name and star count
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getPalaceColor(),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          palace.index.toString(),
                          style: AppTheme.headingSmall.copyWith(
                            color: AppColors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.smallPadding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            showChineseNames ? palace.nameZh : palace.name,
                            style: AppTheme.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              fontFamily: showChineseNames
                                  ? AppConstants.chineseFont
                                  : AppConstants.primaryFont,
                            ),
                          ),
                          Text(
                            '${stars.length} stars',
                            style: AppTheme.caption.copyWith(
                              color: AppColors.grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getPalaceColor().withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: _getPalaceColor().withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        palace.element,
                        style: AppTheme.caption.copyWith(
                          color: _getPalaceColor(),
                          fontWeight: FontWeight.w600,
                          fontFamily: AppConstants.chineseFont,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.smallPadding),

                // Star chips
                if (stars.isNotEmpty) ...[
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: stars.map(_buildStarChip).toList(),
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                ],

                // Analysis
                Text(
                  palace.analysis['description'] as String,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppColors.grey700,
                  ),
                ),

                if (palace.analysis['interpretation'] != null) ...[
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    palace.analysis['interpretation'] as String,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppColors.grey600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStarChip(StarData star) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _getStarColor(star).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: _getStarColor(star).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getStarColor(star),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            showChineseNames ? star.name : star.nameEn,
            style: AppTheme.caption.copyWith(
              color: _getStarColor(star),
              fontWeight: FontWeight.w500,
              fontFamily: showChineseNames
                  ? AppConstants.chineseFont
                  : AppConstants.primaryFont,
            ),
          ),
          if (star.transformationType != null) ...[
            const SizedBox(width: 4),
            Text(
              '(${star.transformationType!})',
              style: AppTheme.caption.copyWith(
                color: AppColors.primaryGold,
                fontWeight: FontWeight.w500,
                fontFamily: AppConstants.chineseFont,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getPalaceColor() {
    switch (palace.element) {
      case '木':
        return Colors.green;
      case '火':
        return Colors.red;
      case '土':
        return Colors.brown;
      case '金':
        return Colors.grey.shade600;
      case '水':
        return Colors.blue;
      default:
        return AppColors.primaryPurple;
    }
  }

  Color _getStarColor(StarData star) {
    switch (star.category) {
      case '主星':
        return AppColors.primaryPurple;
      case '吉星':
        return Colors.green;
      case '凶星':
        return Colors.red;
      default:
        return AppColors.grey500;
    }
  }
}

import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/core/models/chart_data.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:flutter/material.dart';

/// [PalaceInfluenceCard] - Beautiful card displaying palace influences
/// Shows palace name, stars, and analysis in a modern design
class PalaceInfluenceCard extends StatelessWidget {
  const PalaceInfluenceCard({
    required this.palace,
    required this.stars,
    required this.showChineseNames,
    required this.onTap,
    super.key,
  });

  final PalaceData palace;
  final List<StarData> stars;
  final bool showChineseNames;
  final void Function({
    required PalaceData palace,
    required List<StarData> stars,
    required bool showChineseNames,
  })
  onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => onTap(
          palace: palace,
          stars: stars,
          showChineseNames: showChineseNames,
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildPalaceName(),
                  const SizedBox(width: AppConstants.smallPadding),
                  _buildStarCount(),
                  const Spacer(),
                  _buildPalaceElement(),
                ],
              ),
              if (stars.isNotEmpty) ...[
                const SizedBox(height: AppConstants.smallPadding),
                _buildStarList(),
              ],
              const SizedBox(height: AppConstants.smallPadding),
              _buildAnalysis(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPalaceName() {
    return Text(
      showChineseNames ? palace.nameZh : palace.name,
      style: AppTheme.bodyLarge.copyWith(
        fontWeight: FontWeight.w600,
        fontFamily: showChineseNames
            ? AppConstants.chineseFont
            : AppConstants.primaryFont,
      ),
    );
  }

  Widget _buildStarCount() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryPurple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${stars.length} ${showChineseNames ? '星' : 'stars'}',
        style: AppTheme.caption.copyWith(
          color: AppColors.primaryPurple,
        ),
      ),
    );
  }

  Widget _buildPalaceElement() {
    if (palace.element.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: _getElementColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        showChineseNames ? _getElementChinese() : palace.element,
        style: AppTheme.caption.copyWith(
          color: _getElementColor(),
          fontFamily: showChineseNames
              ? AppConstants.chineseFont
              : AppConstants.primaryFont,
        ),
      ),
    );
  }

  Widget _buildStarList() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: stars.map(_buildStarChip).toList(),
    );
  }

  Widget _buildStarChip(StarData star) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _getStarColor(star).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getStarColor(star).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStarIcon(star),
            size: 16,
            color: _getStarColor(star),
          ),
          const SizedBox(width: 4),
          Text(
            showChineseNames ? star.name : star.nameEn,
            style: AppTheme.caption.copyWith(
              color: _getStarColor(star),
              fontFamily: showChineseNames
                  ? AppConstants.chineseFont
                  : AppConstants.primaryFont,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysis() {
    final description = palace.analysis['description'] as String;
    if (description.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppConstants.smallPadding),
      decoration: BoxDecoration(
        color: AppColors.ultraLightPurple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primaryPurple.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        description,
        style: AppTheme.bodyMedium.copyWith(
          color: AppColors.grey700,
        ),
      ),
    );
  }

  Color _getElementColor() {
    switch (palace.element.toLowerCase()) {
      case 'wood':
        return Colors.green;
      case 'fire':
        return Colors.red;
      case 'earth':
        return Colors.orange;
      case 'metal':
        return Colors.grey;
      case 'water':
        return Colors.blue;
      default:
        return AppColors.grey500;
    }
  }

  String _getElementChinese() {
    final elements = {
      'wood': '木',
      'fire': '火',
      'earth': '土',
      'metal': '金',
      'water': '水',
    };
    return elements[palace.element.toLowerCase()] ?? palace.element;
  }

  Color _getStarColor(StarData star) {
    if (star.isMajorStar) return AppColors.primaryPurple;
    if (star.isLuckyStar) return Colors.green;
    if (star.isUnluckyStar) return Colors.red;
    if (star.isTransformation) return AppColors.primaryGold;
    return AppColors.grey500;
  }

  IconData _getStarIcon(StarData star) {
    if (star.isMajorStar) return Icons.star;
    if (star.isLuckyStar) return Icons.star_border;
    if (star.isUnluckyStar) return Icons.star_half;
    if (star.isTransformation) return Icons.change_circle_outlined;
    return Icons.star_outline;
  }
}

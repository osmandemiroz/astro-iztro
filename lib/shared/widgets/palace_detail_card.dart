import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/core/models/chart_data.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:flutter/material.dart';

/// [PalaceDetailCard] - Detailed information card for selected palace
/// Beautiful card with palace info, stars, and analysis following Apple HIG
class PalaceDetailCard extends StatelessWidget {
  const PalaceDetailCard({
    required this.palace,
    required this.stars,
    required this.showChineseNames,
    required this.onClose,
    super.key,
  });
  final PalaceData palace;
  final List<StarData> stars;
  final bool showChineseNames;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    // Get the available size from the context
    final size = MediaQuery.of(context).size;
    final maxWidth = size.width * 0.95; // Use 95% of screen width
    final maxHeight = size.height * 0.8; // Use 80% of screen height

    return SizedBox(
      width: maxWidth,
      height: maxHeight,
      child: Card(
        elevation: AppConstants.cardElevation * 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.white,
                AppColors.ultraLightPurple.withValues(alpha: 0.3),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildPalaceInfo(),
              if (stars.isNotEmpty) _buildStarsList(),
              _buildAnalysis(),
            ],
          ),
        ),
      ),
    );
  }

  /// [buildHeader] - Palace detail card header with title and close button
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConstants.borderRadius),
          topRight: Radius.circular(AppConstants.borderRadius),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.palette_outlined,
            color: AppColors.white,
            size: 24,
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  showChineseNames ? palace.nameZh : palace.name,
                  style: AppTheme.headingSmall.copyWith(
                    color: AppColors.white,
                    fontFamily: showChineseNames
                        ? AppConstants.chineseFont
                        : AppConstants.primaryFont,
                  ),
                ),
                Text(
                  '${showChineseNames ? palace.name : palace.nameZh} Palace',
                  style: AppTheme.caption.copyWith(
                    color: AppColors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(
              Icons.close,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// [buildPalaceInfo] - Basic palace information
  Widget _buildPalaceInfo() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Palace Information',
            style: AppTheme.headingSmall.copyWith(
              color: AppColors.primaryPurple,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),

          _buildInfoRow(
            Icons.numbers,
            'Position',
            'Palace ${palace.index + 1}',
          ),

          _buildInfoRow(
            Icons.auto_awesome,
            'Element',
            palace.element.isNotEmpty ? palace.element : 'Unknown',
          ),

          _buildInfoRow(
            Icons.light_mode,
            'Brightness',
            palace.brightness.isNotEmpty ? palace.brightness : 'Neutral',
          ),

          if (palace.starNames.isNotEmpty)
            _buildInfoRow(
              Icons.star_outline,
              'Star Count',
              '${palace.starNames.length} stars',
            ),
        ],
      ),
    );
  }

  /// [buildInfoRow] - Information row with icon, label, and value
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primaryPurple.withValues(alpha: 0.7),
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Text(
            '$label:',
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.grey700,
            ),
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: Text(
              value,
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.grey900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// [buildStarsList] - List of stars in this palace
  Widget _buildStarsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: AppColors.grey200),
          const SizedBox(height: AppConstants.smallPadding),

          Text(
            'Stars in Palace',
            style: AppTheme.headingSmall.copyWith(
              color: AppColors.primaryPurple,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),

          ...stars.map(_buildStarItem),

          const SizedBox(height: AppConstants.smallPadding),
        ],
      ),
    );
  }

  /// [buildStarItem] - Individual star item
  Widget _buildStarItem(StarData star) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      padding: const EdgeInsets.all(AppConstants.smallPadding),
      decoration: BoxDecoration(
        color: _getStarBackgroundColor(star),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getStarBorderColor(star),
        ),
      ),
      child: Row(
        children: [
          // Star indicator
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _getStarColor(star),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppConstants.smallPadding),

          // Star name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  showChineseNames ? star.name : star.nameEn,
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontFamily: showChineseNames
                        ? AppConstants.chineseFont
                        : AppConstants.primaryFont,
                  ),
                ),
                if (star.brightness.isNotEmpty)
                  Text(
                    'Brightness: ${star.brightness}',
                    style: AppTheme.caption.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
              ],
            ),
          ),

          // Transformation indicator
          if (star.transformationType != null) ...[
            const SizedBox(width: AppConstants.smallPadding),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryGold.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                star.transformationType!,
                style: AppTheme.caption.copyWith(
                  color: AppColors.primaryGold,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppConstants.chineseFont,
                ),
              ),
            ),
          ],

          // Star category
          const SizedBox(width: AppConstants.smallPadding),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _getStarColor(star).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              star.category,
              style: AppTheme.caption.copyWith(
                color: _getStarColor(star),
                fontWeight: FontWeight.w500,
                fontFamily: AppConstants.chineseFont,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// [buildAnalysis] - Palace analysis section
  Widget _buildAnalysis() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: AppColors.grey200),
          const SizedBox(height: AppConstants.smallPadding),

          Text(
            'Analysis',
            style: AppTheme.headingSmall.copyWith(
              color: AppColors.primaryPurple,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (palace.analysis['description'] != null) ...[
                  Text(
                    'Description:',
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    palace.analysis['description'] as String,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppColors.grey800,
                    ),
                  ),
                ],

                if (palace.analysis['interpretation'] != null) ...[
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    'Interpretation:',
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    palace.analysis['interpretation'] as String,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppColors.grey800,
                    ),
                  ),
                ],

                // Show star influences
                if (stars.isNotEmpty) ...[
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    'Star Influences:',
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _generateStarInfluenceText(),
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppColors.grey800,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Generate text describing star influences in this palace
  String _generateStarInfluenceText() {
    final majorStars = stars.where((s) => s.isMajorStar).length;
    final luckyStars = stars.where((s) => s.isLuckyStar).length;
    final unluckyStars = stars.where((s) => s.isUnluckyStar).length;
    final transformationStars = stars.where((s) => s.isTransformation).length;

    var influence = '';

    if (majorStars > 0) {
      influence +=
          'This palace has $majorStars major star${majorStars > 1 ? 's' : ''}, indicating strong significance. ';
    }

    if (luckyStars > unluckyStars) {
      influence +=
          'The presence of $luckyStars lucky star${luckyStars > 1 ? 's' : ''} brings positive energy. ';
    } else if (unluckyStars > luckyStars) {
      influence +=
          'The $unluckyStars challenging star${unluckyStars > 1 ? 's' : ''} suggest areas needing attention. ';
    }

    if (transformationStars > 0) {
      influence +=
          "There ${transformationStars > 1 ? 'are' : 'is'} $transformationStars transformation star${transformationStars > 1 ? 's' : ''} enhancing this palace's energy.";
    }

    return influence.isNotEmpty
        ? influence
        : 'This palace shows balanced energy with moderate influence.';
  }

  /// Get star color based on category
  Color _getStarColor(StarData star) {
    switch (star.category) {
      case '主星':
        return AppColors.primaryPurple;
      case '吉星':
        return AppColors.success;
      case '凶星':
        return AppColors.error;
      default:
        return AppColors.grey500;
    }
  }

  /// Get star background color
  Color _getStarBackgroundColor(StarData star) {
    return _getStarColor(star).withValues(alpha: 0.05);
  }

  /// Get star border color
  Color _getStarBorderColor(StarData star) {
    return _getStarColor(star).withValues(alpha: 0.2);
  }
}

import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:flutter/material.dart';

/// [ElementStrengthCard] - Beautiful card displaying element strength analysis
/// Shows element distribution, balance, and recommendations
class ElementStrengthCard extends StatelessWidget {
  const ElementStrengthCard({
    required this.elementCounts,
    required this.strongestElement,
    required this.weakestElement,
    required this.balanceScore,
    required this.showChineseNames,
    super.key,
  });

  final Map<String, int> elementCounts;
  final String strongestElement;
  final String weakestElement;
  final int balanceScore;
  final bool showChineseNames;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.water_drop_outlined,
                  color: AppColors.primaryGold,
                ),
                const SizedBox(width: AppConstants.smallPadding),
                Text(
                  showChineseNames ? '五行分析' : 'Element Analysis',
                  style: AppTheme.headingMedium.copyWith(
                    color: AppColors.primaryPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            ...elementCounts.entries.map(
              (entry) => _buildElementBar(
                entry.key,
                entry.value,
                elementCounts.values.reduce((a, b) => a > b ? a : b),
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildElementSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildElementBar(String element, int count, int maxCount) {
    final strength = count / maxCount;
    final color = _getElementColor(element, strength);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              showChineseNames ? _getElementChinese(element) : element,
              style: AppTheme.bodyMedium.copyWith(
                fontFamily: showChineseNames
                    ? AppConstants.chineseFont
                    : AppConstants.primaryFont,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: strength,
                backgroundColor: AppColors.grey200,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 8,
              ),
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
            _getStrengthText(strength),
            style: AppTheme.caption.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildElementSummary() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.smallPadding),
      decoration: BoxDecoration(
        color: AppColors.ultraLightPurple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primaryPurple.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                showChineseNames ? '最強五行：' : 'Strongest: ',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.grey700,
                ),
              ),
              Text(
                showChineseNames
                    ? _getElementChinese(strongestElement)
                    : strongestElement,
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                  fontFamily: showChineseNames
                      ? AppConstants.chineseFont
                      : AppConstants.primaryFont,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                showChineseNames ? '最弱五行：' : 'Weakest: ',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.grey700,
                ),
              ),
              Text(
                showChineseNames
                    ? _getElementChinese(weakestElement)
                    : weakestElement,
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontFamily: showChineseNames
                      ? AppConstants.chineseFont
                      : AppConstants.primaryFont,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                showChineseNames ? '平衡指數：' : 'Balance: ',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.grey700,
                ),
              ),
              Text(
                '$balanceScore%',
                style: AppTheme.bodyMedium.copyWith(
                  color: _getBalanceColor(balanceScore),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getElementColor(String element, double strength) {
    if (strength >= 0.8) return Colors.green;
    if (strength >= 0.6) return Colors.lightGreen;
    if (strength >= 0.4) return Colors.orange;
    if (strength >= 0.2) return Colors.red;
    return Colors.grey;
  }

  String _getStrengthText(double strength) {
    if (strength >= 0.8) {
      return showChineseNames ? '非常強' : 'Very Strong';
    }
    if (strength >= 0.6) {
      return showChineseNames ? '強' : 'Strong';
    }
    if (strength >= 0.4) {
      return showChineseNames ? '中等' : 'Moderate';
    }
    if (strength >= 0.2) {
      return showChineseNames ? '弱' : 'Weak';
    }
    return showChineseNames ? '非常弱' : 'Very Weak';
  }

  Color _getBalanceColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.lightGreen;
    if (score >= 40) return Colors.orange;
    if (score >= 20) return Colors.red;
    return Colors.grey;
  }

  String _getElementChinese(String element) {
    final elements = {
      'Wood': '木',
      'Fire': '火',
      'Earth': '土',
      'Metal': '金',
      'Water': '水',
    };
    return elements[element] ?? element;
  }
}

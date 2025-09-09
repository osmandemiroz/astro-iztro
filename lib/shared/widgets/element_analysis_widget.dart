import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:flutter/material.dart';

/// [ElementAnalysisWidget] - Five elements analysis visualization
/// Beautiful display of element distribution and balance
class ElementAnalysisWidget extends StatelessWidget {
  const ElementAnalysisWidget({
    required this.elementCounts,
    required this.strongestElement,
    required this.weakestElement,
    required this.missingElements,
    required this.showChineseNames,
    super.key,
  });
  final Map<String, int> elementCounts;
  final String strongestElement;
  final String weakestElement;
  final List<String> missingElements;
  final bool showChineseNames;

  @override
  Widget build(BuildContext context) {
    // Get the available size from the context
    final size = MediaQuery.of(context).size;
    final maxWidth = size.width * 0.95; // Use 95% of screen width

    return SizedBox(
      width: maxWidth,
      child: Card(
        elevation: AppConstants.cardElevation,
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Five Elements Analysis',
                style: AppTheme.headingMedium.copyWith(
                  color: AppColors.primaryPurple,
                ),
              ),
              const SizedBox(height: AppConstants.defaultPadding),

              // Element bars
              ...elementCounts.entries.map(
                (entry) => _buildElementBar(entry.key, entry.value),
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              // Summary
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryChip(
                      'Strongest',
                      strongestElement,
                      Colors.green,
                      Icons.trending_up,
                    ),
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Expanded(
                    child: _buildSummaryChip(
                      'Weakest',
                      weakestElement,
                      Colors.red,
                      Icons.trending_down,
                    ),
                  ),
                ],
              ),

              if (missingElements.isNotEmpty) ...[
                const SizedBox(height: AppConstants.smallPadding),
                _buildSummaryChip(
                  'Missing',
                  missingElements.join(', '),
                  Colors.orange,
                  Icons.warning_amber,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildElementBar(String element, int count) {
    final maxCount = elementCounts.values.isEmpty
        ? 1
        : elementCounts.values.reduce((a, b) => a > b ? a : b);
    final percentage = count / maxCount;

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
                color: _getElementColor(element),
              ),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: AppColors.grey200,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getElementColor(element),
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
        ],
      ),
    );
  }

  Widget _buildSummaryChip(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.smallPadding),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.caption.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: AppTheme.bodyMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getElementColor(String element) {
    switch (element) {
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
        return AppColors.grey500;
    }
  }
}

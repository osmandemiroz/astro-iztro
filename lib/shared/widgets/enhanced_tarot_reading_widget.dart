/// [EnhancedTarotReadingWidget] - Enhanced tarot reading display widget
/// Provides beautiful, organized display of tarot reading results with actionable guidance
/// Follows Apple Human Interface Guidelines for modern, sleek design and excellent UX
library;

import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:astro_iztro/shared/widgets/liquid_glass_widget.dart';
import 'package:flutter/material.dart';

/// [EnhancedTarotReadingWidget] - Displays enhanced tarot reading results
class EnhancedTarotReadingWidget extends StatelessWidget {
  const EnhancedTarotReadingWidget({
    required this.readingData,
    required this.onClearReading,
    super.key,
  });

  final Map<String, dynamic> readingData;
  final VoidCallback onClearReading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: AppColors.lightPurple.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: AppConstants.defaultPadding),
          _buildReadingContent(),
          const SizedBox(height: AppConstants.defaultPadding),
          _buildActionButtons(),
        ],
      ),
    );
  }

  /// [_buildHeader] - Build the reading header with mystical styling
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.lightPurple.withValues(alpha: 0.1),
            AppColors.lightGold.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.borderRadius),
          topRight: Radius.circular(AppConstants.borderRadius),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.auto_awesome,
            color: AppColors.lightPurple,
            size: 24,
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: Text(
              'Enhanced Tarot Reading',
              style: AppTheme.headingSmall.copyWith(
                color: AppColors.darkTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: onClearReading,
            icon: const Icon(
              Icons.refresh,
              color: AppColors.lightPurple,
              size: 20,
            ),
            tooltip: 'New Reading',
          ),
        ],
      ),
    );
  }

  /// [_buildReadingContent] - Build the main reading content sections
  Widget _buildReadingContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question display
          _buildSection(
            'Your Question',
            Icons.question_mark,
            (readingData['question'] as String?) ?? 'No question provided',
            AppColors.lightPurple,
          ),
          const SizedBox(height: AppConstants.defaultPadding),

          // Reading type
          _buildSection(
            'Reading Type',
            Icons.style,
            _formatReadingType((readingData['readingType'] as String?) ?? ''),
            AppColors.lightGold,
          ),
          const SizedBox(height: AppConstants.defaultPadding),

          // Contextual interpretation
          _buildSection(
            'Reading Interpretation',
            Icons.psychology,
            (readingData['contextualInterpretation'] as String?) ??
                'No interpretation available',
            AppColors.lightPurple,
            isExpandable: true,
          ),
          const SizedBox(height: AppConstants.defaultPadding),

          // Actionable guidance
          if (readingData['guidance'] != null) ...[
            _buildGuidanceSection(),
            const SizedBox(height: AppConstants.defaultPadding),
          ],

          // Timing insights
          if (readingData['timingInsights'] != null) ...[
            _buildTimingSection(),
            const SizedBox(height: AppConstants.defaultPadding),
          ],
        ],
      ),
    );
  }

  /// [_buildSection] - Build a content section with icon and title
  Widget _buildSection(
    String title,
    IconData icon,
    String content,
    Color accentColor, {
    bool isExpandable = false,
  }) {
    return LiquidGlassWidget(
      glassColor: AppColors.glassPrimary,
      borderColor: accentColor.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: accentColor,
                  size: 20,
                ),
                const SizedBox(width: AppConstants.smallPadding),
                Text(
                  title,
                  style: AppTheme.bodyLarge.copyWith(
                    color: AppColors.darkTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              content,
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// [_buildGuidanceSection] - Build the actionable guidance section
  Widget _buildGuidanceSection() {
    final guidance = readingData['guidance'] as Map<String, dynamic>?;
    if (guidance == null) return const SizedBox.shrink();

    return LiquidGlassWidget(
      glassColor: AppColors.glassPrimary,
      borderColor: AppColors.lightGold.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.lightbulb,
                  color: AppColors.lightGold,
                  size: 20,
                ),
                const SizedBox(width: AppConstants.smallPadding),
                Text(
                  'Actionable Guidance',
                  style: AppTheme.bodyLarge.copyWith(
                    color: AppColors.darkTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.smallPadding),
            _buildGuidanceList(
              'Actions',
              guidance['actions'],
              Icons.trending_up,
            ),
            _buildGuidanceList(
              'Affirmations',
              guidance['affirmations'],
              Icons.favorite,
            ),
            _buildGuidanceList(
              'Considerations',
              guidance['warnings'],
              Icons.warning,
            ),
            _buildGuidanceList(
              'Focus Areas',
              guidance['focusAreas'],
              Icons.center_focus_strong,
            ),
          ],
        ),
      ),
    );
  }

  /// [_buildGuidanceList] - Build a list of guidance items
  Widget _buildGuidanceList(String title, dynamic items, IconData icon) {
    if (items == null || (items as List).isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppConstants.smallPadding),
        Text(
          title,
          style: AppTheme.bodyMedium.copyWith(
            color: AppColors.lightGold,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: AppConstants.smallPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: AppColors.lightGold.withValues(alpha: 0.7),
                  size: 16,
                ),
                const SizedBox(width: AppConstants.smallPadding),
                Expanded(
                  child: Text(
                    item.toString(),
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppColors.darkTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// [_buildTimingSection] - Build the timing insights section
  Widget _buildTimingSection() {
    final timingInsights =
        readingData['timingInsights'] as Map<String, dynamic>?;
    if (timingInsights == null) return const SizedBox.shrink();

    return LiquidGlassWidget(
      glassColor: AppColors.glassPrimary,
      borderColor: AppColors.lightPurple.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.schedule,
                  color: AppColors.lightPurple,
                  size: 20,
                ),
                const SizedBox(width: AppConstants.smallPadding),
                Text(
                  'Timing Insights',
                  style: AppTheme.bodyLarge.copyWith(
                    color: AppColors.darkTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.smallPadding),
            _buildTimingList(
              'Timeframes',
              timingInsights['timeframes'],
              Icons.access_time,
            ),
            _buildTimingList(
              'Best Times',
              timingInsights['bestTimes'],
              Icons.star,
            ),
            _buildTimingList(
              'Patterns',
              timingInsights['patterns'],
              Icons.pattern,
            ),
            _buildTimingList(
              'Considerations',
              timingInsights['considerations'],
              Icons.info,
            ),
          ],
        ),
      ),
    );
  }

  /// [_buildTimingList] - Build a list of timing items
  Widget _buildTimingList(String title, dynamic items, IconData icon) {
    if (items == null || (items as List).isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppConstants.smallPadding),
        Text(
          title,
          style: AppTheme.bodyMedium.copyWith(
            color: AppColors.lightPurple,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: AppConstants.smallPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: AppColors.lightPurple.withValues(alpha: 0.7),
                  size: 16,
                ),
                const SizedBox(width: AppConstants.smallPadding),
                Expanded(
                  child: Text(
                    item.toString(),
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppColors.darkTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// [_buildActionButtons] - Build action buttons for the reading
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onClearReading,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('New Reading'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightPurple,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.defaultPadding,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// [_formatReadingType] - Format reading type for display
  String _formatReadingType(String readingType) {
    switch (readingType) {
      case 'single_card':
        return 'Single Card Reading';
      case 'three_card':
        return 'Three Card Reading (Past, Present, Future)';
      case 'celtic_cross':
        return 'Celtic Cross Reading';
      case 'horseshoe':
        return 'Horseshoe Reading';
      case 'daily_draw':
        return 'Daily Draw';
      default:
        return readingType.replaceAll('_', ' ').toUpperCase();
    }
  }
}

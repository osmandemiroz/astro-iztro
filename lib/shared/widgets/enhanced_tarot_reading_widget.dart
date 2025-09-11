/// [EnhancedTarotReadingWidget] - Enhanced tarot reading display widget
/// Provides beautiful, organized display of tarot reading results with actionable guidance
/// Follows Apple Human Interface Guidelines for modern, sleek design and excellent UX
library;

import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/core/utils/responsive_sizer.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:astro_iztro/shared/widgets/liquid_glass_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    // Initialize ResponsiveSizer
    ResponsiveSizer.init(context);

    return Container(
      width: ResponsiveSizer.w(95), // 95% of screen width
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
          Icon(
            Icons.auto_awesome,
            color: AppColors.lightPurple,
            size: ResponsiveSizer.sp(3.5), // 3.5% of screen size
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: Text(
              'Enhanced Tarot Reading',
              style: AppTheme.headingSmall.copyWith(
                color: AppColors.darkTextPrimary,
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveSizer.sp(2.8), // 2.8% of screen size
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
    final context = Get.context!;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question display
          _buildSection(
            ResponsiveSizer.w(100),
            ResponsiveSizer.h(11),
            'Your Question',
            Icons.question_mark,
            (readingData['question'] as String?) ?? 'No question provided',
            AppColors.lightPurple,
          ),
          const SizedBox(height: AppConstants.defaultPadding),

          // Reading type
          _buildSection(
            ResponsiveSizer.w(100),
            ResponsiveSizer.h(11),
            'Reading Type',
            Icons.style,
            _formatReadingType((readingData['readingType'] as String?) ?? ''),
            AppColors.lightGold,
          ),
          const SizedBox(height: AppConstants.defaultPadding),

          // Reading Interpretation Button
          LiquidGlassWidget(
            height: ResponsiveSizer.h(10),
            width: ResponsiveSizer.w(100),
            glassColor: AppColors.glassPrimary,
            borderColor: AppColors.lightPurple.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showReadingInterpretation(context),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.psychology,
                            color: AppColors.lightPurple,
                            size: ResponsiveSizer.sp(2.8),
                          ),
                          SizedBox(width: ResponsiveSizer.w(3)),
                          Text(
                            'Reading Interpretation',
                            style: AppTheme.bodyLarge.copyWith(
                              color: AppColors.darkTextPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: ResponsiveSizer.sp(2.4),
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.expand_more,
                        color: AppColors.lightPurple,
                        size: ResponsiveSizer.sp(2.8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),

          // Actionable Guidance Button
          if (readingData['guidance'] != null) ...[
            LiquidGlassWidget(
              height: ResponsiveSizer.h(10),
              width: ResponsiveSizer.w(100),
              glassColor: AppColors.glassPrimary,
              borderColor: AppColors.lightGold.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showGuidanceSheet(context),
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.lightbulb,
                              color: AppColors.lightGold,
                              size: 20,
                            ),
                            SizedBox(width: ResponsiveSizer.w(3)),
                            Text(
                              'Actionable Guidance',
                              style: AppTheme.bodyLarge.copyWith(
                                color: AppColors.darkTextPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: ResponsiveSizer.sp(2.4),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.expand_more,
                          color: AppColors.lightGold,
                          size: ResponsiveSizer.sp(2.8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
          ],

          // Timing Insights Button
          if (readingData['timingInsights'] != null) ...[
            LiquidGlassWidget(
              height: ResponsiveSizer.h(10),
              width: ResponsiveSizer.w(100),
              glassColor: AppColors.glassPrimary,
              borderColor: AppColors.lightPurple.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showTimingSheet(context),
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.schedule,
                              color: AppColors.lightPurple,
                              size: 20,
                            ),
                            SizedBox(width: ResponsiveSizer.w(3)),
                            Text(
                              'Timing Insights',
                              style: AppTheme.bodyLarge.copyWith(
                                color: AppColors.darkTextPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: ResponsiveSizer.sp(2.4),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.expand_more,
                          color: AppColors.lightPurple,
                          size: ResponsiveSizer.sp(2.8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
          ],
        ],
      ),
    );
  }

  /// [_buildSection] - Build a content section with icon and title
  Widget _buildSection(
    double width,
    double height,
    String title,
    IconData icon,
    String content,
    Color accentColor,
  ) {
    return LiquidGlassWidget(
      height: height,
      width: width,
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
                  size: ResponsiveSizer.sp(2.8), // 2.8% of screen size
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
                fontSize: ResponsiveSizer.sp(2.2), // 2.2% of screen size
              ),
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
            fontSize: ResponsiveSizer.sp(2.2), // 2.2% of screen size
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
                  size: ResponsiveSizer.sp(2.2), // 2.2% of screen size
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
                  size: ResponsiveSizer.sp(2.2), // 2.2% of screen size
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
              icon: Icon(
                Icons.refresh,
                size: ResponsiveSizer.sp(2.4),
              ), // 2.4% of screen size
              label: Text(
                'New Reading',
                style: TextStyle(
                  fontSize: ResponsiveSizer.sp(2.2),
                ), // 2.2% of screen size
              ),
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

  /// [_showReadingInterpretation] - Shows the reading interpretation in a bottom sheet
  void _showReadingInterpretation(BuildContext context) {
    final readingType = (readingData['readingType'] as String?) ?? '';
    final cards = (readingData['selectedCards'] as List<dynamic>?) ?? [];
    final question = (readingData['question'] as String?) ?? '';

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6, // Start at 60% of screen height
          minChildSize: 0.4, // Minimum 40% of screen height
          maxChildSize: 0.9, // Maximum 90% of screen height
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.borderRadius * 2),
                  topRight: Radius.circular(AppConstants.borderRadius * 2),
                ),
              ),
              child: Column(
                children: [
                  // Drag handle
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: ResponsiveSizer.h(1),
                    ),
                    width: ResponsiveSizer.w(15),
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.darkTextTertiary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Header
                  Container(
                    padding: EdgeInsets.all(ResponsiveSizer.w(4)),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.lightPurple.withValues(alpha: 0.1),
                          AppColors.lightGold.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppConstants.borderRadius * 2),
                        topRight: Radius.circular(
                          AppConstants.borderRadius * 2,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.psychology,
                          color: AppColors.lightPurple,
                          size: ResponsiveSizer.sp(2.8),
                        ),
                        SizedBox(width: ResponsiveSizer.w(3)),
                        Text(
                          'Reading Interpretation',
                          style: AppTheme.headingSmall.copyWith(
                            color: AppColors.darkTextPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: ResponsiveSizer.sp(2.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(ResponsiveSizer.w(4)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Reading type description
                          Text(
                            '"${_formatReadingType(readingType)}" - A comprehensive exploration of your question with deep insights',
                            style: AppTheme.bodyLarge.copyWith(
                              color: AppColors.lightPurple,
                              fontWeight: FontWeight.w600,
                              fontSize: ResponsiveSizer.sp(2.4),
                            ),
                          ),
                          SizedBox(height: ResponsiveSizer.h(2)),

                          // Question context
                          if (question.isNotEmpty) ...[
                            Text(
                              'Your question about ${question.toLowerCase()} reveals important insights.',
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppColors.darkTextSecondary,
                                fontSize: ResponsiveSizer.sp(2.2),
                              ),
                            ),
                            SizedBox(height: ResponsiveSizer.h(3)),
                          ],

                          // Cards interpretation
                          if (cards.isEmpty) ...[
                            Text(
                              'No cards selected',
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppColors.darkTextSecondary,
                                fontSize: ResponsiveSizer.sp(2.2),
                              ),
                            ),
                          ] else ...[
                            for (int i = 0; i < cards.length; i++)
                              Builder(
                                builder: (context) {
                                  final card = cards[i] as Map<String, dynamic>;
                                  final cardName =
                                      card['name'] as String? ?? '';
                                  final isReversed =
                                      card['is_reversed'] as bool? ?? false;
                                  final meaning = isReversed
                                      ? (card['reversed_meaning'] as String? ??
                                            '')
                                      : (card['upright_meaning'] as String? ??
                                            '');
                                  final situation =
                                      'This card suggests ${isReversed ? 'challenges or blockages' : 'opportunities and positive energy'} in relation to your question about ${question.toLowerCase()}.';

                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: i < cards.length - 1
                                          ? ResponsiveSizer.h(3)
                                          : 0,
                                    ),
                                    child: LiquidGlassWidget(
                                      height: ResponsiveSizer.h(33),
                                      glassColor: AppColors.glassPrimary,
                                      borderColor: isReversed
                                          ? AppColors.lightGold.withValues(
                                              alpha: 0.3,
                                            )
                                          : AppColors.lightPurple.withValues(
                                              alpha: 0.3,
                                            ),
                                      borderRadius: BorderRadius.circular(
                                        AppConstants.borderRadius,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(
                                          ResponsiveSizer.w(4),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  isReversed
                                                      ? Icons.rotate_right
                                                      : Icons.auto_awesome,
                                                  color: isReversed
                                                      ? AppColors.lightGold
                                                      : AppColors.lightPurple,
                                                  size: ResponsiveSizer.sp(2.8),
                                                ),
                                                SizedBox(
                                                  width: ResponsiveSizer.w(2),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '"Card ${i + 1}: $cardName"',
                                                    style: AppTheme.bodyLarge
                                                        .copyWith(
                                                          color: AppColors
                                                              .lightPurple,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              ResponsiveSizer.sp(
                                                                2.4,
                                                              ),
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: ResponsiveSizer.h(1),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: ResponsiveSizer.w(
                                                  2,
                                                ),
                                                vertical: ResponsiveSizer.h(
                                                  0.5,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    (isReversed
                                                            ? AppColors
                                                                  .lightGold
                                                            : AppColors
                                                                  .lightPurple)
                                                        .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      AppConstants.borderRadius,
                                                    ),
                                              ),
                                              child: Text(
                                                isReversed
                                                    ? 'Reversed'
                                                    : 'Upright',
                                                style: AppTheme.bodyMedium
                                                    .copyWith(
                                                      color: isReversed
                                                          ? AppColors.lightGold
                                                          : AppColors
                                                                .lightPurple,
                                                      fontSize:
                                                          ResponsiveSizer.sp(
                                                            2.2,
                                                          ),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: ResponsiveSizer.h(2),
                                            ),
                                            Text(
                                              'Meaning:',
                                              style: AppTheme.bodyMedium
                                                  .copyWith(
                                                    color:
                                                        AppColors.lightPurple,
                                                    fontSize:
                                                        ResponsiveSizer.sp(2.2),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            SizedBox(
                                              height: ResponsiveSizer.h(0.5),
                                            ),
                                            Text(
                                              meaning,
                                              style: AppTheme.bodyMedium
                                                  .copyWith(
                                                    color: AppColors
                                                        .darkTextSecondary,
                                                    fontSize:
                                                        ResponsiveSizer.sp(2.2),
                                                    height: 1.5,
                                                  ),
                                            ),
                                            SizedBox(
                                              height: ResponsiveSizer.h(2),
                                            ),
                                            Text(
                                              'In your situation:',
                                              style: AppTheme.bodyMedium
                                                  .copyWith(
                                                    color:
                                                        AppColors.lightPurple,
                                                    fontSize:
                                                        ResponsiveSizer.sp(2.2),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            SizedBox(
                                              height: ResponsiveSizer.h(0.5),
                                            ),
                                            Text(
                                              situation,
                                              style: AppTheme.bodyMedium
                                                  .copyWith(
                                                    color: AppColors
                                                        .darkTextSecondary,
                                                    fontSize:
                                                        ResponsiveSizer.sp(2.2),
                                                    height: 1.5,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// [_showGuidanceSheet] - Shows the actionable guidance in a bottom sheet
  void _showGuidanceSheet(BuildContext context) {
    final guidance = readingData['guidance'] as Map<String, dynamic>?;
    if (guidance == null) return;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.borderRadius * 2),
                  topRight: Radius.circular(AppConstants.borderRadius * 2),
                ),
              ),
              child: Column(
                children: [
                  // Drag handle
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: ResponsiveSizer.h(1),
                    ),
                    width: ResponsiveSizer.w(15),
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.darkTextTertiary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Header
                  Container(
                    padding: EdgeInsets.all(ResponsiveSizer.w(4)),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.lightGold.withValues(alpha: 0.1),
                          AppColors.lightGold.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppConstants.borderRadius * 2),
                        topRight: Radius.circular(
                          AppConstants.borderRadius * 2,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lightbulb,
                          color: AppColors.lightGold,
                          size: 20,
                        ),
                        SizedBox(width: ResponsiveSizer.w(3)),
                        Text(
                          'Actionable Guidance',
                          style: AppTheme.headingSmall.copyWith(
                            color: AppColors.darkTextPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: ResponsiveSizer.sp(2.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(ResponsiveSizer.w(4)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// [_showTimingSheet] - Shows the timing insights in a bottom sheet
  void _showTimingSheet(BuildContext context) {
    final timingInsights =
        readingData['timingInsights'] as Map<String, dynamic>?;
    if (timingInsights == null) return;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.borderRadius * 2),
                  topRight: Radius.circular(AppConstants.borderRadius * 2),
                ),
              ),
              child: Column(
                children: [
                  // Drag handle
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: ResponsiveSizer.h(1),
                    ),
                    width: ResponsiveSizer.w(15),
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.darkTextTertiary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Header
                  Container(
                    padding: EdgeInsets.all(ResponsiveSizer.w(4)),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.lightPurple.withValues(alpha: 0.1),
                          AppColors.lightPurple.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppConstants.borderRadius * 2),
                        topRight: Radius.circular(
                          AppConstants.borderRadius * 2,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          color: AppColors.lightPurple,
                          size: 20,
                        ),
                        SizedBox(width: ResponsiveSizer.w(3)),
                        Text(
                          'Timing Insights',
                          style: AppTheme.headingSmall.copyWith(
                            color: AppColors.darkTextPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: ResponsiveSizer.sp(2.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(ResponsiveSizer.w(4)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                  ),
                ],
              ),
            );
          },
        );
      },
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

// ignore_for_file: avoid_dynamic_calls, document_ignores

part of 'analysis_view.dart';

/// Fortune cycles and element analysis widgets
extension AnalysisViewPart2 on AnalysisView {
  Widget _buildEnhancedFortuneCalculation() {
    return Obx(() {
      if (controller.isCalculating.value) {
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
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.lightPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.lightPurple.withValues(alpha: 0.3),
                  ),
                ),
                child: const Icon(
                  Icons.hourglass_empty_rounded,
                  size: 64,
                  color: AppColors.lightPurple,
                ),
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              Text(
                'Calculating Your Fortune...',
                style: AppTheme.headingMedium.copyWith(
                  color: AppColors.darkTextPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                'Unlocking the secrets of ${controller.selectedYear.value}',
                style: AppTheme.bodyLarge.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      // Check if we have fortune data for the selected year
      final fortuneData = controller.fortuneData.value;
      if (fortuneData == null || fortuneData.isEmpty) {
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
              color: AppColors.lightGold.withValues(alpha: 0.2),
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
            children: [
              // Animated star icons
              TweenAnimationBuilder<double>(
                duration: const Duration(seconds: 3),
                tween: Tween(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.scale(
                        scale: 0.5 + (0.5 * value),
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          size: 32,
                          color: AppColors.lightGold.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Transform.scale(
                        scale: 0.3 + (0.7 * value),
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          size: 24,
                          color: AppColors.lightGold.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Transform.scale(
                        scale: 0.6 + (0.4 * value),
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          size: 28,
                          color: AppColors.lightGold.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              Text(
                'Ready to Calculate Fortune',
                style: AppTheme.headingMedium.copyWith(
                  color: AppColors.lightGold,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: AppConstants.smallPadding),

              Text(
                'Tap the button below to calculate your fortune',
                style: AppTheme.bodyLarge.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              Text(
                'for ${controller.selectedYear.value}',
                style: AppTheme.bodyLarge.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lightGold.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => controller.calculateFortuneForSelectedYear(),
                  icon: const Icon(Icons.auto_awesome_rounded),
                  label: const Text('Calculate Fortune'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightGold,
                    foregroundColor: AppColors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.largePadding,
                      vertical: AppConstants.defaultPadding,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      // Display fortune data
      return _buildFortuneDataDisplay(fortuneData);
    });
  }

  Widget _buildFortuneDataDisplay(Map<String, dynamic> fortuneData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fortune Analysis for ${controller.selectedYear.value}',
          style: AppTheme.headingSmall.copyWith(
            color: AppColors.primaryPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),

        // Life Periods
        if (fortuneData['lifePeriods'] != null)
          _buildFortuneCard(
            'Life Period',
            (fortuneData['lifePeriods']['currentPeriod'] as String?) ??
                'Unknown',
            (fortuneData['lifePeriods']['description'] as String?) ??
                'No description available',
            Icons.person_outline,
          ),

        // Grand Limit
        if (fortuneData['grandLimit'] != null)
          _buildFortuneCard(
            'Grand Limit Cycle',
            (fortuneData['grandLimit']['cycleName'] as String?) ?? 'Unknown',
            (fortuneData['grandLimit']['description'] as String?) ??
                'No description available',
            Icons.timeline,
          ),

        // Small Limit
        if (fortuneData['smallLimit'] != null)
          _buildFortuneCard(
            'Small Limit Cycle',
            (fortuneData['smallLimit']['cycleName'] as String?) ?? 'Unknown',
            (fortuneData['smallLimit']['description'] as String?) ??
                'No description available',
            Icons.schedule,
          ),

        // Annual Fortune
        if (fortuneData['annualFortune'] != null)
          _buildFortuneCard(
            'Annual Fortune',
            fortuneData['annualFortune']['overallRating']?.toString() ??
                'Unknown',
            (fortuneData['annualFortune']['summary'] as String?) ??
                'No summary available',
            Icons.star,
          ),

        // Enhanced refresh button
        const SizedBox(height: AppConstants.defaultPadding),
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.lightPurple.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () => controller.calculateFortuneForSelectedYear(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Refresh Fortune'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightPurple,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.largePadding,
                  vertical: AppConstants.defaultPadding,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFortuneCard(
    String title,
    String value,
    String description,
    IconData icon,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openFortuneInsight(title),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.darkCard.withValues(alpha: 0.8),
                AppColors.darkCardSecondary.withValues(alpha: 0.6),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.lightPurple.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.lightPurple.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(
                  icon,
                  color: AppColors.lightPurple,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      value,
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppColors.lightPurple,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppColors.darkTextSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildElementAnalysis() {
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
          color: AppColors.lightGold.withValues(alpha: 0.2),
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
          // Enhanced header with icon and action button
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightGold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.lightGold.withValues(alpha: 0.3),
                  ),
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  color: AppColors.lightGold,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Expanded(
                child: Text(
                  'Element Analysis',
                  style: AppTheme.headingMedium.copyWith(
                    color: AppColors.lightGold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                  vertical: AppConstants.smallPadding,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.lightPurple.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.analytics_rounded,
                      color: AppColors.lightPurple,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Analysis',
                      style: AppTheme.caption.copyWith(
                        color: AppColors.lightPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          // Custom element analysis with better readability
          _buildCustomElementAnalysis(baziData),
        ],
      ),
    );
  }

  /// [buildCustomElementAnalysis] - User-friendly element analysis display
  Widget _buildCustomElementAnalysis(BaZiData baziData) {
    final elements = [
      '木',
      '火',
      '土',
      '金',
      '水',
    ]; // Wood, Fire, Earth, Metal, Water
    final elementNames = ['Wood', 'Fire', 'Earth', 'Metal', 'Water'];

    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.darkCard.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightGold.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Element strengths section
          Text(
            'Element Strengths',
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.lightGold,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          // Individual element rows
          ...elements.asMap().entries.map((entry) {
            final index = entry.key;
            final element = entry.value;
            final elementName = elementNames[index];
            final count = baziData.elementCounts[element] ?? 0;
            final strength = _getElementStrength(count);
            final strengthColor = _getStrengthColor(count);

            return Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _openElementInsight(
                    element: element,
                    elementName: elementName,
                    count: count,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    children: [
                      // Element symbol
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.lightGold.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.lightGold.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            element,
                            style: const TextStyle(
                              fontFamily: AppConstants.chineseFont,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.lightGold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: AppConstants.defaultPadding),

                      // Progress bar
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  elementName,
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppColors.darkTextPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '$count',
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppColors.darkTextSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.darkBorder.withValues(
                                  alpha: 0.3,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: (count / 5).clamp(0.0, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        strengthColor,
                                        strengthColor.withValues(alpha: 0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: AppConstants.defaultPadding),

                      // Strength indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.smallPadding,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: strengthColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: strengthColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          strength,
                          style: AppTheme.caption.copyWith(
                            color: strengthColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: AppConstants.defaultPadding),

          // Summary section
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _openElementBalanceInsight,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                decoration: BoxDecoration(
                  color: AppColors.darkBorder.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.lightGold.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Summary',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppColors.lightGold,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: AppConstants.smallPadding),

                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryItem(
                            'Strongest',
                            baziData.strongestElement,
                            AppColors.lightGold,
                          ),
                        ),
                        const SizedBox(width: AppConstants.defaultPadding),
                        Expanded(
                          child: _buildSummaryItem(
                            'Weakest',
                            baziData.weakestElement,
                            AppColors.error,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppConstants.smallPadding),

                    _buildSummaryItem(
                      'Balance',
                      '${baziData.elementBalanceScore}%',
                      AppColors.success,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// [buildSummaryItem] - Helper method for summary items
  Widget _buildSummaryItem(String label, String value, Color valueColor) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: AppTheme.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: AppTheme.bodyMedium.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  /// [getElementStrength] - Get human-readable strength description
  String _getElementStrength(int count) {
    if (count >= 5) return '5 Very Strong';
    if (count >= 4) return '4 Very Strong';
    if (count >= 3) return '3 Strong';
    if (count >= 2) return '2 Moderate';
    return '1 Weak';
  }

  /// [getStrengthColor] - Get color based on strength
  Color _getStrengthColor(int count) {
    if (count >= 4) return AppColors.success;
    if (count >= 3) return AppColors.lightGold;
    if (count >= 2) return AppColors.warning;
    return AppColors.error;
  }

  // --- Explanations (Dialogs) ---
  void _openFortuneInsight(String sectionTitle) {
    final data = controller.fortuneData.value ?? {};
    final content = _buildFortuneInsightContent(
      sectionTitle,
      data,
    );
    _showInsightDialog(
      title: sectionTitle,
      body: content,
    );
  }

  List<Widget> _buildFortuneInsightContent(
    String section,
    Map<String, dynamic> data,
  ) {
    final widgets = <Widget>[];

    Text p0(String text) => Text(
      text,
      style: AppTheme.bodyMedium.copyWith(
        color: AppColors.darkTextSecondary,
        height: 1.5,
      ),
    );

    if (section == 'Life Period') {
      final p =
          (data['lifePeriods'] as Map?)?.cast<String, dynamic>() ??
          <String, dynamic>{};
      widgets.addAll([
        p0('Your current phase reflects your age and traditional life stages.'),
        const SizedBox(height: 8),
        p0('Focus: ${p['focus'] ?? '—'}'),
        p0('Challenges: ${p['challenges'] ?? '—'}'),
      ]);
    } else if (section == 'Grand Limit Cycle') {
      final g =
          (data['grandLimit'] as Map?)?.cast<String, dynamic>() ??
          <String, dynamic>{};
      widgets.addAll([
        p0('This runs in 10-year cycles derived from your age.'),
        p0('Cycle: ${g['cycleStart'] ?? '—'}–${g['cycleEnd'] ?? '—'}'),
        p0('Years remaining: ${g['yearsRemaining'] ?? '—'}'),
      ]);
    } else if (section == 'Small Limit Cycle') {
      final s =
          (data['smallLimit'] as Map?)?.cast<String, dynamic>() ??
          <String, dynamic>{};
      widgets.addAll([
        p0('A 1-year focus within the grand cycle.'),
        p0('Theme: ${s['yearName'] ?? '—'}'),
        p0('Focus areas: ${(s['focus'] as List?)?.join(', ') ?? '—'}'),
      ]);
    } else if (section == 'Annual Fortune') {
      final a =
          (data['annualFortune'] as Map?)?.cast<String, dynamic>() ??
          <String, dynamic>{};
      final m =
          (data['monthlyFortune'] as Map?)?.cast<String, dynamic>() ??
          <String, dynamic>{};
      final best = (m['bestMonths'] as List?)?.join(', ');
      final ch = (m['challengingMonths'] as List?)?.join(', ');
      widgets.addAll([
        p0(
          'Overall rating combines year element relations, lucky aspects and challenges.',
        ),
        const SizedBox(height: 8),
        p0('Year element: ${a['yearElement'] ?? '—'}'),
        p0('Relation to birth year: ${a['relationship']?['type'] ?? '—'}'),
        if (best != null) p0('Best months: $best'),
        if (ch != null) p0('Challenging months: $ch'),
      ]);
    } else {
      widgets.add(
        p0('This card summarizes calculated insights for your selected year.'),
      );
    }

    return widgets;
  }

  void _openElementInsight({
    required String element,
    required String elementName,
    required int count,
  }) {
    _showInsightDialog(
      title: '$element • $elementName',
      body: [
        Text(
          'Strength is based on how many times this element appears across your four pillars.',
          style: AppTheme.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Count: $count (0–5 scale) → ${_getElementStrength(count)}',
          style: AppTheme.bodyMedium.copyWith(
            color: AppColors.darkTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _openElementBalanceInsight() {
    final data = controller.baziData.value!;
    _showInsightDialog(
      title: 'Element Balance',
      body: [
        Text(
          'Balance score reflects how even your five elements are. We compute a simple ratio between the least and most frequent elements.',
          style: AppTheme.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Score = floor(minCount / maxCount × 100). Your score: ${data.elementBalanceScore}%',
          style: AppTheme.bodyMedium.copyWith(
            color: AppColors.darkTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

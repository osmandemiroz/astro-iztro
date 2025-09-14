part of 'analysis_view.dart';

/// Palace influences and recommendations widgets
extension AnalysisViewPart3 on AnalysisView {
  Widget _buildPalaceInfluences() {
    final chartData = controller.chartData.value!;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced header with icon and action button
          Row(
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
                child: const Icon(
                  Icons.star_rounded,
                  color: AppColors.lightPurple,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Expanded(
                child: Text(
                  AppLocalizations.of(Get.context!)!.palaceInfluences,
                  style: AppTheme.headingMedium.copyWith(
                    color: AppColors.lightPurple,
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
                      AppLocalizations.of(Get.context!)!.analysis,
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

          // Custom palace display with better readability
          _buildCustomPalaceInfluences(chartData),
        ],
      ),
    );
  }

  /// [buildCustomPalaceInfluences] - User-friendly palace influences display
  Widget _buildCustomPalaceInfluences(ChartData chartData) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.darkCard.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightPurple.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Palace influences section
          Text(
            AppLocalizations.of(Get.context!)!.lifeAreasStarInfluences,
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.lightPurple,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          // Individual palace rows
          ...chartData.palaces.map((palace) {
            final starCount = palace.starNames.length;
            final stars = chartData.getStarsInPalace(palace.name);

            return Padding(
              padding: const EdgeInsets.only(
                bottom: AppConstants.defaultPadding,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _openPalaceInsight(palace),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    decoration: BoxDecoration(
                      color: AppColors.darkBorder.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.lightPurple.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Palace header row
                        Row(
                          children: [
                            // Palace name
                            Expanded(
                              child: Text(
                                controller.getLocalizedPalaceName(palace.name),
                                style: AppTheme.bodyLarge.copyWith(
                                  color: AppColors.darkTextPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            ),

                            // Star count badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.smallPadding,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.lightPurple.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.lightPurple.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Text(
                                '$starCount ${starCount == 1 ? AppLocalizations.of(Get.context!)!.star : AppLocalizations.of(Get.context!)!.stars}',
                                style: AppTheme.caption.copyWith(
                                  color: AppColors.lightPurple,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),

                            const SizedBox(width: AppConstants.defaultPadding),

                            // Element indicator
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.lightGold.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.lightGold.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  palace.element,
                                  style: const TextStyle(
                                    fontFamily: AppConstants.chineseFont,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.lightGold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppConstants.smallPadding),

                        // Star buttons row
                        if (stars.isNotEmpty)
                          Wrap(
                            spacing: AppConstants.smallPadding,
                            runSpacing: AppConstants.smallPadding,
                            children: stars.map((star) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: AppColors.lightPurple.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.lightPurple.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      // Show star details in a dialog instead of navigation
                                      _showStarDetails(star, palace);
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppConstants.smallPadding,
                                        vertical: 6,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.star_rounded,
                                            color: AppColors.lightPurple,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            controller.getLocalizedStarName(
                                              star.nameEn,
                                            ),
                                            style: AppTheme.caption.copyWith(
                                              color: AppColors.lightPurple,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                        const SizedBox(height: AppConstants.smallPadding),

                        // Palace description
                        Container(
                          padding: const EdgeInsets.all(
                            AppConstants.smallPadding,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.darkCard.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            AppLocalizations.of(Get.context!)!
                                .thisPalaceContainsStars(
                              starCount,
                              controller.getLocalizedPalaceName(palace.name),
                            ),
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppColors.darkTextSecondary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// [showStarDetails] - Show star details in a dialog
  void _showStarDetails(StarData star, PalaceData palace) {
    Get.dialog<void>(
      Dialog(
        backgroundColor: AppColors.darkCard.withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Star header
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.lightPurple,
                    size: 24,
                  ),
                  const SizedBox(width: AppConstants.defaultPadding),
                  Expanded(
                    child: Text(
                      controller.getLocalizedStarName(star.nameEn),
                      style: AppTheme.headingMedium.copyWith(
                        color: AppColors.lightPurple,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              // Star details
              _buildStarDetailRow(
                AppLocalizations.of(Get.context!)!.category,
                star.category,
              ),
              _buildStarDetailRow(
                AppLocalizations.of(Get.context!)!.palace,
                controller.getLocalizedPalaceName(palace.name),
              ),
              _buildStarDetailRow(
                AppLocalizations.of(Get.context!)!.brightness,
                star.brightness,
              ),
              if (star.transformationType != null)
                _buildStarDetailRow(
                  AppLocalizations.of(Get.context!)!.transformation,
                  star.transformationType!,
                ),
              if (star.degree != null)
                _buildStarDetailRow(
                  AppLocalizations.of(Get.context!)!.degree,
                  '${star.degree}°',
                ),

              const SizedBox(height: AppConstants.defaultPadding),

              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back<void>(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightPurple,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.defaultPadding,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(AppLocalizations.of(Get.context!)!.close),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Explanations (Dialogs) ---
  void _openPalaceInsight(PalaceData palace) {
    final stars =
        controller.chartData.value?.getStarsInPalace(palace.name) ?? [];
    final l10n = AppLocalizations.of(Get.context!)!;
    final localizedPalaceName = controller.getLocalizedPalaceName(palace.name);
    final localizedElementName =
        controller.getLocalizedElementName(palace.element);
    final localizedStarNames =
        stars.map((e) => controller.getLocalizedStarName(e.nameEn)).join(', ');

    final details = <Widget>[
      Text(
        l10n.palaceInsightDescription(localizedPalaceName),
        style: AppTheme.bodyMedium.copyWith(
          color: AppColors.darkTextSecondary,
          height: 1.5,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        l10n.elementStars(localizedElementName, stars.length),
        style: AppTheme.bodyMedium.copyWith(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      if (stars.isNotEmpty) const SizedBox(height: 8),
      if (stars.isNotEmpty)
        Text(
          l10n.starsList(localizedStarNames),
          style: AppTheme.bodyMedium.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
    ];

    _showInsightDialog(
      title: localizedPalaceName,
      body: details,
    );
  }

  /// [buildStarDetailRow] - Helper method for star detail rows
  Widget _buildStarDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.darkTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.darkTextPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    final baziData = controller.baziData.value!;
    if (baziData.recommendations.isEmpty) return const SizedBox.shrink();

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
          // Enhanced header with icon
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
                  Icons.lightbulb_rounded,
                  color: AppColors.lightGold,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Text(
                AppLocalizations.of(Get.context!)!.lifeRecommendations,
                style: AppTheme.headingMedium.copyWith(
                  color: AppColors.lightGold,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          // Enhanced recommendations list
          ...baziData.recommendations.map(
            (rec) => Container(
              margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              decoration: BoxDecoration(
                color: AppColors.darkBorder.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.lightGold.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.lightGold,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: AppConstants.defaultPadding),
                  Expanded(
                    child: Text(
                      rec,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppColors.darkTextPrimary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

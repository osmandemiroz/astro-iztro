import 'package:astro_iztro/app/modules/settings/settings_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

/// [SettingsView] - Comprehensive settings screen
class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settingsTitle,
          style: AppTheme.headingMedium.copyWith(
            color: AppColors.darkTextPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            fontSize: 18,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: AppConstants.smallPadding),
            decoration: BoxDecoration(
              color: AppColors.darkCard.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              border: Border.all(
                color: AppColors.lightPurple.withValues(alpha: 0.3),
              ),
            ),
            child: IconButton(
              onPressed: controller.resetToDefaults,
              icon: const Icon(
                Icons.restore_rounded,
                color: AppColors.lightPurple,
                size: 22,
              ),
              tooltip: AppLocalizations.of(context)!.resetToDefaults,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.darkSpaceGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCalculationSection(context),
                const SizedBox(height: AppConstants.defaultPadding),
                _buildAdvancedSection(context),
                const SizedBox(height: AppConstants.defaultPadding),
                _buildDataSection(context),
                const SizedBox(height: AppConstants.defaultPadding),
                _buildAboutSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalculationSection(BuildContext context) {
    return _buildSection(
      title: AppLocalizations.of(context)!.calculationSettings,
      icon: Icons.calculate_outlined,
      children: [
        _buildSwitchTile(
          title: AppLocalizations.of(context)!.trueSolarTime,
          subtitle: AppLocalizations.of(context)!.trueSolarTimeDescription,
          value: controller.useTrueSolarTime,
          onChanged: (value) {
            controller.useTrueSolarTime.value = value;
            controller.saveCalculationPreferences();
          },
        ),
        _buildSwitchTile(
          title: AppLocalizations.of(context)!.showBrightness,
          subtitle: AppLocalizations.of(context)!.showBrightnessDescription,
          value: controller.showBrightness,
          onChanged: (value) {
            controller.showBrightness.value = value;
            controller.saveCalculationPreferences();
          },
        ),
        _buildSwitchTile(
          title: AppLocalizations.of(context)!.showTransformations,
          subtitle: AppLocalizations.of(context)!.showTransformationsDescription,
          value: controller.showTransformations,
          onChanged: (value) {
            controller.showTransformations.value = value;
            controller.saveCalculationPreferences();
          },
        ),
        _buildSwitchTile(
          title: AppLocalizations.of(context)!.autoSaveCalculations,
          subtitle: AppLocalizations.of(context)!.autoSaveCalculationsDescription,
          value: controller.autoSaveCalculations,
          onChanged: (value) {
            controller.autoSaveCalculations.value = value;
            controller.saveCalculationPreferences();
          },
        ),
      ],
    );
  }

  Widget _buildAdvancedSection(BuildContext context) {
    return _buildSection(
      title: AppLocalizations.of(context)!.advancedFeatures,
      icon: Icons.settings_outlined,
      children: [
        _buildSwitchTile(
          title: AppLocalizations.of(context)!.advancedAnalysis,
          subtitle: AppLocalizations.of(context)!.advancedAnalysisDescription,
          value: controller.showAdvancedAnalysis,
          onChanged: (value) {
            controller.showAdvancedAnalysis.value = value;
            controller.saveCalculationPreferences();
          },
        ),
        _buildSwitchTile(
          title: AppLocalizations.of(context)!.detailedStarAnalysis,
          subtitle: AppLocalizations.of(context)!.detailedStarAnalysisDescription,
          value: controller.enableDetailedStarAnalysis,
          onChanged: (value) {
            controller.enableDetailedStarAnalysis.value = value;
            controller.saveCalculationPreferences();
          },
        ),
        _buildSwitchTile(
          title: AppLocalizations.of(context)!.autoSavePalaceAnalysis,
          subtitle: AppLocalizations.of(context)!.autoSavePalaceAnalysisDescription,
          value: controller.autoSavePalaceAnalysis,
          onChanged: (value) {
            controller.autoSavePalaceAnalysis.value = value;
            controller.saveCalculationPreferences();
          },
        ),
        _buildSwitchTile(
          title: AppLocalizations.of(context)!.transformationEffects,
          subtitle: AppLocalizations.of(context)!.transformationEffectsDescription,
          value: controller.showTransformationEffects,
          onChanged: (value) {
            controller.showTransformationEffects.value = value;
            controller.saveCalculationPreferences();
          },
        ),
        _buildSwitchTile(
          title: AppLocalizations.of(context)!.fortuneTiming,
          subtitle: AppLocalizations.of(context)!.fortuneTimingDescription,
          value: controller.enableFortuneTiming,
          onChanged: (value) {
            controller.enableFortuneTiming.value = value;
            controller.saveCalculationPreferences();
          },
        ),
      ],
    );
  }

  Widget _buildDataSection(BuildContext context) {
    return _buildSection(
      title: AppLocalizations.of(context)!.dataManagement,
      icon: Icons.storage_outlined,
      children: [
        Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding * 1.2),
          decoration: BoxDecoration(
            color: AppColors.darkSurface.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(
              color: AppColors.lightPurple.withValues(alpha: 0.2),
            ),
          ),
          child: Obx(
            () => Column(
              children: [
                _buildDataRow(
                  AppLocalizations.of(context)!.storageUsed,
                  controller.formattedStorageSize,
                  Icons.storage_rounded,
                ),
                const SizedBox(height: AppConstants.smallPadding),
                _buildDataRow(
                  AppLocalizations.of(context)!.totalProfiles,
                  controller.totalProfiles.value.toString(),
                  Icons.person_rounded,
                ),
                const SizedBox(height: AppConstants.smallPadding),
                _buildDataRow(
                  AppLocalizations.of(context)!.calculationsStored,
                  controller.totalCalculations.value.toString(),
                  Icons.calculate_rounded,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.lightPurple.withValues(alpha: 0.1),
                      AppColors.lightPurple.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                  border: Border.all(
                    color: AppColors.lightPurple.withValues(alpha: 0.3),
                  ),
                ),
                child: OutlinedButton.icon(
                  onPressed: controller.exportUserData,
                  icon: const Icon(Icons.upload_outlined, size: 18),
                  label: Text(AppLocalizations.of(context)!.exportData),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.lightPurple,
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.smallPadding),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.withValues(alpha: 0.1),
                      Colors.red.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.3),
                  ),
                ),
                child: OutlinedButton.icon(
                  onPressed: controller.clearUserData,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: Text(AppLocalizations.of(context)!.clearData),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.lightPurple.withValues(alpha: 0.1),
                AppColors.lightPurple.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(
              color: AppColors.lightPurple.withValues(alpha: 0.3),
            ),
          ),
          child: OutlinedButton.icon(
            onPressed: controller.resetOnboarding,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(AppLocalizations.of(context)!.resetOnboarding),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.lightPurple,
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return _buildSection(
      title: AppLocalizations.of(context)!.about,
      icon: Icons.info_outline,
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.astroIztroApp),
          subtitle: Text(AppLocalizations.of(context)!.purpleStarAstrologyBazi),
          leading: const Icon(Icons.star_border, color: AppColors.primaryGold),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.version),
          subtitle: const Text('1.0.0'),
          leading: const Icon(Icons.code),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.framework),
          subtitle: Text(AppLocalizations.of(context)!.flutterGetx),
          leading: const Icon(Icons.flutter_dash),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.package),
          subtitle: Text(AppLocalizations.of(context)!.iztro),
          leading: const Icon(Icons.integration_instructions),
        ),
      ],
    );
  }

  /// [_buildSection] - Modern section card with Apple-inspired design
  /// Features liquid glass effect, subtle shadows, and elegant typography
  /// Following Apple Human Interface Guidelines for clean, accessible UI
  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.darkCard.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius * 1.5),
        border: Border.all(
          color: AppColors.lightPurple.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightPurple.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding * 1.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header with enhanced styling
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.smallPadding,
                vertical: AppConstants.smallPadding / 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.lightPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                border: Border.all(
                  color: AppColors.lightPurple.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: AppColors.lightPurple,
                    size: 20,
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Text(
                    title.toUpperCase(),
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppColors.lightPurple,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding * 1.2),
            // Section content with improved spacing
            ...children.map(
              (child) => Padding(
                padding: const EdgeInsets.only(
                  bottom: AppConstants.smallPadding,
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// [_buildDataRow] - Data display row with icon and modern styling
  /// Used in the data management section for consistent information display
  Widget _buildDataRow(String label, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: AppColors.lightPurple.withValues(alpha: 0.7),
            ),
            const SizedBox(width: AppConstants.smallPadding),
            Text(
              label,
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.darkTextSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: AppTheme.bodyMedium.copyWith(
            color: AppColors.darkTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  /// [_buildSwitchTile] - Enhanced switch tile with modern Apple-inspired design
  /// Features improved typography, better spacing, and elegant visual hierarchy
  /// Following Apple Human Interface Guidelines for intuitive user interaction
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required RxBool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.smallPadding,
          vertical: AppConstants.smallPadding,
        ),
        decoration: BoxDecoration(
          color: AppColors.darkSurface.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(
            color: AppColors.lightPurple.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            // Text content with improved typography
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppColors.darkTextPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppColors.darkTextSecondary,
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppConstants.smallPadding),
            // Enhanced switch with custom styling
            Transform.scale(
              scale: 1.1,
              child: Switch(
                value: value.value,
                onChanged: onChanged,
                activeTrackColor: AppColors.lightPurple.withValues(alpha: 0.3),
                inactiveThumbColor: AppColors.darkTextTertiary,
                inactiveTrackColor: AppColors.darkTextTertiary.withValues(
                  alpha: 0.2,
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

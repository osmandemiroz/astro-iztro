import 'package:astro_iztro/app/modules/settings/settings_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// [SettingsView] - Comprehensive settings screen
class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SETTINGS',
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
              tooltip: 'Reset to Defaults',
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
                _buildCalculationSection(),
                const SizedBox(height: AppConstants.defaultPadding),
                _buildAdvancedSection(),
                const SizedBox(height: AppConstants.defaultPadding),
                _buildDataSection(),
                const SizedBox(height: AppConstants.defaultPadding),
                _buildAboutSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalculationSection() {
    return _buildSection(
      title: 'Calculation Settings',
      icon: Icons.calculate_outlined,
      children: [
        _buildSwitchTile(
          title: 'True Solar Time',
          subtitle: 'Use true solar time for calculations',
          value: controller.useTrueSolarTime,
          onChanged: (value) {
            controller.useTrueSolarTime.value = value;
            controller.saveCalculationPreferences();
          },
        ),
        _buildSwitchTile(
          title: 'Show Brightness',
          subtitle: 'Display star brightness information',
          value: controller.showBrightness,
          onChanged: (value) {
            controller.showBrightness.value = value;
            controller.saveCalculationPreferences();
          },
        ),
        _buildSwitchTile(
          title: 'Show Transformations',
          subtitle: 'Display star transformations',
          value: controller.showTransformations,
          onChanged: (value) {
            controller.showTransformations.value = value;
            controller.saveCalculationPreferences();
          },
        ),
        _buildSwitchTile(
          title: 'Auto Save Calculations',
          subtitle: 'Automatically save calculation results',
          value: controller.autoSaveCalculations,
          onChanged: (value) {
            controller.autoSaveCalculations.value = value;
            controller.saveCalculationPreferences();
          },
        ),
      ],
    );
  }

  Widget _buildAdvancedSection() {
    return _buildSection(
      title: 'Advanced Features',
      icon: Icons.settings_outlined,
      children: [
        _buildSwitchTile(
          title: 'Advanced Analysis',
          subtitle: 'Enable detailed analysis features',
          value: controller.showAdvancedAnalysis,
          onChanged: (value) {
            controller.showAdvancedAnalysis.value = value;
            controller.saveCalculationPreferences();
          },
        ),
        _buildSwitchTile(
          title: 'Detailed Star Analysis',
          subtitle: 'Show comprehensive star information',
          value: controller.enableDetailedStarAnalysis,
          onChanged: (value) {
            controller.enableDetailedStarAnalysis.value = value;
            controller.saveCalculationPreferences();
          },
        ),
        _buildSwitchTile(
          title: 'Auto Save Palace Analysis',
          subtitle: 'Automatically save palace analysis data',
          value: controller.autoSavePalaceAnalysis,
          onChanged: (value) {
            controller.autoSavePalaceAnalysis.value = value;
            controller.saveCalculationPreferences();
          },
        ),
        _buildSwitchTile(
          title: 'Transformation Effects',
          subtitle: 'Show transformation effects',
          value: controller.showTransformationEffects,
          onChanged: (value) {
            controller.showTransformationEffects.value = value;
            controller.saveCalculationPreferences();
          },
        ),
        _buildSwitchTile(
          title: 'Fortune Timing',
          subtitle: 'Enable fortune timing calculations',
          value: controller.enableFortuneTiming,
          onChanged: (value) {
            controller.enableFortuneTiming.value = value;
            controller.saveCalculationPreferences();
          },
        ),
      ],
    );
  }

  Widget _buildDataSection() {
    return _buildSection(
      title: 'Data Management',
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
                  'Storage Used',
                  controller.formattedStorageSize,
                  Icons.storage_rounded,
                ),
                const SizedBox(height: AppConstants.smallPadding),
                _buildDataRow(
                  'Total Profiles',
                  controller.totalProfiles.value.toString(),
                  Icons.person_rounded,
                ),
                const SizedBox(height: AppConstants.smallPadding),
                _buildDataRow(
                  'Calculations Stored',
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
                  label: const Text('Export Data'),
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
                  label: const Text('Clear Data'),
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
            label: const Text('Reset Onboarding'),
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

  Widget _buildAboutSection() {
    return _buildSection(
      title: 'About',
      icon: Icons.info_outline,
      children: [
        const ListTile(
          title: Text('Astro Iztro'),
          subtitle: Text('Purple Star Astrology & BaZi Analysis'),
          leading: Icon(Icons.star_border, color: AppColors.primaryGold),
        ),
        const ListTile(
          title: Text('Version'),
          subtitle: Text('1.0.0'),
          leading: Icon(Icons.code),
        ),
        const ListTile(
          title: Text('Framework'),
          subtitle: Text('Flutter & GetX'),
          leading: Icon(Icons.flutter_dash),
        ),
        const ListTile(
          title: Text('Package'),
          subtitle: Text('Iztro'),
          leading: Icon(Icons.integration_instructions),
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
                activeThumbColor: AppColors.lightPurple,
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

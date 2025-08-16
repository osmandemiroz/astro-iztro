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
        title: const Text(
          'Settings',
          style: TextStyle(color: AppColors.darkTextPrimary),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: controller.resetToDefaults,
            icon: const Icon(
              Icons.restore,
              color: AppColors.lightPurple,
            ),
            tooltip: 'Reset to Defaults',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppearanceSection(),
            const SizedBox(height: AppConstants.defaultPadding),
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
    );
  }

  Widget _buildAppearanceSection() {
    return _buildSection(
      title: 'Appearance',
      icon: Icons.palette_outlined,
      children: [
        _buildThemeSelector(),
        const SizedBox(height: AppConstants.smallPadding),
        _buildLanguageSelector(),
        const SizedBox(height: AppConstants.smallPadding),
        _buildSwitchTile(
          title: 'Traditional Chinese',
          subtitle: 'Use traditional Chinese characters',
          value: controller.preferTraditionalChinese,
          onChanged: (value) {
            controller.preferTraditionalChinese.value = value;
            controller.saveCalculationPreferences();
          },
        ),
      ],
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
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Storage Used'),
                    Obx(
                      () => Text(
                        controller.formattedStorageSize,
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.smallPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Profiles'),
                    Obx(
                      () => Text(
                        controller.totalProfiles.value.toString(),
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.smallPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Calculations Stored'),
                    Obx(
                      () => Text(
                        controller.totalCalculations.value.toString(),
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: controller.exportUserData,
                icon: const Icon(Icons.upload_outlined),
                label: const Text('Export Data'),
              ),
            ),
            const SizedBox(width: AppConstants.smallPadding),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: controller.clearUserData,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Clear Data'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
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
          subtitle: Text('dart_iztro integration'),
          leading: Icon(Icons.integration_instructions),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primaryPurple),
                const SizedBox(width: AppConstants.smallPadding),
                Text(
                  title,
                  style: AppTheme.headingMedium.copyWith(
                    color: AppColors.primaryPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Theme',
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Wrap(
            spacing: AppConstants.smallPadding,
            children: controller.themeModes.map((theme) {
              final isSelected = controller.themeMode.value == theme['code'];
              return FilterChip(
                label: Text(theme['name']!),
                selected: isSelected,
                onSelected: (_) => controller.setThemeMode(theme['code']!),
                selectedColor: AppColors.primaryPurple.withValues(alpha: 0.2),
                checkmarkColor: AppColors.primaryPurple,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Language',
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          DropdownButtonFormField<String>(
            value: controller.languageCode.value,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
                vertical: AppConstants.smallPadding,
              ),
            ),
            items: controller.supportedLanguages.map((language) {
              return DropdownMenuItem<String>(
                value: language['code'],
                child: Text(language['name']!),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.setLanguage(value);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required RxBool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Obx(
      () => SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        value: value.value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primaryPurple,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}

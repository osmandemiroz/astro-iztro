// ignore_for_file: deprecated_member_use, document_ignores

import 'package:astro_iztro/app/modules/settings/settings_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// [SettingsView] - Comprehensive settings and preferences screen
class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            _buildAppearanceSection(),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildCalculationSection(),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: AppTheme.headingMedium.copyWith(
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),

            // Theme selection
            ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: const Text('Theme'),
              subtitle: Obx(
                () => Text(
                  controller.getThemeDisplayName(
                    controller.selectedTheme.value,
                  ),
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: _showThemeDialog,
            ),

            const Divider(),

            // Language selection
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              subtitle: Obx(
                () => Text(
                  controller.getLanguageDisplayName(
                    controller.selectedLanguage.value,
                  ),
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: _showLanguageDialog,
            ),

            const Divider(),

            // Traditional Chinese preference
            Obx(
              () => SwitchListTile(
                secondary: const Icon(Icons.translate),
                title: const Text('Traditional Chinese'),
                subtitle: const Text('Use traditional Chinese characters'),
                value: controller.preferTraditionalChinese.value,
                onChanged: (value) {
                  controller.preferTraditionalChinese.value = value;
                  controller.saveCalculationPreferences();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calculation Preferences',
              style: AppTheme.headingMedium.copyWith(
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),

            // True Solar Time
            Obx(
              () => SwitchListTile(
                secondary: const Icon(Icons.access_time),
                title: const Text('True Solar Time'),
                subtitle: const Text('Use precise solar time calculations'),
                value: controller.useTrueSolarTime.value,
                onChanged: (value) {
                  controller.useTrueSolarTime.value = value;
                  controller.saveCalculationPreferences();
                },
              ),
            ),

            const Divider(),

            // Show Brightness
            Obx(
              () => SwitchListTile(
                secondary: const Icon(Icons.brightness_6),
                title: const Text('Show Star Brightness'),
                subtitle: const Text('Display star brightness levels'),
                value: controller.showBrightness.value,
                onChanged: (value) {
                  controller.showBrightness.value = value;
                  controller.saveCalculationPreferences();
                },
              ),
            ),

            const Divider(),

            // Show Transformations
            Obx(
              () => SwitchListTile(
                secondary: const Icon(Icons.transform),
                title: const Text('Show Transformations'),
                subtitle: const Text('Display star transformation effects'),
                value: controller.showTransformations.value,
                onChanged: (value) {
                  controller.showTransformations.value = value;
                  controller.saveCalculationPreferences();
                },
              ),
            ),

            const Divider(),

            // Advanced Analysis
            Obx(
              () => SwitchListTile(
                secondary: const Icon(Icons.analytics),
                title: const Text('Advanced Analysis'),
                subtitle: const Text(
                  'Enable detailed star and palace analysis',
                ),
                value: controller.showAdvancedAnalysis.value,
                onChanged: (value) {
                  controller.showAdvancedAnalysis.value = value;
                  controller.saveCalculationPreferences();
                },
              ),
            ),

            const Divider(),

            // Fortune Timing
            Obx(
              () => SwitchListTile(
                secondary: const Icon(Icons.schedule),
                title: const Text('Fortune Timing'),
                subtitle: const Text('Enable fortune timing calculations'),
                value: controller.enableFortuneTiming.value,
                onChanged: (value) {
                  controller.enableFortuneTiming.value = value;
                  controller.saveCalculationPreferences();
                },
              ),
            ),

            const Divider(),

            // Auto Save
            Obx(
              () => SwitchListTile(
                secondary: const Icon(Icons.save_outlined),
                title: const Text('Auto Save'),
                subtitle: const Text('Automatically save calculations'),
                value: controller.autoSaveCalculations.value,
                onChanged: (value) {
                  controller.autoSaveCalculations.value = value;
                  controller.saveCalculationPreferences();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Management',
              style: AppTheme.headingMedium.copyWith(
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),

            // Storage info
            Container(
              padding: const EdgeInsets.all(AppConstants.smallPadding),
              decoration: BoxDecoration(
                color: AppColors.ultraLightPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primaryPurple.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Storage Used:'),
                      Obx(
                        () => Text(
                          controller.storageSize.value,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Profiles:'),
                      Obx(
                        () => Text(
                          '${controller.profileCount.value}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Calculations:'),
                      Obx(
                        () => Text(
                          '${controller.calculationCount.value}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Export Data
            ListTile(
              leading: const Icon(Icons.upload_outlined),
              title: const Text('Export Data'),
              subtitle: const Text('Export all user data'),
              trailing: const Icon(Icons.chevron_right),
              onTap: controller.exportUserData,
            ),

            const Divider(),

            // Clear User Data
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.orange),
              title: const Text('Clear User Data'),
              subtitle: const Text('Delete profiles and calculations'),
              trailing: const Icon(Icons.chevron_right),
              onTap: controller.clearUserData,
            ),

            const Divider(),

            // Reset Settings
            ListTile(
              leading: const Icon(Icons.restore, color: Colors.blue),
              title: const Text('Reset Settings'),
              subtitle: const Text('Reset all settings to defaults'),
              trailing: const Icon(Icons.chevron_right),
              onTap: controller.resetToDefaults,
            ),

            const Divider(),

            // Clear All Data
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Clear All Data'),
              subtitle: const Text('Reset app to initial state'),
              trailing: const Icon(Icons.chevron_right),
              onTap: controller.clearAllData,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: AppTheme.headingMedium.copyWith(
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),

            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('App Information'),
              subtitle: const Text('Version, credits, and more'),
              trailing: const Icon(Icons.chevron_right),
              onTap: controller.showAppInfo,
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog() {
    Get.dialog<void>(
      AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption('system', 'System Default'),
            _buildThemeOption('light', 'Light'),
            _buildThemeOption('dark', 'Dark'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back<void>(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(String value, String label) {
    return Obx(
      () => RadioListTile<String>(
        title: Text(label),
        value: value,
        groupValue: controller.selectedTheme.value,
        onChanged: (newValue) {
          if (newValue != null) {
            controller.changeTheme(newValue);
            Get.back<void>();
          }
        },
      ),
    );
  }

  void _showLanguageDialog() {
    const languages = {
      'en': 'English',
      'zh': 'Chinese (Simplified)',
      'ja': 'Japanese',
      'ko': 'Korean',
      'th': 'Thai',
      'vi': 'Vietnamese',
    };

    Get.dialog<void>(
      AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.entries
              .map((entry) => _buildLanguageOption(entry.key, entry.value))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back<void>(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String value, String label) {
    return Obx(
      () => RadioListTile<String>(
        title: Text(label),
        value: value,
        groupValue: controller.selectedLanguage.value,
        onChanged: (newValue) {
          if (newValue != null) {
            controller.changeLanguage(newValue);
            Get.back<void>();
          }
        },
      ),
    );
  }
}

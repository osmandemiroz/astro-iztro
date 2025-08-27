import 'package:astro_iztro/app/modules/input/input_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:astro_iztro/shared/widgets/location_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

/// [InputView] - User input form screen for birth data entry
/// Comprehensive form following Apple Human Interface Guidelines
/// Enhanced with dark theme for modern UI
class InputView extends GetView<InputController> {
  const InputView({super.key});

  /// [_getTitle] - Get the appropriate title based on context
  String _getTitle() {
    final arguments = Get.arguments;
    final isForOtherPerson =
        arguments is Map<String, dynamic> &&
        arguments['isForOtherPerson'] == true;
    return isForOtherPerson
        ? 'Create Profile for Other Person'
        : 'Profile Information';
  }

  /// [_isForOtherPerson] - Check if creating profile for someone else
  bool _isForOtherPerson() {
    final arguments = Get.arguments;
    return arguments is Map<String, dynamic> &&
        arguments['isForOtherPerson'] == true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getTitle(),
          style: const TextStyle(color: AppColors.darkTextPrimary),
        ),
        actions: [
          Obx(
            () => controller.isLoading.value
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : TextButton(
                    onPressed: controller.saveProfile,
                    child: Text(
                      _isForOtherPerson() ? 'Create Profile' : 'Save',
                      style: const TextStyle(color: AppColors.lightPurple),
                    ),
                  ),
          ),
        ],
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPersonalInfoSection(),
              const SizedBox(height: AppConstants.largePadding),
              _buildBirthInfoSection(),
              const SizedBox(height: AppConstants.largePadding),
              _buildLocationSection(),
              const SizedBox(height: AppConstants.largePadding),
              _buildPreferencesSection(),
              const SizedBox(height: AppConstants.largePadding * 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isForOtherPerson()
              ? "Other Person's Information"
              : 'Personal Information',
          style: AppTheme.headingSmall.copyWith(
            color: AppColors.darkTextPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        TextFormField(
          controller: controller.nameController,
          decoration: const InputDecoration(
            labelText: 'Name (Optional)',
            hintText: 'Enter your name',
            prefixIcon: Icon(Icons.person_outline),
          ),
          validator: controller.validateName,
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        Obx(
          () => DropdownButtonFormField<String>(
            value: controller.selectedGender.value,
            decoration: const InputDecoration(
              labelText: 'Gender',
              prefixIcon: Icon(Icons.wc_outlined),
            ),
            items: const [
              DropdownMenuItem(value: 'male', child: Text('Male')),
              DropdownMenuItem(value: 'female', child: Text('Female')),
            ],
            onChanged: (value) {
              if (value != null) controller.selectedGender.value = value;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBirthInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isForOtherPerson()
              ? "Other Person's Birth Information"
              : 'Birth Information',
          style: AppTheme.headingSmall.copyWith(
            color: AppColors.darkTextPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),

        // Date picker
        Obx(
          () => ListTile(
            title: const Text('Birth Date'),
            subtitle: Text(
              '${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}',
            ),
            leading: const Icon(Icons.calendar_today_outlined),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _showDatePicker,
          ),
        ),

        // Time picker
        Row(
          children: [
            Expanded(
              child: Obx(
                () => DropdownButtonFormField<int>(
                  value: controller.selectedHour.value,
                  decoration: const InputDecoration(
                    labelText: 'Hour',
                    prefixIcon: Icon(Icons.access_time_outlined),
                  ),
                  items: List.generate(
                    24,
                    (index) => DropdownMenuItem(
                      value: index,
                      child: Text(index.toString().padLeft(2, '0')),
                    ),
                  ),
                  onChanged: (value) {
                    if (value != null) controller.selectedHour.value = value;
                  },
                ),
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            Expanded(
              child: Obx(
                () => DropdownButtonFormField<int>(
                  value: controller.selectedMinute.value,
                  decoration: const InputDecoration(
                    labelText: 'Minute',
                  ),
                  items: List.generate(
                    60,
                    (index) => DropdownMenuItem(
                      value: index,
                      child: Text(index.toString().padLeft(2, '0')),
                    ),
                  ),
                  onChanged: (value) {
                    if (value != null) controller.selectedMinute.value = value;
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Location Information', style: AppTheme.headingSmall),
        const SizedBox(height: AppConstants.defaultPadding),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.map_outlined),
            label: const Text('Pick on Map'),
            onPressed: () async {
              // Open map picker and update latitude/longitude when returned
              final picked = await Get.to<LatLng?>(
                () => const LocationPicker(),
                transition: Transition.cupertino,
              );
              if (picked != null) {
                controller.latitudeController.text = picked.latitude
                    .toStringAsFixed(6);
                controller.longitudeController.text = picked.longitude
                    .toStringAsFixed(6);
              }
            },
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        TextFormField(
          controller: controller.locationController,
          decoration: const InputDecoration(
            labelText: 'Location Name (Optional)',
            hintText: 'e.g., New York, USA',
            prefixIcon: Icon(Icons.location_city_outlined),
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.latitudeController,
                decoration: const InputDecoration(
                  labelText: 'Latitude',
                  hintText: 'e.g., 40.7128',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: controller.validateLatitude,
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            Expanded(
              child: TextFormField(
                controller: controller.longitudeController,
                decoration: const InputDecoration(
                  labelText: 'Longitude',
                  hintText: 'e.g., -74.0060',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: controller.validateLongitude,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Calculation Preferences', style: AppTheme.headingSmall),
        const SizedBox(height: AppConstants.defaultPadding),

        Obx(
          () => SwitchListTile(
            title: const Text('Use Lunar Calendar'),
            subtitle: const Text('Calculate based on lunar calendar'),
            value: controller.isLunarCalendar.value,
            onChanged: (value) => controller.isLunarCalendar.value = value,
          ),
        ),

        Obx(
          () => SwitchListTile(
            title: const Text('True Solar Time'),
            subtitle: const Text(
              'Use true solar time for accurate calculations',
            ),
            value: controller.useTrueSolarTime.value,
            onChanged: (value) => controller.useTrueSolarTime.value = value,
          ),
        ),

        Obx(
          () => DropdownButtonFormField<String>(
            value: controller.selectedLanguage.value,
            decoration: const InputDecoration(
              labelText: 'Language',
              prefixIcon: Icon(Icons.language_outlined),
            ),
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'zh', child: Text('Chinese Simplified')),
              DropdownMenuItem(
                value: 'zh-TW',
                child: Text('Chinese Traditional'),
              ),
              DropdownMenuItem(value: 'ja', child: Text('Japanese')),
              DropdownMenuItem(value: 'ko', child: Text('Korean')),
            ],
            onChanged: (value) {
              if (value != null) controller.selectedLanguage.value = value;
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showDatePicker() async {
    final date = await showDatePicker(
      context: Get.context!,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      controller.selectedDate.value = date;
    }
  }
}

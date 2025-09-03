import 'package:astro_iztro/app/modules/home/home_controller.dart';
import 'package:astro_iztro/core/models/user_profile.dart';
import 'package:astro_iztro/core/services/iztro_service.dart';
import 'package:astro_iztro/core/services/storage_service.dart';
import 'package:astro_iztro/core/services/validation_service.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// [InputController] - Controller for user input form
/// Manages birth data entry and validation for astrological calculations
class InputController extends GetxController {
  // Services
  final StorageService _storageService = Get.find<StorageService>();
  final IztroService _iztroService = Get.find<IztroService>();

  // Form controllers
  final nameController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final locationController = TextEditingController();

  // Reactive state
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxInt selectedHour = 12.obs;
  final RxInt selectedMinute = 0.obs;
  final RxString selectedGender = 'male'.obs;
  final RxBool isLunarCalendar = false.obs;
  final RxBool hasLeapMonth = false.obs;

  final RxBool useTrueSolarTime = true.obs;
  final RxBool isLoading = false.obs;

  // Form validation
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    // Check if we're creating a profile for someone else
    final arguments = Get.arguments;
    final isForOtherPerson =
        arguments is Map<String, dynamic> &&
        arguments['isForOtherPerson'] == true;

    if (!isForOtherPerson) {
      // Load existing profile if available (only when editing current profile)
      _loadExistingProfile();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    locationController.dispose();
    super.onClose();
  }

  /// Load existing profile data for editing
  void _loadExistingProfile() {
    final profile = _storageService.loadUserProfile();
    if (profile != null) {
      nameController.text = profile.name ?? '';
      selectedDate.value = profile.birthDate;
      selectedHour.value = profile.birthHour;
      selectedMinute.value = profile.birthMinute;
      selectedGender.value = profile.gender;
      latitudeController.text = profile.latitude.toString();
      longitudeController.text = profile.longitude.toString();
      locationController.text = profile.locationName ?? '';
      isLunarCalendar.value = profile.isLunarCalendar;
      hasLeapMonth.value = profile.hasLeapMonth;
      // Language is always English
      useTrueSolarTime.value = profile.useTrueSolarTime;
    }
  }

  /// Save user profile
  Future<void> saveProfile() async {
    if (kDebugMode) {
      print('[InputController] saveProfile method called');
    }

    // Show immediate feedback that save was attempted
    Get.snackbar(
      'Saving...',
      'Processing your profile data...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );

    if (!formKey.currentState!.validate()) {
      if (kDebugMode) {
        print('[InputController] Form validation failed');
      }
      Get.snackbar(
        'Validation Error',
        'Please check your input fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      if (kDebugMode) {
        print('[InputController] Starting profile save...');
      }

      final profile = UserProfile(
        name: nameController.text.trim().isEmpty
            ? null
            : nameController.text.trim(),
        birthDate: selectedDate.value,
        birthHour: selectedHour.value,
        birthMinute: selectedMinute.value,
        gender: selectedGender.value,
        latitude: double.parse(latitudeController.text),
        longitude: double.parse(longitudeController.text),
        locationName: locationController.text.trim().isEmpty
            ? null
            : locationController.text.trim(),
        isLunarCalendar: isLunarCalendar.value,
        hasLeapMonth: hasLeapMonth.value,
        useTrueSolarTime: useTrueSolarTime.value,
      );

      // Validate profile with Iztro service
      if (!_iztroService.validateBirthData(profile)) {
        throw Exception('Invalid birth data provided');
      }

      // Check if we're creating a profile for someone else
      final arguments = Get.arguments;
      final isForOtherPerson =
          arguments is Map<String, dynamic> &&
          arguments['isForOtherPerson'] == true;

      if (isForOtherPerson) {
        // Save as a separate profile for other person (don't set as current user profile)
        await _storageService.saveUserProfileAsOther(profile);

        Get
          ..snackbar(
            'Success',
            'Profile for other person saved successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          )
          // Go back to astro matcher with the new profile
          ..back(result: profile);
      } else {
        // Save as current user profile
        await _storageService.saveUserProfile(profile);

        // Send event to refresh home screen data
        await Get.find<HomeController>().refreshData();

        if (kDebugMode) {
          print(
            '[InputController] Profile saved successfully, showing snackbar...',
          );
        }

        // Show success snackbar
        Get.snackbar(
          'Success',
          'Your profile saved successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
        );

        // Wait a moment for snackbar to show, then navigate back
        await Future<void>.delayed(const Duration(milliseconds: 500));
        Get.back(result: profile);
      }
    } on Exception catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Validate form fields
  String? validateName(String? value) {
    // Name is optional
    return null;
  }

  String? validateLatitude(String? value) {
    if (value == null || value.isEmpty) {
      return 'Latitude is required';
    }

    final lat = double.tryParse(value);
    if (lat == null) {
      return 'Invalid latitude format';
    }

    if (lat < -90 || lat > 90) {
      return 'Latitude must be between -90 and 90';
    }

    return null;
  }

  String? validateLongitude(String? value) {
    if (value == null || value.isEmpty) {
      return 'Longitude is required';
    }

    final lng = double.tryParse(value);
    if (lng == null) {
      return 'Invalid longitude format';
    }

    if (lng < -180 || lng > 180) {
      return 'Longitude must be between -180 and 180';
    }

    return null;
  }

  /// [validateCompleteForm] - Validate complete form using ValidationService
  bool validateCompleteForm() {
    final results = ValidationService.validateUserProfileComplete(
      name: nameController.text,
      birthDate: selectedDate.value,
      birthTime: DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
        selectedHour.value,
        selectedMinute.value,
      ),
      location: locationController.text,
      latitude: double.tryParse(latitudeController.text),
      longitude: double.tryParse(longitudeController.text),
      gender: selectedGender.value,
      calendarType: isLunarCalendar.value ? 'lunar' : 'solar',
      languageCode: 'en', // Always English
      timezone: DateTime.now().timeZoneOffset.inHours.toString(),
    );

    if (ValidationService.hasErrors(results)) {
      final errorMessages = ValidationService.getErrorMessages(results);
      Get.snackbar(
        'Validation Error',
        errorMessages.first,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (ValidationService.hasWarnings(results)) {
      final warningMessages = ValidationService.getWarningMessages(results);
      if (kDebugMode) {
        print('[InputController] Validation warnings: $warningMessages');
      }
    }

    return true;
  }

  /// [sanitizeInputs] - Sanitize all text inputs
  void sanitizeInputs() {
    nameController.text = ValidationService.sanitizeInput(nameController.text);
    locationController.text = ValidationService.sanitizeInput(
      locationController.text,
    );
  }

  /// [resetForm] - Reset form to initial state
  void resetForm() {
    nameController.clear();
    latitudeController.clear();
    longitudeController.clear();
    locationController.clear();
    selectedDate.value = DateTime.now();
    selectedHour.value = 12;
    selectedMinute.value = 0;
    selectedGender.value = 'male';
    isLunarCalendar.value = false;
    hasLeapMonth.value = false;
    // Language is always English
    useTrueSolarTime.value = true;
  }

  /// [loadProfileData] - Load existing profile data into form
  void loadProfileData(UserProfile profile) {
    nameController.text = profile.name ?? '';
    selectedDate.value = profile.birthDate;
    // Extract hour and minute from birthDate since birthTime doesn't exist
    selectedHour.value = profile.birthDate.hour;
    selectedMinute.value = profile.birthDate.minute;
    selectedGender.value = profile.gender;
    latitudeController.text = profile.latitude.toString();
    longitudeController.text = profile.longitude.toString();
    locationController.text = profile.locationName ?? '';
    // Use solar as default since calendarType doesn't exist
    isLunarCalendar.value = false;
    hasLeapMonth.value = profile.hasLeapMonth;
    // Language is always English
    useTrueSolarTime.value = profile.useTrueSolarTime;
  }
}

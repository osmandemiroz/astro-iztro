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
  final RxString selectedLanguage = 'en'.obs;
  final RxBool useTrueSolarTime = true.obs;
  final RxBool isLoading = false.obs;

  // Form validation
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    // Load existing profile if available
    _loadExistingProfile();
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
      selectedLanguage.value = profile.languageCode;
      useTrueSolarTime.value = profile.useTrueSolarTime;
    }
  }

  /// Save user profile with enhanced validation
  Future<void> saveProfile() async {
    // Use comprehensive validation
    if (!await validateForm()) return;

    try {
      isLoading.value = true;

      final profile = UserProfile(
        name: nameController.text.trim().isEmpty
            ? null
            : ValidationService.sanitizeInput(nameController.text.trim()),
        birthDate: selectedDate.value,
        birthHour: selectedHour.value,
        birthMinute: selectedMinute.value,
        gender: selectedGender.value,
        latitude: double.parse(latitudeController.text),
        longitude: double.parse(longitudeController.text),
        locationName: locationController.text.trim().isEmpty
            ? null
            : ValidationService.sanitizeInput(locationController.text.trim()),
        isLunarCalendar: isLunarCalendar.value,
        hasLeapMonth: hasLeapMonth.value,
        languageCode: selectedLanguage.value,
        useTrueSolarTime: useTrueSolarTime.value,
      );

      // Validate profile with Iztro service
      if (!_iztroService.validateBirthData(profile)) {
        throw Exception('Invalid birth data provided');
      }

      await _storageService.saveUserProfile(profile);

      // Save to recent calculations
      final recentCalculations = _storageService.loadRecentCalculations()
        ..insert(0, {
          'profile_name': profile.name ?? 'Unknown',
          'birth_date': profile.birthDate.toIso8601String(),
          'location': profile.locationName ?? 'Unknown',
          'created_at': DateTime.now().toIso8601String(),
        });

      // Keep only last 10 calculations
      if (recentCalculations.length > 10) {
        recentCalculations.removeRange(10, recentCalculations.length);
      }

      await _storageService.saveRecentCalculations(recentCalculations);

      Get
        ..snackbar(
          'Success',
          'Profile saved successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        )
        // Go back to home
        ..back(result: profile);
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[InputController] Save error: $e');
      }
      Get.snackbar(
        'Error',
        'Failed to save profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Comprehensive form validation using ValidationService
  Future<bool> validateForm() async {
    if (!formKey.currentState!.validate()) return false;

    final results = ValidationService.validateUserProfileComplete(
      name: nameController.text.trim().isEmpty
          ? null
          : nameController.text.trim(),
      birthDate: selectedDate.value,
      birthTime: DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
        selectedHour.value,
        selectedMinute.value,
      ),
      location: locationController.text.trim().isEmpty
          ? null
          : locationController.text.trim(),
      latitude: double.tryParse(latitudeController.text),
      longitude: double.tryParse(longitudeController.text),
      gender: selectedGender.value,
      calendarType: isLunarCalendar.value ? 'lunar' : 'solar',
      languageCode: selectedLanguage.value,
    );

    if (ValidationService.hasErrors(results)) {
      final errors = ValidationService.getErrorMessages(results);
      Get.snackbar(
        'Validation Error',
        errors.first,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (ValidationService.hasWarnings(results)) {
      final warnings = ValidationService.getWarningMessages(results);
      if (kDebugMode) {
        print('[InputController] Warnings: ${warnings.join(', ')}');
      }
    }

    return true;
  }

  /// Smart location detection and auto-fill
  Future<void> detectLocation() async {
    try {
      isLoading.value = true;

      // TODO: Implement location detection
      // For now, set a default location
      locationController.text = 'New York, NY';
      latitudeController.text = '40.7128';
      longitudeController.text = '-74.0060';

      Get.snackbar(
        'Location Set',
        'Location set to New York, NY',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } on Exception catch (e) {
      Get.snackbar(
        'Location Error',
        'Failed to detect location: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Reset form to defaults
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
    selectedLanguage.value = 'en';
    useTrueSolarTime.value = true;
  }

  /// Validate form fields (for individual field validation)
  String? validateName(String? value) {
    final result = ValidationService.validateName(value);
    return result.hasError ? result.message : null;
  }

  String? validateLatitude(String? value) {
    if (value == null || value.isEmpty) {
      return 'Latitude is required';
    }

    final lat = double.tryParse(value);
    if (lat == null) {
      return 'Invalid latitude format';
    }

    final result = ValidationService.validateCoordinates(lat, 0);
    return result.hasError ? 'Invalid latitude' : null;
  }

  String? validateLongitude(String? value) {
    if (value == null || value.isEmpty) {
      return 'Longitude is required';
    }

    final lng = double.tryParse(value);
    if (lng == null) {
      return 'Invalid longitude format';
    }

    final result = ValidationService.validateCoordinates(0, lng);
    return result.hasError ? 'Invalid longitude' : null;
  }

  String? validateLocation(String? value) {
    final result = ValidationService.validateLocation(value);
    return result.hasError ? result.message : null;
  }

  /// Auto-suggest time based on location (approximate sunrise time)
  void suggestOptimalTime() {
    // Set time to approximate sunrise (6:00 AM) for better chart quality
    selectedHour.value = 6;
    selectedMinute.value = 0;

    Get.snackbar(
      'Time Suggestion',
      'Set to 6:00 AM (approximate sunrise)',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.amber,
      colorText: Colors.black,
    );
  }
}

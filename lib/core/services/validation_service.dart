import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:intl/intl.dart';

/// [ValidationService] - Comprehensive input validation service
/// Provides validation for user input data in astrological calculations
class ValidationService {
  /// [validateName] - Validate user name input
  static ValidationResult validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return ValidationResult.error('Name is required');
    }

    final trimmedName = name.trim();

    if (trimmedName.length < 2) {
      return ValidationResult.error('Name must be at least 2 characters');
    }

    if (trimmedName.length > 50) {
      return ValidationResult.error('Name must be less than 50 characters');
    }

    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    final nameRegex = RegExp(r"^[a-zA-Z\u4e00-\u9fff\s\-'\.]+$");
    if (!nameRegex.hasMatch(trimmedName)) {
      return ValidationResult.error('Name contains invalid characters');
    }

    return ValidationResult.success(trimmedName);
  }

  /// [validateBirthDate] - Validate birth date
  static ValidationResult validateBirthDate(DateTime? birthDate) {
    if (birthDate == null) {
      return ValidationResult.error('Birth date is required');
    }

    final now = DateTime.now();
    final minDate = DateTime(AppConstants.minYear);
    final maxDate = DateTime(AppConstants.maxYear, 12, 31);

    if (birthDate.isBefore(minDate)) {
      return ValidationResult.error(
        'Birth date cannot be before ${AppConstants.minYear}',
      );
    }

    if (birthDate.isAfter(maxDate)) {
      return ValidationResult.error(
        'Birth date cannot be after ${AppConstants.maxYear}',
      );
    }

    if (birthDate.isAfter(now)) {
      return ValidationResult.error('Birth date cannot be in the future');
    }

    return ValidationResult.success(birthDate);
  }

  /// [validateBirthTime] - Validate birth time
  static ValidationResult validateBirthTime(DateTime? birthTime) {
    if (birthTime == null) {
      return ValidationResult.error('Birth time is required');
    }

    // Check if time is valid (0-23 hours, 0-59 minutes)
    if (birthTime.hour < 0 || birthTime.hour > 23) {
      return ValidationResult.error('Invalid hour (must be 0-23)');
    }

    if (birthTime.minute < 0 || birthTime.minute > 59) {
      return ValidationResult.error('Invalid minute (must be 0-59)');
    }

    return ValidationResult.success(birthTime);
  }

  /// [validateLocation] - Validate location input
  static ValidationResult validateLocation(String? location) {
    if (location == null || location.trim().isEmpty) {
      return ValidationResult.error('Location is required');
    }

    final trimmedLocation = location.trim();

    if (trimmedLocation.length < 2) {
      return ValidationResult.error('Location must be at least 2 characters');
    }

    if (trimmedLocation.length > 100) {
      return ValidationResult.error(
        'Location must be less than 100 characters',
      );
    }

    return ValidationResult.success(trimmedLocation);
  }

  /// [validateCoordinates] - Validate latitude and longitude
  static ValidationResult validateCoordinates(
    double? latitude,
    double? longitude,
  ) {
    if (latitude == null || longitude == null) {
      return ValidationResult.error('Coordinates are required');
    }

    if (latitude < AppConstants.minLatitude ||
        latitude > AppConstants.maxLatitude) {
      return ValidationResult.error(
        'Latitude must be between ${AppConstants.minLatitude} and ${AppConstants.maxLatitude}',
      );
    }

    if (longitude < AppConstants.minLongitude ||
        longitude > AppConstants.maxLongitude) {
      return ValidationResult.error(
        'Longitude must be between ${AppConstants.minLongitude} and ${AppConstants.maxLongitude}',
      );
    }

    return ValidationResult.success({
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  /// [validateGender] - Validate gender selection
  static ValidationResult validateGender(String? gender) {
    if (gender == null || gender.trim().isEmpty) {
      return ValidationResult.error('Gender is required');
    }

    const validGenders = ['male', 'female'];
    if (!validGenders.contains(gender)) {
      return ValidationResult.error('Invalid gender selection');
    }

    return ValidationResult.success(gender);
  }

  /// [validateCalendarType] - Validate calendar type
  static ValidationResult validateCalendarType(String? calendarType) {
    if (calendarType == null || calendarType.trim().isEmpty) {
      return ValidationResult.error('Calendar type is required');
    }

    const validCalendarTypes = ['solar', 'lunar'];
    if (!validCalendarTypes.contains(calendarType)) {
      return ValidationResult.error('Invalid calendar type');
    }

    return ValidationResult.success(calendarType);
  }

  /// [validateLanguage] - Validate language selection
  static ValidationResult validateLanguage(String? languageCode) {
    if (languageCode == null || languageCode.trim().isEmpty) {
      return ValidationResult.error('Language is required');
    }

    const supportedLanguages = ['en', 'zh', 'ja', 'ko', 'th', 'vi'];
    if (!supportedLanguages.contains(languageCode)) {
      return ValidationResult.error('Unsupported language');
    }

    return ValidationResult.success(languageCode);
  }

  /// [validateTimezone] - Validate timezone
  static ValidationResult validateTimezone(String? timezone) {
    if (timezone == null || timezone.trim().isEmpty) {
      return ValidationResult.warning(
        'Timezone not specified, using system default',
      );
    }

    // Basic timezone validation (can be enhanced with proper timezone library)
    if (timezone.length > 50) {
      return ValidationResult.error('Invalid timezone format');
    }

    return ValidationResult.success(timezone);
  }

  /// [validateYear] - Validate year input for fortune analysis
  static ValidationResult validateYear(int? year) {
    if (year == null) {
      return ValidationResult.error('Year is required');
    }

    final currentYear = DateTime.now().year;

    if (year < AppConstants.minYear || year > AppConstants.maxYear) {
      return ValidationResult.error(
        'Year must be between ${AppConstants.minYear} and ${AppConstants.maxYear}',
      );
    }

    // Allow future years for fortune prediction
    if (year > currentYear + 50) {
      return ValidationResult.warning('Year is far in the future');
    }

    return ValidationResult.success(year);
  }

  /// [validateUserProfileComplete] - Validate complete user profile
  static List<ValidationResult> validateUserProfileComplete({
    required String? name,
    required DateTime? birthDate,
    required DateTime? birthTime,
    required String? location,
    required String? gender,
    required String? calendarType,
    required String? languageCode,
    double? latitude,
    double? longitude,
    String? timezone,
  }) {
    final results = <ValidationResult>[
      validateName(name),
      validateBirthDate(birthDate),
      validateBirthTime(birthTime),
      validateLocation(location),
    ];

    if (latitude != null && longitude != null) {
      results.add(validateCoordinates(latitude, longitude));
    }

    results
      ..add(validateGender(gender))
      ..add(validateCalendarType(calendarType))
      ..add(validateLanguage(languageCode));

    if (timezone != null) {
      results.add(validateTimezone(timezone));
    }

    return results;
  }

  /// [hasErrors] - Check if validation results contain errors
  static bool hasErrors(List<ValidationResult> results) {
    return results.any((result) => result.type == ValidationResultType.error);
  }

  /// [hasWarnings] - Check if validation results contain warnings
  static bool hasWarnings(List<ValidationResult> results) {
    return results.any((result) => result.type == ValidationResultType.warning);
  }

  /// [getErrorMessages] - Get all error messages
  static List<String> getErrorMessages(List<ValidationResult> results) {
    return results
        .where((result) => result.type == ValidationResultType.error)
        .map((result) => result.message)
        .toList();
  }

  /// [getWarningMessages] - Get all warning messages
  static List<String> getWarningMessages(List<ValidationResult> results) {
    return results
        .where((result) => result.type == ValidationResultType.warning)
        .map((result) => result.message)
        .toList();
  }

  /// [formatValidationSummary] - Format validation results for display
  static String formatValidationSummary(List<ValidationResult> results) {
    final errors = getErrorMessages(results);
    final warnings = getWarningMessages(results);

    final summary = StringBuffer();

    if (errors.isNotEmpty) {
      summary.writeln('Errors:');
      for (final error in errors) {
        summary.writeln('• $error');
      }
    }

    if (warnings.isNotEmpty) {
      if (errors.isNotEmpty) summary.writeln();
      summary.writeln('Warnings:');
      for (final warning in warnings) {
        summary.writeln('• $warning');
      }
    }

    return summary.toString().trim();
  }

  /// [validateDateTimeString] - Validate date time string format
  static ValidationResult validateDateTimeString(
    String? dateTimeStr,
    String format,
  ) {
    if (dateTimeStr == null || dateTimeStr.trim().isEmpty) {
      return ValidationResult.error('Date time string is required');
    }

    try {
      final formatter = DateFormat(format);
      final dateTime = formatter.parse(dateTimeStr);
      return ValidationResult.success(dateTime);
    } on FormatException catch (e) {
      if (kDebugMode) {
        print('[ValidationService] Date parsing error: $e');
      }
      return ValidationResult.error('Invalid date format. Expected: $format');
    }
  }

  /// [sanitizeInput] - Sanitize user input
  static String sanitizeInput(String input) {
    return input
        .trim()
        .replaceAll(
          RegExp(r'\s+'),
          ' ',
        ) // Replace multiple spaces with single space
        .replaceAll(
          RegExp(r'[^\w\s\-\.]'),
          '',
        ); // Remove special chars except basic punctuation
  }
}

/// [ValidationResult] - Result of validation operation
class ValidationResult {
  const ValidationResult._({
    required this.type,
    required this.message,
    this.data,
  });

  factory ValidationResult.success(dynamic data) {
    return ValidationResult._(
      type: ValidationResultType.success,
      message: 'Valid',
      data: data,
    );
  }

  factory ValidationResult.error(String message) {
    return ValidationResult._(
      type: ValidationResultType.error,
      message: message,
    );
  }

  factory ValidationResult.warning(String message) {
    return ValidationResult._(
      type: ValidationResultType.warning,
      message: message,
    );
  }

  final ValidationResultType type;
  final String message;
  final dynamic data;

  bool get isValid => type == ValidationResultType.success;
  bool get hasError => type == ValidationResultType.error;
  bool get hasWarning => type == ValidationResultType.warning;
}

/// [ValidationResultType] - Type of validation result
enum ValidationResultType {
  success,
  warning,
  error,
}

import 'package:flutter/foundation.dart' show immutable;

/// [UserProfile] - Comprehensive user profile model for astrological calculations
/// Contains all birth information and user preferences needed for accurate chart generation
@immutable
class UserProfile {
  /// Constructor with required and optional parameters
  const UserProfile({
    required this.birthDate,
    required this.birthHour,
    required this.birthMinute,
    required this.gender,
    required this.latitude,
    required this.longitude,
    this.locationName,
    this.timeZone,
    this.isLunarCalendar = false,
    this.hasLeapMonth = false,
    this.languageCode = 'en',
    this.useTraditionalChinese = false,
    this.name,
    this.notes,
    this.useTrueSolarTime = true,
    this.showBrightness = true,
    this.showTransformations = true,
  });

  /// Create UserProfile from JSON (for persistence)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      birthDate: DateTime.parse(json['birthDate'] as String),
      birthHour: json['birthHour'] as int,
      birthMinute: json['birthMinute'] as int,
      gender: json['gender'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      locationName: json['locationName'] as String?,
      timeZone: json['timeZone'] as String?,
      isLunarCalendar: json['isLunarCalendar'] as bool? ?? false,
      hasLeapMonth: json['hasLeapMonth'] as bool? ?? false,
      languageCode: json['languageCode'] as String? ?? 'en',
      useTraditionalChinese: json['useTraditionalChinese'] as bool? ?? false,
      name: json['name'] as String?,
      notes: json['notes'] as String?,
      useTrueSolarTime: json['useTrueSolarTime'] as bool? ?? true,
      showBrightness: json['showBrightness'] as bool? ?? true,
      showTransformations: json['showTransformations'] as bool? ?? true,
    );
  }

  /// User's birth date and time information
  final DateTime birthDate;
  final int birthHour;
  final int birthMinute;

  /// User's gender ('male' or 'female')
  final String gender;

  /// Geographic location for accurate time zone and solar calculations
  final double latitude;
  final double longitude;
  final String? locationName;
  final String? timeZone;

  /// Calendar type preferences
  final bool isLunarCalendar;
  final bool hasLeapMonth;

  /// Language and display preferences
  final String languageCode;
  final bool useTraditionalChinese;

  /// User identification (optional)
  final String? name;
  final String? notes;

  /// Chart calculation settings
  final bool useTrueSolarTime;
  final bool showBrightness;
  final bool showTransformations;

  /// Convert UserProfile to JSON (for persistence)
  Map<String, dynamic> toJson() {
    return {
      'birthDate': birthDate.toIso8601String(),
      'birthHour': birthHour,
      'birthMinute': birthMinute,
      'gender': gender,
      'latitude': latitude,
      'longitude': longitude,
      'locationName': locationName,
      'timeZone': timeZone,
      'isLunarCalendar': isLunarCalendar,
      'hasLeapMonth': hasLeapMonth,
      'languageCode': languageCode,
      'useTraditionalChinese': useTraditionalChinese,
      'name': name,
      'notes': notes,
      'useTrueSolarTime': useTrueSolarTime,
      'showBrightness': showBrightness,
      'showTransformations': showTransformations,
    };
  }

  /// Get gender as string for calculations (will be used when dart_iztro is properly integrated)
  String get genderForCalculation => gender;

  /// Get formatted birth time for display
  String get formattedBirthTime {
    final hour = birthHour.toString().padLeft(2, '0');
    final minute = birthMinute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Get location string for display
  String get locationString {
    if (locationName != null && locationName!.isNotEmpty) {
      return locationName!;
    }
    return '${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}';
  }

  /// Create copy with updated values
  UserProfile copyWith({
    DateTime? birthDate,
    int? birthHour,
    int? birthMinute,
    String? gender,
    double? latitude,
    double? longitude,
    String? locationName,
    String? timeZone,
    bool? isLunarCalendar,
    bool? hasLeapMonth,
    String? languageCode,
    bool? useTraditionalChinese,
    String? name,
    String? notes,
    bool? useTrueSolarTime,
    bool? showBrightness,
    bool? showTransformations,
  }) {
    return UserProfile(
      birthDate: birthDate ?? this.birthDate,
      birthHour: birthHour ?? this.birthHour,
      birthMinute: birthMinute ?? this.birthMinute,
      gender: gender ?? this.gender,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      timeZone: timeZone ?? this.timeZone,
      isLunarCalendar: isLunarCalendar ?? this.isLunarCalendar,
      hasLeapMonth: hasLeapMonth ?? this.hasLeapMonth,
      languageCode: languageCode ?? this.languageCode,
      useTraditionalChinese:
          useTraditionalChinese ?? this.useTraditionalChinese,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      useTrueSolarTime: useTrueSolarTime ?? this.useTrueSolarTime,
      showBrightness: showBrightness ?? this.showBrightness,
      showTransformations: showTransformations ?? this.showTransformations,
    );
  }

  /// Validate user profile data
  bool get isValid {
    // Check required fields
    if (gender != 'male' && gender != 'female') return false;
    if (birthHour < 0 || birthHour > 23) return false;
    if (birthMinute < 0 || birthMinute > 59) return false;
    if (latitude < -90 || latitude > 90) return false;
    if (longitude < -180 || longitude > 180) return false;

    // Check birth date is reasonable
    final now = DateTime.now();
    final minDate = DateTime(1900);
    if (birthDate.isBefore(minDate) || birthDate.isAfter(now)) return false;

    return true;
  }

  @override
  String toString() {
    return 'UserProfile(name: $name, birthDate: $birthDate, '
        'location: $locationString, gender: $gender)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.birthDate == birthDate &&
        other.birthHour == birthHour &&
        other.birthMinute == birthMinute &&
        other.gender == gender &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return Object.hash(
      birthDate,
      birthHour,
      birthMinute,
      gender,
      latitude,
      longitude,
    );
  }
}

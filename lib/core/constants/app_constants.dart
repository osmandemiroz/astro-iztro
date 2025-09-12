/// [AppConstants] - Core application constants
class AppConstants {
  // App Information
  static const String appName = 'Astro Iztro';
  static const String appVersion = '1.0.0';

  // UI Constants
  static const double borderRadius = 12;
  static const double cardElevation = 4;
  static const double defaultPadding = 16;
  static const double smallPadding = 8;
  static const double largePadding = 24;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Chart dimensions
  static const double chartSize = 300;
  static const double palaceSize = 80;
  static const double starSize = 24;

  // Font families (using available fonts)
  static const String primaryFont =
      'SFProDisplay'; // Using Raleway as SFProDisplay replacement
  static const String decorativeFont = 'CinzelDecorative';
  static const String chineseFont = 'MaShanZheng';
  static const String monoFont = 'B612Mono';

  // API and Storage keys
  static const String userProfileKey = 'user_profile';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';
  static const String calculationPrefsKey = 'calculation_preferences';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String firstLaunchKey = 'first_launch';

  // Validation constants
  static const int minYear = 1900;
  static const int maxYear = 2100;
  static const double maxLatitude = 90;
  static const double minLatitude = -90;
  static const double maxLongitude = 180;
  static const double minLongitude = -180;

  // Palace names in English and Chinese
  static const List<String> palaceNames = [
    'Life',
    'Siblings',
    'Spouse',
    'Children',
    'Wealth',
    'Health',
    'Travel',
    'Friends',
    'Career',
    'Property',
    'Fortune',
    'Parents',
  ];

  static const List<String> palaceNamesZh = [
    '命宮',
    '兄弟宮',
    '夫妻宮',
    '子女宮',
    '財帛宮',
    '疾厄宮',
    '遷移宫',
    '奴僕宮',
    '官祿宮',
    '田宅宮',
    '福德宮',
    '父母宮',
  ];

  // Supported languages
  static const List<String> supportedLanguages = [
    'en',
    'zh',
    'zh-TW',
    'ja',
    'ko',
    'th',
    'vi',
  ];

  // Gender options
  static const String male = 'male';
  static const String female = 'female';

  // Calendar types
  static const String solarCalendar = 'solar';
  static const String lunarCalendar = 'lunar';
}

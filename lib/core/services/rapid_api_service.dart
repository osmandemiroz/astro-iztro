import 'dart:convert';

import 'package:astro_iztro/core/models/user_profile.dart';
import 'package:astro_iztro/core/services/rapid_api_tester.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// [RapidApiService] - Service for integrating RapidAPI astrology endpoints
/// Tests and integrates the provided API key for real astrology calculations
class RapidApiService {
  factory RapidApiService() => _instance;
  RapidApiService._internal();
  static final RapidApiService _instance = RapidApiService._internal();

  // [RapidApiService] - API key loaded from environment variables
  static String get _rapidApiKey {
    final apiKey = dotenv.env['RAPIDAPI_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
        'RAPIDAPI_KEY not found in environment variables. '
        'Please add your API key to the .env file.',
      );
    }
    return apiKey;
  }

  // [RapidApiService] - Common RapidAPI headers
  Map<String, String> _getHeaders(String hostName) {
    return {
      'Content-Type': 'application/json',
      'X-RapidAPI-Key': _rapidApiKey,
      'X-RapidAPI-Host': hostName,
    };
  }

  /// [testAstrologyAPIs] - Test various astrology APIs using the discovery system
  Future<Map<String, dynamic>> testAstrologyAPIs(UserProfile profile) async {
    if (kDebugMode) {
      print('[RapidApiService] Testing astrology APIs with provided key...');
    }

    // Use the new discovery system
    return await RapidApiTester.discoverWorkingAPIs();
  }

  /// [testHoroscopeAPI] - Test general horoscope API
  Future<Map<String, dynamic>> _testHoroscopeAPI(UserProfile profile) async {
    const baseUrl = 'https://horoscope-api.p.rapidapi.com';
    final zodiacSign = _getZodiacSign(profile.birthDate);

    final response = await http.get(
      Uri.parse('$baseUrl/sign/$zodiacSign'),
      headers: _getHeaders('horoscope-api.p.rapidapi.com'),
    );

    if (kDebugMode) {
      print('[RapidApiService] Horoscope API response: ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      return {
        'success': true,
        'data': json.decode(response.body),
        'api_name': 'Horoscope API',
        'endpoint': '$baseUrl/sign/$zodiacSign',
      };
    } else {
      return {
        'success': false,
        'status_code': response.statusCode,
        'body': response.body,
        'endpoint': '$baseUrl/sign/$zodiacSign',
      };
    }
  }

  /// [testAstrologyAPI] - Test comprehensive astrology API
  Future<Map<String, dynamic>> _testAstrologyAPI(UserProfile profile) async {
    const baseUrl = 'https://astrology-api7.p.rapidapi.com';

    final response = await http.post(
      Uri.parse('$baseUrl/natal-chart'),
      headers: _getHeaders('astrology-api7.p.rapidapi.com'),
      body: json.encode({
        'date':
            '${profile.birthDate.day}/${profile.birthDate.month}/${profile.birthDate.year}',
        'time':
            '${profile.birthHour.toString().padLeft(2, '0')}:${profile.birthMinute.toString().padLeft(2, '0')}',
        'place': {
          'latitude': profile.latitude,
          'longitude': profile.longitude,
        },
        'timezone': 'UTC+3', // Default timezone
      }),
    );

    if (kDebugMode) {
      print('[RapidApiService] Astrology API response: ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      return {
        'success': true,
        'data': json.decode(response.body),
        'api_name': 'Astrology API',
        'endpoint': '$baseUrl/natal-chart',
      };
    } else {
      return {
        'success': false,
        'status_code': response.statusCode,
        'body': response.body,
        'endpoint': '$baseUrl/natal-chart',
      };
    }
  }

  /// [testChineseAstrologyAPI] - Test Chinese astrology/BaZi API
  Future<Map<String, dynamic>> _testChineseAstrologyAPI(
    UserProfile profile,
  ) async {
    const baseUrl = 'https://chinese-astrology.p.rapidapi.com';

    final response = await http.post(
      Uri.parse('$baseUrl/bazi'),
      headers: _getHeaders('chinese-astrology.p.rapidapi.com'),
      body: json.encode({
        'birth_date': profile.birthDate.toIso8601String(),
        'birth_hour': profile.birthHour,
        'birth_minute': profile.birthMinute,
        'gender': profile.gender,
        'latitude': profile.latitude,
        'longitude': profile.longitude,
        'calendar_type': profile.isLunarCalendar ? 'lunar' : 'solar',
        'language': profile.languageCode,
      }),
    );

    if (kDebugMode) {
      print(
        '[RapidApiService] Chinese Astrology API response: ${response.statusCode}',
      );
    }

    if (response.statusCode == 200) {
      return {
        'success': true,
        'data': json.decode(response.body),
        'api_name': 'Chinese Astrology API',
        'endpoint': '$baseUrl/bazi',
      };
    } else {
      return {
        'success': false,
        'status_code': response.statusCode,
        'body': response.body,
        'endpoint': '$baseUrl/bazi',
      };
    }
  }

  /// [testDestinyAPI] - Test destiny/fortune analysis API
  Future<Map<String, dynamic>> _testDestinyAPI(UserProfile profile) async {
    const baseUrl = 'https://destiny-analysis.p.rapidapi.com';

    final response = await http.post(
      Uri.parse('$baseUrl/fortune'),
      headers: _getHeaders('destiny-analysis.p.rapidapi.com'),
      body: json.encode({
        'birth_date': profile.birthDate.toIso8601String(),
        'birth_time': '${profile.birthHour}:${profile.birthMinute}',
        'gender': profile.gender,
        'location': {
          'latitude': profile.latitude,
          'longitude': profile.longitude,
        },
        'analysis_year': DateTime.now().year,
        'language': profile.languageCode,
      }),
    );

    if (kDebugMode) {
      print('[RapidApiService] Destiny API response: ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      return {
        'success': true,
        'data': json.decode(response.body),
        'api_name': 'Destiny Analysis API',
        'endpoint': '$baseUrl/fortune',
      };
    } else {
      return {
        'success': false,
        'status_code': response.statusCode,
        'body': response.body,
        'endpoint': '$baseUrl/fortune',
      };
    }
  }

  /// [calculateFortuneForYear] - Calculate real fortune data for specific year
  Future<Map<String, dynamic>> calculateFortuneForYear(
    UserProfile profile,
    int year,
  ) async {
    if (kDebugMode) {
      print('[RapidApiService] Calculating fortune for year: $year');
    }

    // Use the new API discovery system
    final apiResults = await RapidApiTester.discoverWorkingAPIs();

    // Print discovery results for debugging
    RapidApiTester.printDiscoveryResults(apiResults);

    // Generate fortune from working APIs
    final fortuneData = RapidApiTester.generateFortuneFromWorkingAPI(
      apiResults,
      year,
    );

    if (kDebugMode) {
      print(
        '[RapidApiService] Fortune calculation completed: ${fortuneData['source']}',
      );
    }

    return fortuneData;
  }

  /// [transformApiResponseToFortune] - Transform API response to fortune format
  Map<String, dynamic> _transformApiResponseToFortune(
    Map<String, dynamic> apiData,
    int year,
  ) {
    final targetDate = DateTime(year);

    // Extract meaningful data from API response
    // This will vary based on which API actually works

    return {
      'date': targetDate.toIso8601String(),
      'grand_limit': _extractGrandLimit(apiData, year),
      'small_limit': _extractSmallLimit(apiData, year),
      'annual_fortune': _extractAnnualFortune(apiData, year),
      'monthly_fortune': _extractMonthlyFortune(apiData),
      'daily_fortune': _extractDailyFortune(apiData),
      'source': 'RapidAPI',
      'raw_data': apiData,
    };
  }

  /// [generateEnhancedMockFortune] - Generate more realistic mock data based on actual calculations
  Map<String, dynamic> _generateEnhancedMockFortune(
    UserProfile profile,
    int year,
  ) {
    final targetDate = DateTime(year);
    final age = year - profile.birthDate.year;

    // Calculate actual astrological periods
    final grandLimitPeriod = ((age ~/ 10) + 1) * 10;
    final chineseZodiac = _getChineseZodiac(profile.birthDate.year);
    final yearZodiac = _getChineseZodiac(year);

    return {
      'date': targetDate.toIso8601String(),
      'grand_limit':
          'Grand Limit Period: ${grandLimitPeriod - 9}-$grandLimitPeriod years',
      'small_limit': 'Small Limit: Age $age transition period',
      'annual_fortune':
          'Year of $yearZodiac - ${_getYearlyFortune(yearZodiac, chineseZodiac)}',
      'monthly_fortune':
          'Current monthly cycle: ${_getMonthlyFortune(DateTime.now())}',
      'daily_fortune': 'Daily influence: ${_getDailyFortune(DateTime.now())}',
      'source': 'Enhanced Calculation',
    };
  }

  // Helper methods for extracting data from various API responses
  String _extractGrandLimit(Map<String, dynamic> data, int year) {
    // Look for grand limit data in various API response formats
    if (data.containsKey('grand_limit')) return data['grand_limit'].toString();
    if (data.containsKey('major_cycle')) return data['major_cycle'].toString();
    return 'Grand Limit Analysis for $year';
  }

  String _extractSmallLimit(Map<String, dynamic> data, int year) {
    if (data.containsKey('small_limit')) return data['small_limit'].toString();
    if (data.containsKey('minor_cycle')) return data['minor_cycle'].toString();
    return 'Small Limit Transition $year';
  }

  String _extractAnnualFortune(Map<String, dynamic> data, int year) {
    if (data.containsKey('annual_fortune')) {
      return data['annual_fortune'].toString();
    }
    if (data.containsKey('yearly_forecast')) {
      return data['yearly_forecast'].toString();
    }
    if (data.containsKey('year_analysis')) {
      return data['year_analysis'].toString();
    }
    return 'Annual Fortune Analysis $year';
  }

  String _extractMonthlyFortune(Map<String, dynamic> data) {
    if (data.containsKey('monthly_fortune')) {
      return data['monthly_fortune'].toString();
    }
    if (data.containsKey('current_month')) {
      return data['current_month'].toString();
    }
    return 'Monthly Fortune Cycle';
  }

  String _extractDailyFortune(Map<String, dynamic> data) {
    if (data.containsKey('daily_fortune')) {
      return data['daily_fortune'].toString();
    }
    if (data.containsKey('today')) return data['today'].toString();
    return 'Daily Fortune Analysis';
  }

  // Helper methods for enhanced calculations
  String _getZodiacSign(DateTime birthDate) {
    final day = birthDate.day;
    final month = birthDate.month;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return 'aries';
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return 'taurus';
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) return 'gemini';
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return 'cancer';
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return 'leo';
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return 'virgo';
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return 'libra';
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return 'scorpio';
    }
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return 'sagittarius';
    }
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return 'capricorn';
    }
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return 'aquarius';
    }
    return 'pisces';
  }

  String _getChineseZodiac(int year) {
    const zodiacAnimals = [
      'Rat',
      'Ox',
      'Tiger',
      'Rabbit',
      'Dragon',
      'Snake',
      'Horse',
      'Goat',
      'Monkey',
      'Rooster',
      'Dog',
      'Pig',
    ];
    return zodiacAnimals[(year - 4) % 12];
  }

  String _getYearlyFortune(String yearZodiac, String birthZodiac) {
    if (yearZodiac == birthZodiac) {
      return 'Personal Year - Time for self-development';
    }
    return 'Favorable interactions with $yearZodiac energy';
  }

  String _getMonthlyFortune(DateTime date) {
    final months = [
      'New beginnings energy',
      'Relationship focus',
      'Communication clarity',
      'Home and family matters',
      'Creative expression',
      'Health and service',
      'Partnership harmony',
      'Transformation period',
      'Wisdom and learning',
      'Career advancement',
      'Innovation and friendship',
      'Spiritual growth',
    ];
    return months[date.month - 1];
  }

  String _getDailyFortune(DateTime date) {
    final dayOfWeek = date.weekday;
    const dailyInfluences = [
      'Leadership and initiative',
      'Partnerships and cooperation',
      'Communication and learning',
      'Nurturing and care',
      'Creativity and self-expression',
      'Service and attention to detail',
      'Balance and reflection',
    ];
    return dailyInfluences[dayOfWeek - 1];
  }
}

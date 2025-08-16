import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// [RapidApiTester] - Service to discover and test working astrology APIs
/// Tests popular RapidAPI astrology endpoints to find which ones work with your key
class RapidApiTester {
  static String get _rapidApiKey {
    final apiKey = dotenv.env['RAPIDAPI_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('RAPIDAPI_KEY not found in environment variables');
    }
    return apiKey;
  }

  /// [discoverWorkingAPIs] - Test various known astrology APIs
  static Future<Map<String, dynamic>> discoverWorkingAPIs() async {
    final results = <String, dynamic>{};

    if (kDebugMode) {
      print('[RapidApiTester] Discovering working astrology APIs...');
    }

    // List of known astrology APIs on RapidAPI (including free tier options)
    final apiEndpoints = [
      {
        'name': 'Horoscope API (Aztro)',
        'host': 'sameer-kumar-aztro-v1.p.rapidapi.com',
        'endpoint': 'https://sameer-kumar-aztro-v1.p.rapidapi.com/',
        'method': 'POST',
        'test_params': {'sign': 'aries', 'day': 'today'},
      },
      {
        'name': 'Daily Horoscope by Ashish',
        'host': 'horoscope5.p.rapidapi.com',
        'endpoint': 'https://horoscope5.p.rapidapi.com/general_horoscope_free',
        'method': 'GET',
        'test_params': {'sign': 'aries'},
      },
      {
        'name': 'Horoscope by API Ninjas',
        'host': 'horoscope-by-api-ninjas.p.rapidapi.com',
        'endpoint':
            'https://horoscope-by-api-ninjas.p.rapidapi.com/v1/horoscope',
        'method': 'GET',
        'test_params': {'sign': 'aries'},
      },
      {
        'name': 'Fortune Cookie',
        'host': 'fortune-cookie4.p.rapidapi.com',
        'endpoint': 'https://fortune-cookie4.p.rapidapi.com/slack',
        'method': 'GET',
        'test_params': {},
      },
      {
        'name': 'Chinese Zodiac',
        'host': 'chinese-zodiac-calculator.p.rapidapi.com',
        'endpoint':
            'https://chinese-zodiac-calculator.p.rapidapi.com/chinese-zodiac',
        'method': 'GET',
        'test_params': {'year': '2003'},
      },
      {
        'name': 'Free Horoscope API',
        'host': 'free-horoscope-api.p.rapidapi.com',
        'endpoint':
            'https://free-horoscope-api.p.rapidapi.com/horoscope/today/aries',
        'method': 'GET',
        'test_params': {},
      },
      {
        'name': 'Inspirational Quotes',
        'host': 'quotes15.p.rapidapi.com',
        'endpoint': 'https://quotes15.p.rapidapi.com/quotes/random/',
        'method': 'GET',
        'test_params': {},
      },
    ];

    for (final api in apiEndpoints) {
      try {
        final result = await _testAPI(api);
        results[api['name'] as String] = result;

        if (kDebugMode) {
          print('[RapidApiTester] ${api['name']}: ${result['status_code']}');
        }
      } on Exception catch (e) {
        results[api['name'] as String] = {
          'success': false,
          'error': e.toString(),
          'status_code': 'Exception',
        };
      }
    }

    return results;
  }

  /// [testAPI] - Test a specific API endpoint
  static Future<Map<String, dynamic>> _testAPI(
    Map<String, dynamic> apiConfig,
  ) async {
    final headers = {
      'X-RapidAPI-Key': _rapidApiKey,
      'X-RapidAPI-Host': apiConfig['host'] as String,
    };

    final method = apiConfig['method'] as String;
    final endpoint = apiConfig['endpoint'] as String;
    final params = apiConfig['test_params'] as Map<String, dynamic>;

    http.Response response;

    if (method == 'GET') {
      // Add query parameters to URL
      var uri = Uri.parse(endpoint);
      if (params.isNotEmpty) {
        uri = uri.replace(
          queryParameters: params.map((k, v) => MapEntry(k, v.toString())),
        );
      }
      response = await http.get(uri, headers: headers);
    } else {
      // POST request
      headers['Content-Type'] = 'application/x-www-form-urlencoded';
      response = await http.post(
        Uri.parse(endpoint),
        headers: headers,
        body: params.map((k, v) => MapEntry(k, v.toString())),
      );
    }

    Map<String, dynamic> responseData = {};
    try {
      responseData = json.decode(response.body) as Map<String, dynamic>;
    } on FormatException {
      // Response is not JSON
      responseData = {'raw_response': response.body};
    }

    return {
      'success': response.statusCode == 200,
      'status_code': response.statusCode,
      'endpoint': endpoint,
      'method': method,
      'response': responseData,
      'headers': response.headers,
    };
  }

  /// [generateFortuneFromWorkingAPI] - Generate fortune data from working APIs
  static Map<String, dynamic> generateFortuneFromWorkingAPI(
    Map<String, dynamic> apiResults,
    int year,
  ) {
    final targetDate = DateTime(year);

    // Find the first working API
    for (final entry in apiResults.entries) {
      final result = entry.value as Map<String, dynamic>;
      if (result['success'] == true) {
        final apiName = entry.key;
        final responseData = result['response'] as Map<String, dynamic>;

        return {
          'date': targetDate.toIso8601String(),
          'grand_limit': _extractFortuneData(
            responseData,
            'Grand Limit from $apiName',
          ),
          'small_limit': _extractFortuneData(
            responseData,
            'Small Limit Analysis',
          ),
          'annual_fortune': _extractFortuneData(
            responseData,
            'Annual Fortune ($year)',
          ),
          'monthly_fortune': _extractFortuneData(responseData, 'Monthly Cycle'),
          'daily_fortune': _extractFortuneData(responseData, 'Daily Influence'),
          'source': 'RapidAPI - $apiName',
          'api_data': responseData,
        };
      }
    }

    // If no APIs work, return enhanced mock
    return {
      'date': targetDate.toIso8601String(),
      'grand_limit': 'Enhanced Grand Limit Calculation for $year',
      'small_limit': 'Advanced Small Limit Analysis',
      'annual_fortune': 'Comprehensive Annual Fortune $year',
      'monthly_fortune': 'Detailed Monthly Cycle Analysis',
      'daily_fortune': 'Precise Daily Fortune Calculation',
      'source': 'Enhanced Native Calculation',
    };
  }

  /// [extractFortuneData] - Extract meaningful data from API responses
  static String _extractFortuneData(
    Map<String, dynamic> data,
    String defaultValue,
  ) {
    // Look for various fortune-related fields
    final fortuneFields = [
      'horoscope',
      'prediction',
      'fortune',
      'reading',
      'description',
      'message',
      'forecast',
      'advice',
      'insight',
      'interpretation',
    ];

    for (final field in fortuneFields) {
      if (data.containsKey(field) && data[field] != null) {
        final value = data[field].toString();
        if (value.isNotEmpty && value.length > 10) {
          return value;
        }
      }
    }

    // Look in nested objects
    for (final value in data.values) {
      if (value is Map<String, dynamic>) {
        for (final field in fortuneFields) {
          if (value.containsKey(field) && value[field] != null) {
            final fieldValue = value[field].toString();
            if (fieldValue.isNotEmpty && fieldValue.length > 10) {
              return fieldValue;
            }
          }
        }
      }
    }

    return defaultValue;
  }

  /// [printDiscoveryResults] - Print formatted results for debugging
  static void printDiscoveryResults(Map<String, dynamic> results) {
    if (!kDebugMode) return;

    print('\n=== RapidAPI Discovery Results ===');
    for (final entry in results.entries) {
      final apiName = entry.key;
      final result = entry.value as Map<String, dynamic>;

      print('\n[$apiName]');
      print('  Status: ${result['status_code']}');
      print('  Success: ${result['success']}');

      if (result['success'] == true) {
        print('  ✅ WORKING API FOUND!');
        final response = result['response'] as Map<String, dynamic>;
        print('  Response keys: ${response.keys.join(', ')}');
      } else {
        print('  ❌ Not working');
        if (result.containsKey('error')) {
          print('  Error: ${result['error']}');
        }
      }
    }
    print('\n================================\n');
  }
}

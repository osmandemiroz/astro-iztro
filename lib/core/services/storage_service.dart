import 'dart:convert';

import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/models/bazi_data.dart';
import 'package:astro_iztro/core/models/chart_data.dart';
import 'package:astro_iztro/core/models/user_profile.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:shared_preferences/shared_preferences.dart';

/// [StorageService] - Local data persistence service using SharedPreferences
/// Handles saving and loading of user profiles, charts, and app preferences
class StorageService {
  factory StorageService() => _instance;
  StorageService._internal();
  static final StorageService _instance = StorageService._internal();

  SharedPreferences? _prefs;

  /// [initialize] - Initialize SharedPreferences
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Ensure SharedPreferences is initialized
  SharedPreferences get prefs {
    if (_prefs == null) {
      throw StorageException(
        'StorageService not initialized. Call initialize() first.',
      );
    }
    return _prefs!;
  }

  /// [saveUserProfile] - Save user profile data
  Future<bool> saveUserProfile(UserProfile profile) async {
    try {
      final jsonString = json.encode(profile.toJson());
      return await prefs.setString(AppConstants.userProfileKey, jsonString);
    } catch (e) {
      throw StorageException('Failed to save user profile: $e');
    }
  }

  /// [loadUserProfile] - Load saved user profile
  UserProfile? loadUserProfile() {
    try {
      final jsonString = prefs.getString(AppConstants.userProfileKey);
      if (jsonString != null) {
        final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
        return UserProfile.fromJson(jsonMap);
      }
      return null;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[StorageService] Failed to load user profile: $e');
      }
      return null;
    }
  }

  /// [saveChartData] - Save chart calculation results
  Future<bool> saveChartData(String profileId, ChartData chartData) async {
    try {
      final key = 'chart_data_$profileId';
      final jsonString = json.encode(chartData.toJson());
      return await prefs.setString(key, jsonString);
    } catch (e) {
      throw StorageException('Failed to save chart data: $e');
    }
  }

  /// [loadChartData] - Load saved chart data
  /// Note: This returns the JSON data only, as ChartData requires an Astrolabe instance
  Map<String, dynamic>? loadChartDataJson(String profileId) {
    try {
      final key = 'chart_data_$profileId';
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        return json.decode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[StorageService] Failed to load chart data: $e');
      }
      return null;
    }
  }

  /// [saveBaZiData] - Save BaZi calculation results
  Future<bool> saveBaZiData(String profileId, BaZiData baziData) async {
    try {
      final key = 'bazi_data_$profileId';
      final jsonString = json.encode(baziData.toJson());
      return await prefs.setString(key, jsonString);
    } catch (e) {
      throw StorageException('Failed to save BaZi data: $e');
    }
  }

  /// [loadBaZiData] - Load saved BaZi data
  BaZiData? loadBaZiData(String profileId) {
    try {
      final key = 'bazi_data_$profileId';
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
        return BaZiData.fromJson(jsonMap);
      }
      return null;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[StorageService] Failed to load BaZi data: $e');
      }
      return null;
    }
  }

  /// [saveThemeMode] - Save theme preference
  Future<bool> saveThemeMode(String themeMode) async {
    try {
      return await prefs.setString(AppConstants.themeKey, themeMode);
    } catch (e) {
      throw StorageException('Failed to save theme mode: $e');
    }
  }

  /// [loadThemeMode] - Load theme preference
  String loadThemeMode() {
    try {
      return prefs.getString(AppConstants.themeKey) ?? 'system';
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[StorageService] Failed to load theme mode: $e');
      }
      return 'system';
    }
  }

  /// [saveLanguage] - Save language preference
  Future<bool> saveLanguage(String languageCode) async {
    try {
      return await prefs.setString(AppConstants.languageKey, languageCode);
    } catch (e) {
      throw StorageException('Failed to save language: $e');
    }
  }

  /// [loadLanguage] - Load language preference
  String loadLanguage() {
    try {
      return prefs.getString(AppConstants.languageKey) ?? 'en';
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[StorageService] Failed to load language: $e');
      }
      return 'en';
    }
  }

  /// [saveCalculationPreferences] - Save calculation preferences
  Future<bool> saveCalculationPreferences(
    Map<String, dynamic> preferences,
  ) async {
    try {
      final jsonString = json.encode(preferences);
      return await prefs.setString(
        AppConstants.calculationPrefsKey,
        jsonString,
      );
    } on Exception catch (e) {
      throw StorageException('Failed to save calculation preferences: $e');
    }
  }

  /// [loadCalculationPreferences] - Load calculation preferences
  Map<String, dynamic> loadCalculationPreferences() {
    try {
      final jsonString = prefs.getString(AppConstants.calculationPrefsKey);
      if (jsonString != null) {
        return json.decode(jsonString) as Map<String, dynamic>;
      }
      return _getDefaultCalculationPreferences();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[StorageService] Failed to load calculation preferences: $e');
      }
      return _getDefaultCalculationPreferences();
    }
  }

  /// [saveUserProfiles] - Save multiple user profiles (for family/friends)
  Future<bool> saveUserProfiles(List<UserProfile> profiles) async {
    try {
      final jsonList = profiles.map((profile) => profile.toJson()).toList();
      final jsonString = json.encode(jsonList);
      return await prefs.setString('user_profiles_list', jsonString);
    } on Exception catch (e) {
      throw StorageException('Failed to save user profiles: $e');
    }
  }

  /// [loadUserProfiles] - Load multiple user profiles
  List<UserProfile> loadUserProfiles() {
    try {
      final jsonString = prefs.getString('user_profiles_list');
      if (jsonString != null) {
        final jsonList = json.decode(jsonString) as List;
        return jsonList
            .map((json) => UserProfile.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[StorageService] Failed to load user profiles: $e');
      }
      return [];
    }
  }

  /// [saveRecentCalculations] - Save recent calculation history
  Future<bool> saveRecentCalculations(
    List<Map<String, dynamic>> calculations,
  ) async {
    try {
      final jsonString = json.encode(calculations);
      return await prefs.setString('recent_calculations', jsonString);
    } catch (e) {
      throw StorageException('Failed to save recent calculations: $e');
    }
  }

  /// [loadRecentCalculations] - Load recent calculation history
  List<Map<String, dynamic>> loadRecentCalculations() {
    try {
      final jsonString = prefs.getString('recent_calculations');
      if (jsonString != null) {
        final jsonList = json.decode(jsonString) as List;
        return jsonList.cast<Map<String, dynamic>>();
      }
      return [];
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[StorageService] Failed to load recent calculations: $e');
      }
      return [];
    }
  }

  /// [saveFavoriteCharts] - Save favorited charts
  Future<bool> saveFavoriteCharts(List<String> chartIds) async {
    try {
      return await prefs.setStringList('favorite_charts', chartIds);
    } catch (e) {
      throw StorageException('Failed to save favorite charts: $e');
    }
  }

  /// [loadFavoriteCharts] - Load favorited charts
  List<String> loadFavoriteCharts() {
    try {
      return prefs.getStringList('favorite_charts') ?? [];
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[StorageService] Failed to load favorite charts: $e');
      }
      return [];
    }
  }

  /// [clearUserData] - Clear all user data (for logout/reset)
  Future<bool> clearUserData() async {
    try {
      final keys = [
        AppConstants.userProfileKey,
        'user_profiles_list',
        'recent_calculations',
        'favorite_charts',
      ];

      var allSuccessful = true;
      for (final key in keys) {
        final success = await prefs.remove(key);
        if (!success) allSuccessful = false;
      }

      // Also clear any chart data keys
      final allKeys = prefs.getKeys();
      for (final key in allKeys) {
        if (key.startsWith('chart_data_') || key.startsWith('bazi_data_')) {
          await prefs.remove(key);
        }
      }

      return allSuccessful;
    } catch (e) {
      throw StorageException('Failed to clear user data: $e');
    }
  }

  /// [clearAppData] - Clear all app data including preferences
  Future<bool> clearAppData() async {
    try {
      return await prefs.clear();
    } catch (e) {
      throw StorageException('Failed to clear app data: $e');
    }
  }

  /// [exportUserData] - Export all user data as JSON string
  String exportUserData() {
    try {
      final userData = <String, dynamic>{};

      // Export user profiles
      final profiles = loadUserProfiles();
      if (profiles.isNotEmpty) {
        userData['user_profiles'] = profiles.map((p) => p.toJson()).toList();
      }

      // Export current profile
      final currentProfile = loadUserProfile();
      if (currentProfile != null) {
        userData['current_profile'] = currentProfile.toJson();
      }

      // Export recent calculations
      userData['recent_calculations'] = loadRecentCalculations();

      // Export favorites
      userData['favorite_charts'] = loadFavoriteCharts();

      // Export preferences
      userData['calculation_preferences'] = loadCalculationPreferences();
      userData['theme_mode'] = loadThemeMode();
      userData['language'] = loadLanguage();

      return json.encode(userData);
    } catch (e) {
      throw StorageException('Failed to export user data: $e');
    }
  }

  /// [importUserData] - Import user data from JSON string
  Future<bool> importUserData(String jsonData) async {
    try {
      final userData = json.decode(jsonData) as Map<String, dynamic>;

      // Import user profiles
      if (userData['user_profiles'] != null) {
        final profiles = (userData['user_profiles'] as List)
            .map((json) => UserProfile.fromJson(json as Map<String, dynamic>))
            .toList();
        await saveUserProfiles(profiles);
      }

      // Import current profile
      if (userData['current_profile'] != null) {
        final profile = UserProfile.fromJson(
          userData['current_profile'] as Map<String, dynamic>,
        );
        await saveUserProfile(profile);
      }

      // Import recent calculations
      if (userData['recent_calculations'] != null) {
        await saveRecentCalculations(
          List<Map<String, dynamic>>.from(
            userData['recent_calculations'] as List,
          ),
        );
      }

      // Import favorites
      if (userData['favorite_charts'] != null) {
        await saveFavoriteCharts(
          List<String>.from(userData['favorite_charts'] as List),
        );
      }

      // Import preferences
      if (userData['calculation_preferences'] != null) {
        await saveCalculationPreferences(
          userData['calculation_preferences'] as Map<String, dynamic>,
        );
      }

      if (userData['theme_mode'] != null) {
        await saveThemeMode(userData['theme_mode'] as String);
      }

      if (userData['language'] != null) {
        await saveLanguage(userData['language'] as String);
      }

      return true;
    } catch (e) {
      throw StorageException('Failed to import user data: $e');
    }
  }

  /// [getStorageSize] - Get approximate storage size in bytes
  int getStorageSize() {
    try {
      var totalSize = 0;
      final keys = prefs.getKeys();

      for (final key in keys) {
        final value = prefs.get(key);
        if (value != null) {
          totalSize += key.length * 2; // Key size (Unicode)
          if (value is String) {
            totalSize += value.length * 2; // String value size
          } else {
            totalSize += 8; // Approximate size for other types
          }
        }
      }

      return totalSize;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[StorageService] Failed to calculate storage size: $e');
      }
      return 0;
    }
  }

  /// [saveStarAnalysis] - Save star analysis data
  Future<bool> saveStarAnalysis(
    String profileId,
    String starName,
    Map<String, dynamic> analysis,
  ) async {
    try {
      final key = 'star_analysis_${profileId}_$starName';
      final jsonString = json.encode(analysis);
      return await prefs.setString(key, jsonString);
    } catch (e) {
      throw StorageException('Failed to save star analysis: $e');
    }
  }

  /// [loadStarAnalysis] - Load star analysis data
  Map<String, dynamic>? loadStarAnalysis(String profileId, String starName) {
    try {
      final key = 'star_analysis_${profileId}_$starName';
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        return json.decode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[StorageService] Failed to load star analysis: $e');
      }
      return null;
    }
  }

  /// [savePalaceAnalysis] - Save palace analysis data
  Future<bool> savePalaceAnalysis(
    String profileId,
    String palaceName,
    Map<String, dynamic> analysis,
  ) async {
    try {
      final key = 'palace_analysis_${profileId}_$palaceName';
      final jsonString = json.encode(analysis);
      return await prefs.setString(key, jsonString);
    } catch (e) {
      throw StorageException('Failed to save palace analysis: $e');
    }
  }

  /// [loadPalaceAnalysis] - Load palace analysis data
  Map<String, dynamic>? loadPalaceAnalysis(
    String profileId,
    String palaceName,
  ) {
    try {
      final key = 'palace_analysis_${profileId}_$palaceName';
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        return json.decode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[StorageService] Failed to load palace analysis: $e');
      }
      return null;
    }
  }

  /// [saveAnalysisSession] - Save complete analysis session
  Future<bool> saveAnalysisSession(
    String profileId,
    Map<String, dynamic> session,
  ) async {
    try {
      final key = 'analysis_session_$profileId';
      final sessionData = {
        'timestamp': DateTime.now().toIso8601String(),
        'profile_id': profileId,
        'data': session,
      };
      final jsonString = json.encode(sessionData);
      return await prefs.setString(key, jsonString);
    } catch (e) {
      throw StorageException('Failed to save analysis session: $e');
    }
  }

  /// [loadAnalysisSession] - Load analysis session
  Map<String, dynamic>? loadAnalysisSession(String profileId) {
    try {
      final key = 'analysis_session_$profileId';
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        return json.decode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[StorageService] Failed to load analysis session: $e');
      }
      return null;
    }
  }

  /// [saveUserBookmarks] - Save user bookmarks for specific analysis points
  Future<bool> saveUserBookmarks(
    String profileId,
    List<Map<String, dynamic>> bookmarks,
  ) async {
    try {
      final key = 'bookmarks_$profileId';
      final jsonString = json.encode(bookmarks);
      return await prefs.setString(key, jsonString);
    } catch (e) {
      throw StorageException('Failed to save user bookmarks: $e');
    }
  }

  /// [loadUserBookmarks] - Load user bookmarks
  List<Map<String, dynamic>> loadUserBookmarks(String profileId) {
    try {
      final key = 'bookmarks_$profileId';
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        final decoded = json.decode(jsonString) as List<dynamic>;
        return decoded.cast<Map<String, dynamic>>();
      }
      return [];
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[StorageService] Failed to load user bookmarks: $e');
      }
      return [];
    }
  }

  /// [clearAnalysisData] - Clear all analysis data for a profile
  Future<bool> clearAnalysisData(String profileId) async {
    try {
      final allKeys = prefs.getKeys();
      final keysToRemove = allKeys
          .where(
            (key) =>
                key.startsWith('star_analysis_$profileId') ||
                key.startsWith('palace_analysis_$profileId') ||
                key.startsWith('analysis_session_$profileId') ||
                key.startsWith('bookmarks_$profileId'),
          )
          .toList();

      var allSuccessful = true;
      for (final key in keysToRemove) {
        final success = await prefs.remove(key);
        if (!success) allSuccessful = false;
      }

      return allSuccessful;
    } catch (e) {
      throw StorageException('Failed to clear analysis data: $e');
    }
  }

  /// Get default calculation preferences
  Map<String, dynamic> _getDefaultCalculationPreferences() {
    return {
      'use_true_solar_time': true,
      'show_brightness': true,
      'show_transformations': true,
      'default_language': 'en',
      'prefer_traditional_chinese': false,
      'auto_save_calculations': true,
      'show_advanced_analysis': false,
      'enable_detailed_star_analysis': true,
      'auto_save_palace_analysis': true,
      'show_transformation_effects': true,
      'enable_fortune_timing': true,
    };
  }
}

/// Custom exception for storage operations
class StorageException implements Exception {
  StorageException(this.message);
  final String message;

  @override
  String toString() => 'StorageException: $message';
}

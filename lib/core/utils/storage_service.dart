import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Storage service for managing app preferences and user data
class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  /// Check if onboarding has been completed
  Future<bool> isOnboardingCompleted() async {
    return _prefs?.getBool(AppConstants.keyOnboarding) ?? false;
  }

  /// Mark onboarding as completed
  Future<void> setOnboardingCompleted() async {
    await _prefs?.setBool(AppConstants.keyOnboarding, true);
  }

  /// Reset onboarding status (for testing purposes)
  Future<void> resetOnboarding() async {
    await _prefs?.setBool(AppConstants.keyOnboarding, false);
  }

  /// Get stored user token
  Future<String?> getUserToken() async {
    return _prefs?.getString(AppConstants.keyUserToken);
  }

  /// Store user token
  Future<void> setUserToken(String token) async {
    await _prefs?.setString(AppConstants.keyUserToken, token);
  }

  /// Remove user token
  Future<void> removeUserToken() async {
    await _prefs?.remove(AppConstants.keyUserToken);
  }

  /// Get stored language preference
  Future<String> getLanguage() async {
    return _prefs?.getString(AppConstants.keyLanguage) ?? AppConstants.defaultLanguage;
  }

  /// Store language preference
  Future<void> setLanguage(String language) async {
    await _prefs?.setString(AppConstants.keyLanguage, language);
  }

  /// Get stored theme preference
  Future<String> getThemeMode() async {
    return _prefs?.getString(AppConstants.keyTheme) ?? 'system';
  }

  /// Store theme preference
  Future<void> setThemeMode(String themeMode) async {
    await _prefs?.setString(AppConstants.keyTheme, themeMode);
  }

  /// Clear all stored data
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}


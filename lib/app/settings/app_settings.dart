import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  static const String _keyRole = 'role';
  static const String _keyThemeMode = 'themeMode';
  static const String _keyAccessToken = 'accessToken';
  static const String _keyRefreshToken = 'refreshToken';
  static const String _keyTokenExpiry = 'tokenExpiry';
  static const String _keyGradeVisualization = 'gradeVisualization';

  String _role = 'user';
  ThemeMode _themeMode = ThemeMode.system;
  String? _accessToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;
  bool _gradeVisualization = true; // Default value for grade visualization

  String get role => _role;
  ThemeMode get themeMode => _themeMode;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  bool get gradeVisualization => _gradeVisualization;

  AppSettings() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _role = prefs.getString(_keyRole) ?? 'user';
    _themeMode = _getThemeModeFromString(prefs.getString(_keyThemeMode) ?? 'system');
    _accessToken = prefs.getString(_keyAccessToken);
    _refreshToken = prefs.getString(_keyRefreshToken);
    _gradeVisualization = prefs.getBool(_keyGradeVisualization) ?? true;
    final expiry = prefs.getString(_keyTokenExpiry);
    _tokenExpiry = expiry != null ? DateTime.parse(expiry) : null;
    notifyListeners();
  }

  Future<void> setTokens(String accessToken, String refreshToken, DateTime expiry) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _tokenExpiry = expiry;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setString(_keyRefreshToken, refreshToken);
    await prefs.setString(_keyTokenExpiry, expiry.toIso8601String());
    notifyListeners();
  }

  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    _tokenExpiry = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyTokenExpiry);
    notifyListeners();
  }

  bool isAccessTokenValid() {
    if (_accessToken == null || _tokenExpiry == null) {
      return false;
    }
    return DateTime.now().isBefore(_tokenExpiry!);
  }

  Future<bool> refreshAccessToken() async {
    if (_refreshToken == null) {
      return false;
    }

    try {
      final response = await Dio().get(
        'https://meowhacks.efbo.ru/api/auth/student/refresh',
        options: Options(
          headers: {'Authorization': _refreshToken},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await setTokens(
          data['access_token'],
          data['refresh_token'],
          DateTime.now().add(Duration(hours: 1)),
        );
        return true;
      }
      return false;
    } catch (e) {
      print('Error refreshing token: $e');
      return false;
    }
  }

  Future<void> ensureValidAccessToken() async {
    if (!isAccessTokenValid()) {
      final success = await refreshAccessToken();
      if (!success) {
        await clearTokens();
        throw Exception('Unable to refresh access token');
      }
    }
  }

  Future<void> setRole(String newRole) async {
    _role = newRole;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRole, newRole);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode newThemeMode) async {
    _themeMode = newThemeMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, _themeModeToString(newThemeMode));
    notifyListeners();
  }

  /// Sets the grade visualization preference and saves it to shared preferences
  Future<void> setGradeVisualization(bool value) async {
    _gradeVisualization = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyGradeVisualization, value);
    notifyListeners();
  }

  String _themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
      default:
        return 'system';
    }
  }

  ThemeMode _getThemeModeFromString(String themeModeString) {
    switch (themeModeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}

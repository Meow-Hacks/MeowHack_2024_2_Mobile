import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  static const String _keyRole = 'role';
  static const String _keyThemeMode = 'themeMode';
  static const String _keyAccessToken = 'accessToken';
  static const String _keyRefreshToken = 'refreshToken';
  static const String _keyTokenExpiry = 'tokenExpiry';

  // Default values
  String _role = 'user';
  ThemeMode _themeMode = ThemeMode.system;
  String? _accessToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;

  // Getters
  String get role => _role;
  ThemeMode get themeMode => _themeMode;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  AppSettings() {
    _loadSettings();
  }

  /// Загружаем настройки из SharedPreferences при запуске
  Future<void> _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _role = prefs.getString(_keyRole) ?? 'user';
    _themeMode = _getThemeModeFromString(prefs.getString(_keyThemeMode) ?? 'system');
    _accessToken = prefs.getString(_keyAccessToken);
    _refreshToken = prefs.getString(_keyRefreshToken);
    final expiry = prefs.getString(_keyTokenExpiry);
    _tokenExpiry = expiry != null ? DateTime.parse(expiry) : null;
    notifyListeners();
  }

  /// Устанавливаем access и refresh токены
  Future<void> setTokens(String accessToken, String refreshToken, DateTime expiry) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _tokenExpiry = expiry;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setString(_keyRefreshToken, refreshToken);
    await prefs.setString(_keyTokenExpiry, expiry.toIso8601String());
    notifyListeners();
  }

  /// Очищаем токены при необходимости (например, при логауте)
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    _tokenExpiry = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyTokenExpiry);
    notifyListeners();
  }

  /// Проверяем, валиден ли токен
  bool isAccessTokenValid() {
    if (_accessToken == null || _tokenExpiry == null) {
      return false;
    }
    return DateTime.now().isBefore(_tokenExpiry!);
  }

  /// Устанавливаем роль пользователя
  Future<void> setRole(String newRole) async {
    _role = newRole;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRole, newRole);
    notifyListeners();
  }

  /// Устанавливаем тему приложения
  Future<void> setThemeMode(ThemeMode newThemeMode) async {
    _themeMode = newThemeMode;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, _themeModeToString(newThemeMode));
    notifyListeners();
  }

  /// Преобразуем тему в строку для сохранения
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

  /// Преобразуем строку обратно в тему
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

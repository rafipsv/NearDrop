import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_storage.dart';

class SharedPreferencesThemeStorage implements ThemeStorage {
  SharedPreferencesThemeStorage(this._preferences);

  static const _themeModeKey = 'theme_mode';

  final SharedPreferences _preferences;

  @override
  Future<ThemeMode> loadThemeMode() async {
    final value = _preferences.getString(_themeModeKey);
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _preferences.setString(_themeModeKey, value);
  }
}

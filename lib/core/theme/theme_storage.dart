import 'package:flutter/material.dart';

abstract interface class ThemeStorage {
  Future<ThemeMode> loadThemeMode();
  Future<void> saveThemeMode(ThemeMode mode);
}

import 'package:flutter/material.dart';

import 'dark_app_theme.dart';
import 'light_app_theme.dart';

class AppTheme {
  static ThemeData light() => LightAppTheme.data();
  static ThemeData dark() => DarkAppTheme.data();
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LightAppTheme {
  static const _seed = Color(0xFF246BFD);

  static ThemeData data() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF7F9FC),
      textTheme: GoogleFonts.interTextTheme(_textTheme()),
      appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: Size(48.w, 52.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    );
  }

  static TextTheme _textTheme() {
    return TextTheme(
      headlineMedium: TextStyle(fontSize: 28.sp, height: 1.2),
      headlineSmall: TextStyle(fontSize: 24.sp, height: 1.25),
      titleLarge: TextStyle(fontSize: 22.sp, height: 1.25),
      titleMedium: TextStyle(fontSize: 16.sp, height: 1.3),
      bodyLarge: TextStyle(fontSize: 16.sp, height: 1.45),
      bodyMedium: TextStyle(fontSize: 14.sp, height: 1.45),
      bodySmall: TextStyle(fontSize: 12.sp, height: 1.4),
      labelLarge: TextStyle(fontSize: 14.sp, height: 1.2),
      labelMedium: TextStyle(fontSize: 12.sp, height: 1.2),
    );
  }
}

import 'package:enevtly/core/resourses/colors_manager.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorsManager.primaryColor,
      onSecondary: ColorsManager.blackColor,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: ColorsManager.lightBgColor,
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: ColorsManager.primaryColor,
      ),
      bodyMedium: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: ColorsManager.blackColor,
      ),
    ),
  );
  
  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorsManager.primaryColor,
      onSecondary: ColorsManager.whiteColor,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: ColorsManager.darkBgColor,
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: ColorsManager.primaryColor,
      ),
      bodyMedium: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: ColorsManager.whiteColor,
      ),
    ),
  );
}

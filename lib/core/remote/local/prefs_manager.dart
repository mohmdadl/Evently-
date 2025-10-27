import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager {
  static late SharedPreferences preferences;

  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static saveThemeMode(ThemeMode themeMode) {
    preferences.setString(
      "theme",
      themeMode == ThemeMode.dark ? "dark" : "light",
    );
  }
  static ThemeMode getThemeMode (){
    String themeMode = preferences.getString("theme")??"light";
    if (themeMode == "light") {
      return ThemeMode.light;
    }else{
      return ThemeMode.dark;
    }
  }

  static saveLanguage(String languageCode) {
    preferences.setString("language", languageCode);
  }

  static String getLanguage() {
    return preferences.getString("language") ?? "en";
  }
}

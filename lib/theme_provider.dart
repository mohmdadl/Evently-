import 'package:enevtly/core/remote/local/prefs_manager.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeMode themeMode;
  initTheme() {
    themeMode = PrefsManager.getThemeMode();
  }

  changeTheme(ThemeMode newTheme) {
    if (newTheme == themeMode) return;
    themeMode = newTheme;
    PrefsManager.saveThemeMode(themeMode);
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// Theme
final appThemeStateNotifierProvider = ChangeNotifierProvider<ChangeAppThemeState>((ref) {
  return ChangeAppThemeState();
});

class ChangeAppThemeState extends ChangeNotifier {
  var isDarkModeEnabled = false;

  void setLightTheme() {
    isDarkModeEnabled = false;
    notifyListeners();
  }

  void setDarkTheme() {
    isDarkModeEnabled = true;
    notifyListeners();
  }
}

// Theme
final appThemeStateNotifier = StateNotifierProvider((ref) => AppThemeState());

class AppThemeState extends StateNotifier<bool> {
  AppThemeState(): super(false);

  void setLightTheme() => state = false;
  void setDarkTheme() => state = true;
}

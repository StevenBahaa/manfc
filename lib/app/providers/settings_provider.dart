import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/settings_state.dart';
import 'shared_prefs_provider.dart';

part 'settings_provider.g.dart';

@riverpod
class Settings extends _$Settings {
  static const _themeModeKey = 'app_theme_mode';
  static const _localeKey = 'app_locale';

  @override
  FutureOr<SettingsState> build() async {
    final prefs = ref.watch(sharedPrefsProvider);

    final savedTheme = prefs.getString(_themeModeKey);
    final savedLocale = prefs.getString(_localeKey);

    final themeMode = _themeModeFromString(savedTheme ?? 'system');
    final locale = Locale(savedLocale ?? 'en');

    return SettingsState(
      themeMode: themeMode,
      locale: locale,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setString(_themeModeKey, _themeModeToString(mode));
    
    final currentState = state.value;
    if (currentState != null) {
      state = AsyncData(currentState.copyWith(themeMode: mode));
    }
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setString(_localeKey, locale.languageCode);
    
    final currentState = state.value;
    if (currentState != null) {
      state = AsyncData(currentState.copyWith(locale: locale));
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  ThemeMode _themeModeFromString(String value) {
    switch (value) {
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

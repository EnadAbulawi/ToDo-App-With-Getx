import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class PreferencesService {
  static const _boxKey = 'preferences';
  final GetStorage _box = GetStorage();

  // مفاتيح
  static const _themeModeKey = 'theme_mode'; // 'light' | 'dark' | 'system'
  static const _localkey = 'locale'; // 'en' | 'ar'

  ThemeMode getThemeMode() {
    final stored = _box.read(_themeModeKey) as String?;
    return switch (stored) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system, // النظام الافتراضي
    };
  }

  void setThemeMode(ThemeMode mode) {
    String value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system', // النظام الافتراضي
    };
    _box.write(_themeModeKey, value);
  }

  Locale getLocale() {
    final code = _box.read(_localkey) as String?;
    if (code == 'ar') return const Locale('ar');
    return const Locale('en');
  }

  void setLocale(Locale locale) {
    _box.write(_localkey, locale.languageCode);
  }
}

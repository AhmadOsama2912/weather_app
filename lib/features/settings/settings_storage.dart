import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SettingsStorage {
  static const _kTheme = 'theme_mode';
  static const _kLocale = 'locale_code';

  Future<void> saveThemeMode(ThemeMode mode) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kTheme, mode.name);
  }

  Future<ThemeMode?> loadThemeMode() async {
    final sp = await SharedPreferences.getInstance();
    final v = sp.getString(_kTheme);
    if (v == null) return null;
    return ThemeMode.values.firstWhere((e) => e.name == v, orElse: () => ThemeMode.system);
  }

  Future<void> saveLocale(Locale locale) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kLocale, locale.languageCode);
  }

  Future<Locale?> loadLocale() async {
    final sp = await SharedPreferences.getInstance();
    final v = sp.getString(_kLocale);
    if (v == null) return null;
    return Locale(v);
  }

  // inside SettingsStorage
  Future<void> saveLanguageCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang_code', code);
  }

  Future<String?> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lang_code');
  }


}

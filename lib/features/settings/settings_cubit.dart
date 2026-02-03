import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'settings_state.dart';
import 'settings_storage.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsStorage storage;

  SettingsCubit({required this.storage})
      : super(const SettingsState(themeMode: ThemeMode.system, locale: Locale('en')));

  Future<void> load() async {
    final savedTheme = await storage.loadThemeMode();
    final savedLocale = await storage.loadLocale();

    emit(
      state.copyWith(
        themeMode: savedTheme ?? ThemeMode.system,
        locale: savedLocale ?? const Locale('en'),
      ),
    );
  }

  Future<void> toggleTheme() async {
    final current = state.themeMode;
    final next = current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(state.copyWith(themeMode: next));
    await storage.saveThemeMode(next);
  }

  Future<void> setLocale(Locale locale) async {
    emit(state.copyWith(locale: locale));
    await storage.saveLocale(locale);
  }

  Future<void> toggleLanguage() async {
    final next = state.locale.languageCode == 'en'
        ? const Locale('ar')
        : const Locale('en');
    await setLocale(next);
  }
}

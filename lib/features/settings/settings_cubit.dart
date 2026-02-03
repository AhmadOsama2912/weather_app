import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

import 'settings_state.dart';
import 'settings_storage.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsStorage storage;

  SettingsCubit({required this.storage}) : super(SettingsState.initial());

  Future<void> load() async {
    final (themeMode, locale) = await storage.load();
    emit(state.copyWith(themeMode: themeMode, locale: locale, isLoaded: true));
  }

  Future<void> toggleTheme() async {
    // Toggle between light <-> dark (keep it simple & obvious for reviewers)
    final next = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    emit(state.copyWith(themeMode: next));
    await storage.saveThemeMode(next);
  }

  Future<void> setLocale(Locale locale) async {
    emit(state.copyWith(locale: locale));
    await storage.saveLocale(locale);
  }
}

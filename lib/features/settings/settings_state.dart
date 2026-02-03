import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;
  final bool isLoaded;

  const SettingsState({
    required this.themeMode,
    required this.locale,
    required this.isLoaded,
  });

  factory SettingsState.initial() => const SettingsState(
    themeMode: ThemeMode.system,
    locale: Locale('en'),
    isLoaded: false,
  );

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? isLoaded,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale, isLoaded];
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:weather_app/l10n/app_localizations.dart';

import '../features/settings/settings_cubit.dart';
import '../features/settings/settings_state.dart';
import '../features/weather/presentation/pages/home_page.dart';
import 'theme/app_theme.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (p, n) => p.themeMode != n.themeMode || p.locale != n.locale,
      builder: (context, s) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          // THEME
          themeMode: s.themeMode,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),

          // LOCALE (THIS makes language change)
          locale: s.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          home: const HomePage(),
        );
      },
    );
  }
}

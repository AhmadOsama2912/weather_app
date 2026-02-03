import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/l10n/app_localizations.dart';
import '../widget/app_background.dart';
import '../../../settings/settings_cubit.dart';
import '../weather_cubit.dart';
import '../weather_state.dart';
import '../widget/weather_search_bar.dart';
import '../widget/weather_hero_header.dart';
import '../widget/hourly_strip.dart';
import '../widget/daily_forecast_list.dart';
import 'details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lang = Localizations.localeOf(context).languageCode;
      context.read<WeatherCubit>().loadOnAppOpen(languageCode: lang);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    final lang = Localizations.localeOf(context).languageCode;
    context.read<WeatherCubit>().searchCity(
      city: _controller.text,
      languageCode: lang,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          // Theme toggle
          Builder(
            builder: (context) {
              final isDark = context.select(
                (SettingsCubit c) => c.state.themeMode == ThemeMode.dark,
              );

              return IconButton(
                tooltip: isDark ? l10n.lightMode : l10n.darkMode,
                icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
                onPressed: () => context.read<SettingsCubit>().toggleTheme(),
              );
            },
          ),

          // Language toggle (EN <-> AR)
          Builder(
            builder: (context) {
              final lang = context.select(
                (SettingsCubit c) => c.state.locale.languageCode,
              );

              return IconButton(
                tooltip: l10n.changeLanguage,
                icon: const Icon(Icons.language),
                onPressed: () {
                  final next = (lang == 'en') ? const Locale('ar') : const Locale('en');
                  context.read<SettingsCubit>().setLocale(next);
                },
              );
            },
          ),
        ],
      ),



      body: AppBackground(
        child: SafeArea(
          child: BlocBuilder<WeatherCubit, WeatherState>(
            builder: (context, state) {
              if (state is WeatherLoading) {
                return Center(
                  child: Text(
                    l10n.loading,
                    style: TextStyle(color: cs.onSurface.withValues(alpha: 0.7)),
                  ),
                );
              }

              if (state is WeatherError) {
                final lang = Localizations.localeOf(context).languageCode;

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: cs.onSurface),
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () => context.read<WeatherCubit>().loadOnAppOpen(languageCode: lang),
                          child: Text(l10n.retry),
                        ),
                        if (state.canOpenSettings) ...[
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => context.read<WeatherCubit>().openSettingsIfNeeded(),
                            child: Text(l10n.openSettings),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }

              if (state is WeatherSuccess) {
                final data = state.data;
                final lang = Localizations.localeOf(context).languageCode;

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      WeatherSearchBar(controller: _controller, onSearch: _search),
                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => context.read<WeatherCubit>().useMyLocation(),
                          icon: const Icon(Icons.my_location),
                          label: Text(l10n.useMyLocation),
                        ),
                      ),

                      const SizedBox(height: 8),
                      WeatherHeroHeader(data: data),
                      const SizedBox(height: 14),

                      HourlyStrip(items: data.hourly),
                      const SizedBox(height: 12),

                      DailyForecastList(items: data.daily),
                      const SizedBox(height: 12),

                      // MetricsGrid(data: data),
                      // const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => context.read<WeatherCubit>().refresh(languageCode: lang),
                              icon: const Icon(Icons.refresh),
                              label: Text(l10n.refresh),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const DetailsPage()),
                                );
                              },
                              icon: const Icon(Icons.chevron_right),
                              label: Text(l10n.details),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

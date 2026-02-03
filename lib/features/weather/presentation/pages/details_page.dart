import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/l10n/app_localizations.dart';

import '../widget/app_background.dart';
import '../weather_cubit.dart';
import '../weather_state.dart';
import '../widget/daily_forecast_list.dart';
import '../widget/metrics_grid.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,

      appBar: AppBar(title: Text(l10n.details)),

      body: AppBackground(
        child: SafeArea(
          child: BlocBuilder<WeatherCubit, WeatherState>(
            builder: (context, state) {
              if (state is! WeatherSuccess) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = state.data;
              final lang = Localizations.localeOf(context).languageCode;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  MetricsGrid(data: data),
                  const SizedBox(height: 12),
                  DailyForecastList(items: data.daily),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => context.read<WeatherCubit>().refresh(languageCode: lang),
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.refresh),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

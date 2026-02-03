import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/weather_cubit.dart';
import '../../presentation/weather_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherCubit>().loadOnAppOpen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather')),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WeatherError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<WeatherCubit>().loadOnAppOpen(),
                    child: const Text('Retry'),
                  ),
                  if (state.canOpenSettings) ...[
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () =>
                          context.read<WeatherCubit>().openSettingsIfNeeded(),
                      child: const Text('Open Settings'),
                    ),
                  ],
                ],
              ),
            );
          }
          if (state is WeatherSuccess) {
            final w = state.weather;
            return Center(
              child: Text('${w.city}: ${w.currentTempC.toStringAsFixed(1)}°C'),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

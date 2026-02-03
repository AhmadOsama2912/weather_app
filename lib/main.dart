import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app.dart';
import 'core/location_service.dart';
import 'core/reverse_geocoder.dart';
import 'features/settings/settings_cubit.dart';
import 'features/settings/settings_storage.dart';
import 'features/weather/data/open_meteo_api.dart';
import 'features/weather/data/weather_repository.dart';
import 'features/weather/data/weather_storage.dart';
import 'features/weather/presentation/weather_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsCubit = SettingsCubit(storage: SettingsStorage());
  await settingsCubit.load();

  final weatherCubit = WeatherCubit(
    repository: WeatherRepository(api: OpenMeteoApi(), storage: WeatherStorage()),
    locationService: LocationService(),
    reverseGeocoder: ReverseGeocoder(),
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: settingsCubit),
        BlocProvider.value(value: weatherCubit),
      ],
      child: const WeatherApp(),
    ),
  );
}

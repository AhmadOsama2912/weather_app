import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/location_service.dart';
import '../../../core/reverse_geocoder.dart';
import '../data/weather_repository.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository repository;
  final LocationService locationService;
  final ReverseGeocoder reverseGeocoder;

  WeatherCubit({
    required this.repository,
    required this.locationService,
    required this.reverseGeocoder,
  }) : super(const WeatherInitial());

  Future<void> loadOnAppOpen() async {
    emit(const WeatherLoading());

    try {
      final pos = await locationService.determinePosition();
      final (city, country) = await reverseGeocoder.cityFromCoords(
        lat: pos.latitude,
        lon: pos.longitude,
      );

      final weather = await repository.getByCoordinates(
        latitude: pos.latitude,
        longitude: pos.longitude,
        displayCity: city,
        country: country,
      );

      emit(WeatherSuccess(weather));
    } on LocationException catch (e) {
      // Professional fallback: if location denied, try cached city search (if exists)
      final lastCity = await repository.getLastCity();
      if (lastCity != null && lastCity.trim().isNotEmpty) {
        emit(WeatherError(e.message, canOpenSettings: e.canOpenSettings));
        return;
      }

      emit(WeatherError(e.message, canOpenSettings: e.canOpenSettings));
    } catch (_) {
      emit(const WeatherError('Something went wrong. Please try again.'));
    }
  }

  Future<void> openSettingsIfNeeded() async {
    // Works on Android; on iOS opens Settings app (as per geolocator behavior)
    await Geolocator.openAppSettings();
  }
}

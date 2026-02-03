import 'package:bloc/bloc.dart';

import '../../../core/location_service.dart';
import '../../../core/reverse_geocoder.dart';
import '../data/open_meteo_dto.dart';
import '../data/weather_repository.dart';
import 'weather_state.dart';

enum _LastRequestType { none, city, location }

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository repository;
  final LocationService locationService;
  final ReverseGeocoder reverseGeocoder;

  _LastRequestType _lastType = _LastRequestType.none;
  String? _lastCity;
  double? _lastLat;
  double? _lastLon;
  String? _lastDisplayCity;
  String? _lastCountry;

  WeatherCubit({
    required this.repository,
    required this.locationService,
    required this.reverseGeocoder,
  }) : super(const WeatherInitial());

  Future<void> loadOnAppOpen({required String languageCode}) async {
    emit(const WeatherLoading());
    try {
      final last = await repository.getLastCity();
      if (last != null && last.trim().isNotEmpty) {
        await searchCity(city: last, languageCode: languageCode);
        return;
      }
      await useMyLocation();
    } catch (e) {
      emit(const WeatherError(message: 'Failed to load weather'));
    }
  }

  Future<void> useMyLocation() async {
    emit(const WeatherLoading());
    try {
      final pos = await locationService.getCurrentPosition();
      final place = await reverseGeocoder.reverse(pos.latitude, pos.longitude);

      final data = await repository.getByCoordinates(
        latitude: pos.latitude,
        longitude: pos.longitude,
        displayCity: place.city,
        country: place.country,
      );

      _lastType = _LastRequestType.location;
      _lastLat = pos.latitude;
      _lastLon = pos.longitude;
      _lastDisplayCity = place.city;
      _lastCountry = place.country;

      emit(WeatherSuccess(data));
    } on LocationServiceDisabledException {
      emit(const WeatherError(message: 'Location services are disabled', canOpenSettings: true));
    } on LocationPermissionDeniedForeverException {
      emit(const WeatherError(message: 'Location permission permanently denied', canOpenSettings: true));
    } on LocationPermissionDeniedException {
      emit(const WeatherError(message: 'Location permission denied', canOpenSettings: true));
    } catch (_) {
      emit(const WeatherError(message: 'Failed to load location weather'));
    }
  }

  Future<void> searchCity({
    required String city,
    required String languageCode,
  }) async {
    emit(const WeatherLoading());
    try {
      final data = await repository.getByCity(city: city, languageCode: languageCode);

      _lastType = _LastRequestType.city;
      _lastCity = city;
      emit(WeatherSuccess(data));
    } on CityNotFoundException {
      emit(const WeatherError(message: 'City not found'));
    } catch (_) {
      emit(const WeatherError(message: 'Failed to search city'));
    }
  }

  Future<void> refresh({required String languageCode}) async {
    switch (_lastType) {
      case _LastRequestType.city:
        final c = _lastCity;
        if (c != null) {
          await searchCity(city: c, languageCode: languageCode);
          return;
        }
        break;
      case _LastRequestType.location:
        final lat = _lastLat;
        final lon = _lastLon;
        final name = _lastDisplayCity;
        if (lat != null && lon != null && name != null) {
          emit(const WeatherLoading());
          try {
            final data = await repository.getByCoordinates(
              latitude: lat,
              longitude: lon,
              displayCity: name,
              country: _lastCountry,
            );
            emit(WeatherSuccess(data));
            return;
          } catch (_) {
            emit(const WeatherError(message: 'Failed to refresh'));
            return;
          }
        }
        break;
      case _LastRequestType.none:
        break;
    }
    await loadOnAppOpen(languageCode: languageCode);
  }

  Future<void> openSettingsIfNeeded() async {
    await locationService.openAppSettings();
  }
}

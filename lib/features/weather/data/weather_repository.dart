import '../../../core/app_exceptions.dart';
import '../domain/weather.dart';
import 'open_meteo_api.dart';
import 'weather_storage.dart';

class WeatherRepository {
  final OpenMeteoApi api;
  final WeatherStorage storage;

  WeatherRepository({
    required this.api,
    required this.storage,
  });

  /// Fetch weather using GPS coordinates (no geocoding call).
  /// - [displayCity] is what you want to show in UI (reverse-geocoded city name).
  /// - Does NOT cache last city (because it’s not a searched city).
  Future<Weather> getByCoordinates({
    required double latitude,
    required double longitude,
    required String displayCity,
    String? country,
  }) async {
    final forecast = await api.fetchForecast(
      latitude: latitude,
      longitude: longitude,
    );

    return _buildWeather(
      city: displayCity.trim().isEmpty ? 'Current location' : displayCity.trim(),
      country: country,
      forecast: forecast,
    );
  }

  /// Fetch weather by city name using geocoding then forecast.
  /// Caches the last searched city for better UX on next app open.
  Future<Weather> getByCity({
    required String city,
    required String languageCode,
  }) async {
    final trimmedCity = city.trim();
    if (trimmedCity.isEmpty) {
      throw const NotFoundException('Empty city');
    }

    final place = await api.geocodeCity(
      city: trimmedCity,
      languageCode: languageCode,
    );

    final forecast = await api.fetchForecast(
      latitude: place.latitude,
      longitude: place.longitude,
    );

    final weather = _buildWeather(
      city: place.name,
      country: place.country,
      forecast: forecast,
    );

    await storage.saveLastCity(trimmedCity);
    return weather;
  }

  Future<String?> getLastCity() => storage.getLastCity();

  // Private helpers
  Weather _buildWeather({
    required String city,
    required String? country,
    required dynamic forecast, // ForecastResponse type from your dto file
  }) {
    // "today" values fallback to current if daily arrays are empty
    final minTemp = _firstOrNullDouble(forecast.daily.tempMin) ?? forecast.current.temperature2m;
    final maxTemp = _firstOrNullDouble(forecast.daily.tempMax) ?? forecast.current.temperature2m;

    final code = _firstOrNullInt(forecast.daily.weatherCode) ?? forecast.current.weatherCode;

    return Weather(
      city: city,
      country: country,
      currentTempC: forecast.current.temperature2m,
      minTempC: minTemp,
      maxTempC: maxTemp,
      humidityPercent: forecast.current.relativeHumidity2m,
      windSpeedKmh: forecast.current.windSpeed10m,
      weatherCode: code,
      updatedAt: DateTime.now(),
    );
  }

  double? _firstOrNullDouble(List<double> list) => list.isNotEmpty ? list.first : null;

  int? _firstOrNullInt(List<int> list) => list.isNotEmpty ? list.first : null;
}

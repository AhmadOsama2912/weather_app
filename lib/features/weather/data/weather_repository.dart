import '../domain/weather.dart';
import 'open_meteo_api.dart';
import 'weather_storage.dart';

class WeatherRepository {
  final OpenMeteoApi api;
  final WeatherStorage storage;

  WeatherRepository({required this.api, required this.storage});

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

    final minTemp = forecast.daily.tempMin.isNotEmpty
        ? forecast.daily.tempMin.first
        : forecast.current.temperature2m;

    final maxTemp = forecast.daily.tempMax.isNotEmpty
        ? forecast.daily.tempMax.first
        : forecast.current.temperature2m;

    final dailyCode = forecast.daily.weatherCode.isNotEmpty
        ? forecast.daily.weatherCode.first
        : forecast.current.weatherCode;

    return Weather(
      city: displayCity,
      country: country,
      currentTempC: forecast.current.temperature2m,
      minTempC: minTemp,
      maxTempC: maxTemp,
      humidityPercent: forecast.current.relativeHumidity2m,
      windSpeedKmh: forecast.current.windSpeed10m,
      weatherCode: dailyCode,
      updatedAt: DateTime.now(),
    );
  }

  // keep your existing:
  // - getByCity(...)
  Future<String?> getLastCity() => storage.getLastCity();
}

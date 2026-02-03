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

  Future<Weather> getByCity({
    required String city,
    required String languageCode,
  }) async {
    final trimmed = city.trim();
    if (trimmed.isEmpty) {
      throw const NotFoundException('Empty city');
    }

    final place = await api.geocodeCity(city: trimmed, languageCode: languageCode);
    final forecast = await api.fetchForecast(latitude: place.latitude, longitude: place.longitude);

    // daily arrays: take day0 (today)
    final minTemp = forecast.daily.tempMin.isNotEmpty ? forecast.daily.tempMin.first : forecast.current.temperature2m;
    final maxTemp = forecast.daily.tempMax.isNotEmpty ? forecast.daily.tempMax.first : forecast.current.temperature2m;
    final dailyCode = forecast.daily.weatherCode.isNotEmpty ? forecast.daily.weatherCode.first : forecast.current.weatherCode;

    final weather = Weather(
      city: place.name,
      country: place.country,
      currentTempC: forecast.current.temperature2m,
      minTempC: minTemp,
      maxTempC: maxTemp,
      humidityPercent: forecast.current.relativeHumidity2m,
      windSpeedKmh: forecast.current.windSpeed10m,
      weatherCode: dailyCode,
      updatedAt: DateTime.now(),
    );

    await storage.saveLastCity(trimmed);
    return weather;
  }

  Future<String?> getLastCity() => storage.getLastCity();
}

import '../domain/weather_bundle.dart';
import '../domain/weather_exceptions.dart';
import 'open_meteo_api.dart';
import 'weather_storage.dart';

class WeatherRepository {
  final OpenMeteoApi api;
  final WeatherStorage storage;

  WeatherRepository({required this.api, required this.storage});

  Future<WeatherBundle> getByCoordinates({
    required double latitude,
    required double longitude,
    required String displayCity,
    String? country,
  }) async {
    final f = await api.fetchForecast(latitude: latitude, longitude: longitude);

    final now = f.current.time;
    final hourly = <HourlyPoint>[];
    for (var i = 0; i < f.hourly.time.length; i++) {
      if (f.hourly.time[i].isBefore(now)) continue;
      hourly.add(
        HourlyPoint(
          time: f.hourly.time[i],
          tempC: f.hourly.temperature2m[i],
          weatherCode: f.hourly.weatherCode[i],
          precipitationMm: f.hourly.precipitation[i],
        ),
      );
      if (hourly.length >= 12) break;
    }

    final daily = <DailyPoint>[];
    for (var i = 0; i < f.daily.time.length; i++) {
      daily.add(
        DailyPoint(
          date: f.daily.time[i],
          minTempC: f.daily.tempMin[i],
          maxTempC: f.daily.tempMax[i],
          weatherCode: f.daily.weatherCode[i],
          precipitationSumMm: f.daily.precipitationSum[i],
          uvIndexMax: f.daily.uvIndexMax[i],
        ),
      );
    }

    return WeatherBundle(
      city: displayCity,
      country: country,
      currentTempC: f.current.temperature2m,
      feelsLikeC: f.current.apparentTemperature,
      minTempC: f.daily.tempMin.first,
      maxTempC: f.daily.tempMax.first,
      humidityPercent: f.current.relativeHumidity2m,
      windSpeedKmh: f.current.windSpeed10m,
      windGustKmh: f.current.windGusts10m,
      windDirectionDeg: f.current.windDirection10m,
      pressureHpa: f.current.pressureMsl,
      visibilityKm: f.current.visibility / 1000.0,
      precipitationMm: f.current.precipitation,
      uvIndexMax: f.daily.uvIndexMax.first,
      sunrise: f.daily.sunrise.first,
      sunset: f.daily.sunset.first,
      weatherCode: f.current.weatherCode,
      hourly: hourly,
      daily: daily,
      updatedAt: DateTime.now(),
    );
  }

  Future<WeatherBundle> getByCity({
    required String city,
    required String languageCode,
  }) async {
    final trimmed = city.trim();
    if (trimmed.isEmpty) throw const CityNotFoundException();

    final place = await api.geocodeCity(city: trimmed, languageCode: languageCode);
    final bundle = await getByCoordinates(
      latitude: place.latitude,
      longitude: place.longitude,
      displayCity: place.name,
      country: place.country,
    );

    await storage.saveLastCity(trimmed);
    return bundle;
  }

  Future<String?> getLastCity() => storage.getLastCity();
}

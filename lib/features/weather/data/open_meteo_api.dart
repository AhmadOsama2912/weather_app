import 'package:dio/dio.dart';
import 'open_meteo_dto.dart';

class OpenMeteoApi {
  final Dio dio;
  OpenMeteoApi({Dio? dio})
      : dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 12),
                receiveTimeout: const Duration(seconds: 12),
              ),
            );

  Future<OpenMeteoForecastDto> fetchForecast({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'timezone': 'auto',
      'forecast_days': '10',
      'windspeed_unit': 'kmh',
      'current':
          'temperature_2m,apparent_temperature,relative_humidity_2m,precipitation,weather_code,pressure_msl,visibility,wind_speed_10m,wind_direction_10m,wind_gusts_10m',
      'hourly': 'temperature_2m,precipitation,weather_code',
      'daily':
          'temperature_2m_max,temperature_2m_min,sunrise,sunset,weather_code,precipitation_sum,uv_index_max,wind_gusts_10m_max',
    });

    final res = await dio.getUri(uri);
    return OpenMeteoForecastDto.fromJson(res.data as Map<String, dynamic>);
  }

  Future<GeoPlaceDto> geocodeCity({
    required String city,
    required String languageCode,
  }) async {
    final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': city,
      'count': '1',
      'language': languageCode,
      'format': 'json',
    });

    final res = await dio.getUri(uri);
    return GeoPlaceDto.fromJson(res.data as Map<String, dynamic>);
  }
}

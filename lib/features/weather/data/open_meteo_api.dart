import 'package:dio/dio.dart';

import '../../../core/app_exceptions.dart';
import 'open_meteo_dto.dart';

class OpenMeteoApi {
  OpenMeteoApi({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  final Dio _dio;

  Future<GeoPlace> geocodeCity({
    required String city,
    required String languageCode,
  }) async {
    try {
      final resp = await _dio.get(
        'https://geocoding-api.open-meteo.com/v1/search',
        queryParameters: {
          'name': city,
          'count': 1,
          'language': languageCode,
          'format': 'json',
        },
      );

      final data = (resp.data as Map).cast<String, dynamic>();
      final parsed = GeoSearchResponse.fromJson(data);

      if (parsed.results.isEmpty) {
        throw const NotFoundException('City not found');
      }
      return parsed.results.first;
    } on DioException catch (e) {
      throw NetworkException(_dioMessage(e));
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnexpectedException('Failed to parse geocoding response');
    }
  }

  Future<ForecastResponse> fetchForecast({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final resp = await _dio.get(
        'https://api.open-meteo.com/v1/forecast',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'timezone': 'auto',
          'current':
              'temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m',
          'daily': 'temperature_2m_max,temperature_2m_min,weather_code',
        },
      );

      final data = (resp.data as Map).cast<String, dynamic>();
      return ForecastResponse.fromJson(data);
    } on DioException catch (e) {
      throw NetworkException(_dioMessage(e));
    } catch (_) {
      throw const UnexpectedException('Failed to parse forecast response');
    }
  }

  String _dioMessage(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return 'Request timeout';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'No internet connection';
    }
    return 'Network error';
  }
}

import 'package:equatable/equatable.dart';

class WeatherBundle extends Equatable {
  final String city;
  final String? country;

  final double currentTempC;
  final double feelsLikeC;
  final double minTempC;
  final double maxTempC;

  final int humidityPercent;
  final double windSpeedKmh;
  final double windGustKmh;
  final int windDirectionDeg;

  final double pressureHpa;
  final double visibilityKm;
  final double precipitationMm;

  final double uvIndexMax;
  final DateTime sunrise;
  final DateTime sunset;

  final int weatherCode;
  final List<HourlyPoint> hourly; // 12 points
  final List<DailyPoint> daily;   // 10 days
  final DateTime updatedAt;

  const WeatherBundle({
    required this.city,
    required this.country,
    required this.currentTempC,
    required this.feelsLikeC,
    required this.minTempC,
    required this.maxTempC,
    required this.humidityPercent,
    required this.windSpeedKmh,
    required this.windGustKmh,
    required this.windDirectionDeg,
    required this.pressureHpa,
    required this.visibilityKm,
    required this.precipitationMm,
    required this.uvIndexMax,
    required this.sunrise,
    required this.sunset,
    required this.weatherCode,
    required this.hourly,
    required this.daily,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        city,
        country,
        currentTempC,
        feelsLikeC,
        minTempC,
        maxTempC,
        humidityPercent,
        windSpeedKmh,
        windGustKmh,
        windDirectionDeg,
        pressureHpa,
        visibilityKm,
        precipitationMm,
        uvIndexMax,
        sunrise,
        sunset,
        weatherCode,
        hourly,
        daily,
        updatedAt,
      ];
}

class HourlyPoint extends Equatable {
  final DateTime time;
  final double tempC;
  final int weatherCode;
  final double precipitationMm;

  const HourlyPoint({
    required this.time,
    required this.tempC,
    required this.weatherCode,
    required this.precipitationMm,
  });

  @override
  List<Object?> get props => [time, tempC, weatherCode, precipitationMm];
}

class DailyPoint extends Equatable {
  final DateTime date;
  final double minTempC;
  final double maxTempC;
  final int weatherCode;
  final double precipitationSumMm;
  final double uvIndexMax;

  const DailyPoint({
    required this.date,
    required this.minTempC,
    required this.maxTempC,
    required this.weatherCode,
    required this.precipitationSumMm,
    required this.uvIndexMax,
  });

  @override
  List<Object?> get props => [date, minTempC, maxTempC, weatherCode, precipitationSumMm, uvIndexMax];
}

class OpenMeteoForecastDto {
  final CurrentDto current;
  final HourlyDto hourly;
  final DailyDto daily;

  OpenMeteoForecastDto({
    required this.current,
    required this.hourly,
    required this.daily,
  });

  factory OpenMeteoForecastDto.fromJson(Map<String, dynamic> json) {
    return OpenMeteoForecastDto(
      current: CurrentDto.fromJson(json['current'] as Map<String, dynamic>),
      hourly: HourlyDto.fromJson(json['hourly'] as Map<String, dynamic>),
      daily: DailyDto.fromJson(json['daily'] as Map<String, dynamic>),
    );
  }
}

class CurrentDto {
  final DateTime time;
  final double temperature2m;
  final double apparentTemperature;
  final int relativeHumidity2m;
  final double precipitation;
  final int weatherCode;
  final double pressureMsl;
  final double visibility; // meters
  final double windSpeed10m;
  final int windDirection10m;
  final double windGusts10m;

  CurrentDto({
    required this.time,
    required this.temperature2m,
    required this.apparentTemperature,
    required this.relativeHumidity2m,
    required this.precipitation,
    required this.weatherCode,
    required this.pressureMsl,
    required this.visibility,
    required this.windSpeed10m,
    required this.windDirection10m,
    required this.windGusts10m,
  });

  factory CurrentDto.fromJson(Map<String, dynamic> json) {
    return CurrentDto(
      time: DateTime.parse(json['time'] as String),
      temperature2m: (json['temperature_2m'] as num).toDouble(),
      apparentTemperature: (json['apparent_temperature'] as num).toDouble(),
      relativeHumidity2m: (json['relative_humidity_2m'] as num).toInt(),
      precipitation: (json['precipitation'] as num).toDouble(),
      weatherCode: (json['weather_code'] as num).toInt(),
      pressureMsl: (json['pressure_msl'] as num).toDouble(),
      visibility: (json['visibility'] as num).toDouble(),
      windSpeed10m: (json['wind_speed_10m'] as num).toDouble(),
      windDirection10m: (json['wind_direction_10m'] as num).toInt(),
      windGusts10m: (json['wind_gusts_10m'] as num).toDouble(),
    );
  }
}

class HourlyDto {
  final List<DateTime> time;
  final List<double> temperature2m;
  final List<double> precipitation;
  final List<int> weatherCode;

  HourlyDto({
    required this.time,
    required this.temperature2m,
    required this.precipitation,
    required this.weatherCode,
  });

  factory HourlyDto.fromJson(Map<String, dynamic> json) {
    return HourlyDto(
      time: (json['time'] as List).cast<String>().map(DateTime.parse).toList(),
      temperature2m: (json['temperature_2m'] as List).cast<num>().map((e) => e.toDouble()).toList(),
      precipitation: (json['precipitation'] as List).cast<num>().map((e) => e.toDouble()).toList(),
      weatherCode: (json['weather_code'] as List).cast<num>().map((e) => e.toInt()).toList(),
    );
  }
}

class DailyDto {
  final List<DateTime> time;
  final List<double> tempMax;
  final List<double> tempMin;
  final List<DateTime> sunrise;
  final List<DateTime> sunset;
  final List<int> weatherCode;
  final List<double> precipitationSum;
  final List<double> uvIndexMax;
  final List<double> windGustsMax;

  DailyDto({
    required this.time,
    required this.tempMax,
    required this.tempMin,
    required this.sunrise,
    required this.sunset,
    required this.weatherCode,
    required this.precipitationSum,
    required this.uvIndexMax,
    required this.windGustsMax,
  });

  factory DailyDto.fromJson(Map<String, dynamic> json) {
    return DailyDto(
      time: (json['time'] as List).cast<String>().map(DateTime.parse).toList(),
      tempMax: (json['temperature_2m_max'] as List).cast<num>().map((e) => e.toDouble()).toList(),
      tempMin: (json['temperature_2m_min'] as List).cast<num>().map((e) => e.toDouble()).toList(),
      sunrise: (json['sunrise'] as List).cast<String>().map(DateTime.parse).toList(),
      sunset: (json['sunset'] as List).cast<String>().map(DateTime.parse).toList(),
      weatherCode: (json['weather_code'] as List).cast<num>().map((e) => e.toInt()).toList(),
      precipitationSum: (json['precipitation_sum'] as List).cast<num>().map((e) => e.toDouble()).toList(),
      uvIndexMax: (json['uv_index_max'] as List).cast<num>().map((e) => e.toDouble()).toList(),
      windGustsMax: (json['wind_gusts_10m_max'] as List).cast<num>().map((e) => e.toDouble()).toList(),
    );
  }
}

class GeoPlaceDto {
  final String name;
  final String? country;
  final double latitude;
  final double longitude;

  GeoPlaceDto({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory GeoPlaceDto.fromJson(Map<String, dynamic> json) {
    final results = (json['results'] as List?) ?? [];
    if (results.isEmpty) {
      throw const CityNotFoundException();
    }
    final r = results.first as Map<String, dynamic>;
    return GeoPlaceDto(
      name: (r['name'] as String).trim(),
      country: (r['country'] as String?)?.trim(),
      latitude: (r['latitude'] as num).toDouble(),
      longitude: (r['longitude'] as num).toDouble(),
    );
  }
}

class CityNotFoundException implements Exception {
  const CityNotFoundException();
}

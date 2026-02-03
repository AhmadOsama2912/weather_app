class GeoSearchResponse {
  final List<GeoPlace> results;

  const GeoSearchResponse({required this.results});

  factory GeoSearchResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['results'];
    final list = (raw is List)
        ? raw.whereType<Map<String, dynamic>>().map(GeoPlace.fromJson).toList()
        : <GeoPlace>[];
    return GeoSearchResponse(results: list);
  }
}

class GeoPlace {
  final String name;
  final String? country;
  final double latitude;
  final double longitude;

  const GeoPlace({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory GeoPlace.fromJson(Map<String, dynamic> json) {
    return GeoPlace(
      name: (json['name'] ?? '').toString(),
      country: json['country']?.toString(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}

class ForecastResponse {
  final CurrentWeather current;
  final DailyWeather daily;

  const ForecastResponse({required this.current, required this.daily});

  factory ForecastResponse.fromJson(Map<String, dynamic> json) {
    return ForecastResponse(
      current: CurrentWeather.fromJson(
        (json['current'] as Map).cast<String, dynamic>(),
      ),
      daily: DailyWeather.fromJson(
        (json['daily'] as Map).cast<String, dynamic>(),
      ),
    );
  }
}

class CurrentWeather {
  final double temperature2m;
  final int relativeHumidity2m;
  final double windSpeed10m;
  final int weatherCode;

  const CurrentWeather({
    required this.temperature2m,
    required this.relativeHumidity2m,
    required this.windSpeed10m,
    required this.weatherCode,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature2m: (json['temperature_2m'] as num).toDouble(),
      relativeHumidity2m: (json['relative_humidity_2m'] as num).toInt(),
      windSpeed10m: (json['wind_speed_10m'] as num).toDouble(),
      weatherCode: (json['weather_code'] as num).toInt(),
    );
  }
}

class DailyWeather {
  final List<double> tempMax;
  final List<double> tempMin;
  final List<int> weatherCode;

  const DailyWeather({
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    List<double> toDoubles(dynamic v) =>
        (v is List) ? v.whereType<num>().map((e) => e.toDouble()).toList() : <double>[];

    List<int> toInts(dynamic v) =>
        (v is List) ? v.whereType<num>().map((e) => e.toInt()).toList() : <int>[];

    return DailyWeather(
      tempMax: toDoubles(json['temperature_2m_max']),
      tempMin: toDoubles(json['temperature_2m_min']),
      weatherCode: toInts(json['weather_code']),
    );
  }
}

class Weather {
  final String city;
  final String? country;

  final double currentTempC;
  final double minTempC;
  final double maxTempC;

  final int humidityPercent;
  final double windSpeedKmh;

  /// Open-Meteo weather_code (we will map to human text later)
  final int weatherCode;

  final DateTime updatedAt;

  const Weather({
    required this.city,
    required this.country,
    required this.currentTempC,
    required this.minTempC,
    required this.maxTempC,
    required this.humidityPercent,
    required this.windSpeedKmh,
    required this.weatherCode,
    required this.updatedAt,
  });
}

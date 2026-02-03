import 'package:shared_preferences/shared_preferences.dart';

class WeatherStorage {
  static const _kLastCity = 'weather.lastCity';

  Future<void> saveLastCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLastCity, city);
  }

  Future<String?> getLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kLastCity);
  }
}

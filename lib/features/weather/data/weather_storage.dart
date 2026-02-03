import 'package:shared_preferences/shared_preferences.dart';

class WeatherStorage {
  static const _kLastCity = 'last_city';

  Future<void> saveLastCity(String city) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kLastCity, city);
  }

  Future<String?> getLastCity() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kLastCity);
  }
}

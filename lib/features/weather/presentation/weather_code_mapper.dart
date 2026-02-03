import 'package:flutter/material.dart';

class WeatherCodeMapper {
  static String label(int code, Locale locale) {
    final isAr = locale.languageCode.toLowerCase() == 'ar';

    String en;
    String ar;

    if (code == 0) {
      en = 'Clear'; ar = 'صحو';
    } else if (code >= 1 && code <= 3) {
      en = 'Cloudy'; ar = 'غائم';
    } else if (code == 45 || code == 48) {
      en = 'Fog'; ar = 'ضباب';
    } else if (code >= 51 && code <= 57) {
      en = 'Drizzle'; ar = 'رذاذ';
    } else if ((code >= 61 && code <= 67) || (code >= 80 && code <= 82)) {
      en = 'Rain'; ar = 'مطر';
    } else if (code >= 71 && code <= 77) {
      en = 'Snow'; ar = 'ثلج';
    } else if (code >= 95 && code <= 99) {
      en = 'Thunderstorm'; ar = 'عاصفة رعدية';
    } else {
      en = 'Unknown'; ar = 'غير معروف';
    }

    return isAr ? ar : en;
  }

  static IconData icon(int code) {
    if (code == 0) return Icons.wb_sunny_outlined;
    if (code >= 1 && code <= 3) return Icons.cloud_outlined;
    if (code == 45 || code == 48) return Icons.foggy;
    if (code >= 51 && code <= 57) return Icons.grain_outlined;
    if ((code >= 61 && code <= 67) || (code >= 80 && code <= 82)) return Icons.umbrella_outlined;
    if (code >= 71 && code <= 77) return Icons.ac_unit_outlined;
    if (code >= 95 && code <= 99) return Icons.thunderstorm_outlined;
    return Icons.help_outline;
  }
}

import 'package:flutter/material.dart';
import 'package:weather_app/l10n/app_localizations.dart';

import '../../domain/weather_bundle.dart';
import '../weather_code_mapper.dart';
import 'glass_card.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyPoint> items;
  const DailyForecastList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final headerColor = cs.onSurfaceVariant.withValues(alpha: isDark ? 0.88 : 0.78);
    final dayColor = cs.onSurfaceVariant.withValues(alpha: isDark ? 0.90 : 0.80);
    final minColor = cs.onSurfaceVariant.withValues(alpha: isDark ? 0.85 : 0.75);
    final maxColor = cs.onSurface.withValues(alpha: isDark ? 0.96 : 0.92);
    final iconColor = cs.onSurface.withValues(alpha: isDark ? 0.95 : 0.85);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.tenDayForecast, style: TextStyle(color: headerColor, fontSize: 12)),
          const SizedBox(height: 12),
          ...items.map((d) {
            final icon = WeatherCodeMapper.icon(d.weatherCode);
            final day = _weekday(context, d.date);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 52,
                    child: Text(day, style: TextStyle(color: dayColor)),
                  ),
                  Icon(icon, size: 18, color: iconColor),
                  const SizedBox(width: 10),
                  const Spacer(),
                  Text('${d.minTempC.toStringAsFixed(0)}°', style: TextStyle(color: minColor)),
                  const SizedBox(width: 18),
                  Text(
                    '${d.maxTempC.toStringAsFixed(0)}°',
                    style: TextStyle(color: maxColor, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // Optional: localized-ish day labels (simple + consistent)
  String _weekday(BuildContext context, DateTime d) {
    // DateTime.weekday: Mon=1..Sun=7
    const en = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const ar = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    final lang = Localizations.localeOf(context).languageCode;
    final idx = (d.weekday - 1).clamp(0, 6);
    return (lang == 'ar' ? ar : en)[idx];
  }
}

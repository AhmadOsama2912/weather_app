import 'package:flutter/material.dart';
import 'package:weather_app/l10n/app_localizations.dart';

import '../../domain/weather_bundle.dart';
import 'glass_card.dart';

class MetricsGrid extends StatelessWidget {
  final WeatherBundle data;
  const MetricsGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _tile(
          context,
          title: l10n.wind,
          value: '${data.windSpeedKmh.toStringAsFixed(0)} km/h',
          sub: '${l10n.gusts}: ${data.windGustKmh.toStringAsFixed(0)}',
        ),
        _tile(context, title: l10n.humidity, value: '${data.humidityPercent}%', sub: ''),
        _tile(context, title: l10n.pressure, value: '${data.pressureHpa.toStringAsFixed(0)} hPa', sub: ''),
        _tile(context, title: l10n.visibility, value: '${data.visibilityKm.toStringAsFixed(0)} km', sub: ''),
        _tile(context, title: l10n.uvIndex, value: data.uvIndexMax.toStringAsFixed(0), sub: ''),
        _tile(
          context,
          title: l10n.sunrise,
          value: TimeOfDay.fromDateTime(data.sunrise).format(context),
          sub: '${l10n.sunset}: ${TimeOfDay.fromDateTime(data.sunset).format(context)}',
        ),
      ],
    );
  }

  Widget _tile(
    BuildContext context, {
    required String title,
    required String value,
    required String sub,
  }) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final titleColor = cs.onSurfaceVariant.withValues(alpha: isDark ? 0.88 : 0.78);
    final valueColor = cs.onSurface.withValues(alpha: isDark ? 0.96 : 0.92);
    final subColor = cs.onSurfaceVariant.withValues(alpha: isDark ? 0.86 : 0.76);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: titleColor, fontSize: 12)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: valueColor),
          ),
          if (sub.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(sub, style: TextStyle(color: subColor, fontSize: 12)),
          ],
        ],
      ),
    );
  }
}

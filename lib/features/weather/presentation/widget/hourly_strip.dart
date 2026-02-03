import 'package:flutter/material.dart';
import '../../domain/weather_bundle.dart';
import '../weather_code_mapper.dart';
import 'glass_card.dart';

class HourlyStrip extends StatelessWidget {
  final List<HourlyPoint> items;
  const HourlyStrip({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hourColor = cs.onSurfaceVariant.withValues(alpha: isDark ? 0.88 : 0.80);
    final tempColor = cs.onSurface.withValues(alpha: isDark ? 0.95 : 0.90);
    final iconColor = cs.onSurface.withValues(alpha: isDark ? 0.95 : 0.85);

    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 110,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, i) {
            final h = items[i];
            final icon = WeatherCodeMapper.icon(h.weatherCode);
            final hour = TimeOfDay.fromDateTime(h.time).format(context);

            return SizedBox(
              width: 74,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(hour, style: TextStyle(color: hourColor, fontSize: 12)),
                  const SizedBox(height: 8),
                  Icon(icon, size: 22, color: iconColor),
                  const SizedBox(height: 8),
                  Text(
                    '${h.tempC.toStringAsFixed(0)}°',
                    style: TextStyle(fontSize: 18, color: tempColor, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemCount: items.length,
        ),
      ),
    );
  }
}

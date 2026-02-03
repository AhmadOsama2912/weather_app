import 'package:flutter/material.dart';
import '../../domain/weather_bundle.dart';
import '../weather_code_mapper.dart';

class WeatherHeroHeader extends StatelessWidget {
  final WeatherBundle data;

  const WeatherHeroHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final condition = WeatherCodeMapper.label(data.weatherCode);

    // Theme-safe text colors
    final titleColor = cs.onSurface.withValues(alpha: isDark ? 0.92 : 0.85);
    final primaryText = cs.onSurface.withValues(alpha: isDark ? 0.95 : 0.90);
    final secondaryText = cs.onSurfaceVariant.withValues(alpha: isDark ? 0.90 : 0.85);

    return Column(
      children: [
        Text(
          data.city,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: titleColor,
              ),
        ),
        const SizedBox(height: 10),
        Text(
          '${data.currentTempC.toStringAsFixed(0)}°',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 90,
                height: 1,
                color: primaryText,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Feels Like: ${data.feelsLikeC.toStringAsFixed(0)}°',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: secondaryText,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'H:${data.maxTempC.toStringAsFixed(0)}°  L:${data.minTempC.toStringAsFixed(0)}°  •  $condition',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: secondaryText,
              ),
        ),
      ],
    );
  }
}

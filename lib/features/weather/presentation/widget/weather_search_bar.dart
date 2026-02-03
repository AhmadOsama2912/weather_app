import 'package:flutter/material.dart';
import 'package:weather_app/l10n/app_localizations.dart';

class WeatherSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const WeatherSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final fillColor = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : cs.surface.withValues(alpha: 0.92);

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.16)
        : cs.outlineVariant.withValues(alpha: 0.70);

    final iconColor = cs.onSurfaceVariant.withValues(alpha: isDark ? 0.90 : 0.85);
    final textColor = cs.onSurface.withValues(alpha: isDark ? 0.95 : 0.92);
    final hintColor = cs.onSurfaceVariant.withValues(alpha: isDark ? 0.80 : 0.75);

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => onSearch(),
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: l10n.searchHint,
              hintStyle: TextStyle(color: hintColor),
              prefixIcon: Icon(Icons.search, color: iconColor),
              filled: true,
              fillColor: fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: cs.primary.withValues(alpha: 0.85), width: 1.4),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 10),
        FilledButton(
          onPressed: onSearch,
          child: Text(l10n.search),
        ),
      ],
    );
  }
}

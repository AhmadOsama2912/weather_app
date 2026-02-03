import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    return DecoratedBox(
      decoration: BoxDecoration(gradient: AppTheme.backgroundGradient(b)),
      child: child,
    );
  }
}

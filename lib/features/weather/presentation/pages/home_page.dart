import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../settings/settings_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: Text('Weather (${settings.locale.languageCode.toUpperCase()})'),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: () => context.read<SettingsCubit>().toggleTheme(),
            icon: Icon(
              settings.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Language',
            onSelected: (code) => context.read<SettingsCubit>().setLocale(Locale(code)),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'en', child: Text('English')),
              PopupMenuItem(value: 'ar', child: Text('العربية')),
            ],
          ),
        ],
      ),
      body: const Center(
        child: Text('Step 1 done ✅ Next: Weather Feature (Cubit + API + UI)'),
      ),
    );
  }
}

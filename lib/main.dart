import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:urungano/l10n/app_localizations.dart';
import 'l10n/rw_material_localizations.dart';
import 'l10n/rw_cupertino_localizations.dart';

import 'core/router/app_router.dart';
import 'core/services/storage/hive_storage.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/settings_provider.dart';
import 'core/providers/sync_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await Hive.initFlutter();
  await HiveStorage.openBoxes();

  runApp(const ProviderScope(child: UrunganoApp()));
}

class UrunganoApp extends ConsumerWidget {
  const UrunganoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router   = ref.read(routerProvider);
    final settings = ref.watch(settingsProvider);
    ref.watch(syncProvider); // Ensure provider is initialized

    return MaterialApp.router(
      title: 'Urungano',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.highContrast,
      themeMode: settings.highContrast ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      locale: Locale(settings.language),
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        KinyarwandaMaterialLocalizations.delegate,
        KinyarwandaCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

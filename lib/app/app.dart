import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manfc/app/navigation/main_shell.dart';
import 'package:manfc/app/providers/settings_provider.dart';
import 'package:manfc/l10n/app_localizations.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return settingsAsync.when(
      data: (settings) => MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: settings.themeMode,
        locale: settings.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const MainShell(),
      ),
      loading: () => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (err, stack) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: Text('Error loading settings: $err')),
        ),
      ),
    );
  }
}
